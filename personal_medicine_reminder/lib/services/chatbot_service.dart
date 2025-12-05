import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../config/constants.dart';

/// ChatBot Service
/// 
/// Implements SRS 2.10 - ChatBot Assistant
/// Handles AI chat interactions and challenge generation
class ChatbotService {
  static final ChatbotService _instance = ChatbotService._internal();
  factory ChatbotService() => _instance;
  ChatbotService._internal();

  // Note: API key should be stored securely, not hardcoded
  String? _apiKey;

  /// Set API key
  void setApiKey(String key) {
    _apiKey = key;
  }

  /// Send message to chatbot - SRS 2.10.1 (SRS-131, SRS-132)
  Future<String> sendMessage(String message) async {
    if (_apiKey == null || _apiKey!.isEmpty) {
      return 'Chat assistant is not configured. Please contact support.';
    }

    try {
      // SRS 2.10.2 (SRS-133): Apply safety filters
      final filteredMessage = _applySafetyFilters(message);
      if (filteredMessage == null) {
        return 'I cannot respond to that request. Please ask a health-related question.';
      }

      final response = await http.post(
        Uri.parse('${AppConstants.geminiApiEndpoint}?key=$_apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {
                  'text': _buildPrompt(filteredMessage),
                }
              ]
            }
          ],
          'safetySettings': [
            {
              'category': 'HARM_CATEGORY_DANGEROUS_CONTENT',
              'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
            },
            {
              'category': 'HARM_CATEGORY_HATE_SPEECH',
              'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
            },
            {
              'category': 'HARM_CATEGORY_HARASSMENT',
              'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
            },
            {
              'category': 'HARM_CATEGORY_SEXUALLY_EXPLICIT',
              'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
            }
          ],
          'generationConfig': {
            'temperature': 0.7,
            'maxOutputTokens': 500,
          }
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final text = data['candidates']?[0]?['content']?['parts']?[0]?['text'];
        return text ?? 'I apologize, I could not generate a response.';
      } else {
        debugPrint('Chatbot API error: ${response.statusCode}');
        return 'I\'m having trouble connecting. Please try again later.';
      }
    } catch (e) {
      debugPrint('Chatbot error: $e');
      return 'An error occurred. Please try again.';
    }
  }

  /// Build prompt with context
  String _buildPrompt(String message) {
    return '''You are a helpful health assistant for the Personal Medicine Reminder app. 
Your role is to:
- Help users understand their medications
- Provide general health information
- Remind users to consult healthcare professionals for medical advice
- Be supportive and encouraging about medication adherence

Important: 
- Do not provide specific medical diagnoses
- Do not recommend specific medications
- Always encourage users to consult their doctor for medical concerns
- Be concise and helpful

User message: $message''';
  }

  /// Apply safety filters - SRS 2.10.2 (SRS-133)
  String? _applySafetyFilters(String message) {
    final lowerMessage = message.toLowerCase();
    
    // Block harmful content
    final blockedTerms = [
      'suicide', 'self-harm', 'kill myself', 'end my life',
      'overdose intentionally', 'harm others',
    ];

    for (final term in blockedTerms) {
      if (lowerMessage.contains(term)) {
        return null;
      }
    }

    // Block non-health related queries (basic filter)
    final offTopicTerms = [
      'politics', 'religion', 'gambling', 'dating',
    ];

    for (final term in offTopicTerms) {
      if (lowerMessage.contains(term)) {
        return null;
      }
    }

    return message;
  }

  /// Generate personalized challenges - SRS 2.8.2 (SRS-120)
  Future<List<String>> generatePersonalizedChallenges({
    String? mood,
    List<String>? chronicIllnesses,
    double? adherenceRate,
  }) async {
    if (_apiKey == null || _apiKey!.isEmpty) {
      throw Exception('API not configured');
    }

    try {
      final prompt = _buildChallengePrompt(
        mood: mood,
        chronicIllnesses: chronicIllnesses,
        adherenceRate: adherenceRate,
      );

      final response = await http.post(
        Uri.parse('${AppConstants.geminiApiEndpoint}?key=$_apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': prompt}
              ]
            }
          ],
          'generationConfig': {
            'temperature': 0.8,
            'maxOutputTokens': 200,
          }
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final text = data['candidates']?[0]?['content']?['parts']?[0]?['text'];
        
        if (text != null) {
          // Parse challenges from response
          return _parseChallenges(text);
        }
      }
      
      throw Exception('Failed to generate challenges');
    } catch (e) {
      debugPrint('Challenge generation error: $e');
      throw e;
    }
  }

  /// Build challenge prompt
  String _buildChallengePrompt({
    String? mood,
    List<String>? chronicIllnesses,
    double? adherenceRate,
  }) {
    final buffer = StringBuffer();
    buffer.writeln('Generate 3 simple, achievable daily health challenges.');
    buffer.writeln('Requirements:');
    buffer.writeln('- Each challenge should be completable in one day');
    buffer.writeln('- Focus on general wellness, not specific medical treatments');
    buffer.writeln('- Be encouraging and positive');
    
    if (mood != null) {
      buffer.writeln('- The user is feeling: $mood');
    }
    
    if (chronicIllnesses != null && chronicIllnesses.isNotEmpty) {
      buffer.writeln('- Consider these conditions: ${chronicIllnesses.join(", ")}');
    }
    
    if (adherenceRate != null) {
      if (adherenceRate < 0.5) {
        buffer.writeln('- Focus on building medication habits');
      } else if (adherenceRate > 0.9) {
        buffer.writeln('- Celebrate their great adherence, suggest wellness activities');
      }
    }
    
    buffer.writeln('\nFormat: Return exactly 3 challenges, one per line, no numbering.');
    
    return buffer.toString();
  }

  /// Parse challenges from API response
  List<String> _parseChallenges(String text) {
    final lines = text
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .where((line) => !line.startsWith('#'))
        .map((line) => line.replaceAll(RegExp(r'^[\d\.\-\*]+\s*'), ''))
        .where((line) => line.length > 5)
        .take(3)
        .toList();

    if (lines.isEmpty) {
      throw Exception('No valid challenges found');
    }

    return lines;
  }

  /// Get crisis resources (for safety)
  Map<String, String> getCrisisResources() {
    return {
      'National Suicide Prevention Lifeline': '988',
      'Crisis Text Line': 'Text HOME to 741741',
      'Emergency Services': '911',
    };
  }
}
