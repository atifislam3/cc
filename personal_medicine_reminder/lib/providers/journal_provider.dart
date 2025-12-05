import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'dart:math';

import '../models/journal_model.dart';
import '../services/database_service.dart';
import '../services/chatbot_service.dart';
import '../config/constants.dart';

/// Journal Provider
/// 
/// Implements SRS 2.8 - Journaling & Motivation
/// Manages mood entries, challenges, and streak tracking
class JournalProvider with ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  final ChatbotService _chatbotService = ChatbotService();
  final Uuid _uuid = const Uuid();

  List<JournalEntry> _entries = [];
  List<Challenge> _challenges = [];
  StreakModel? _streak;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<JournalEntry> get entries => _entries;
  List<Challenge> get challenges => _challenges;
  StreakModel? get streak => _streak;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  int get currentStreak => _streak?.currentStreak ?? 0;
  int get longestStreak => _streak?.longestStreak ?? 0;

  /// Load journal data
  Future<void> loadJournalData(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _entries = await _databaseService.getJournalEntries(userId);
      _streak = await _databaseService.getStreak(userId);
      _challenges = await _databaseService.getChallenges(userId, DateTime.now());

      // Create streak if not exists
      if (_streak == null) {
        _streak = StreakModel(
          userId: userId,
          updatedAt: DateTime.now(),
        );
        await _databaseService.saveStreak(_streak!);
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load journal data.';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Add mood entry - SRS 2.8.1 (SRS-117, SRS-118)
  Future<bool> addMoodEntry({
    required String userId,
    required String mood,
    String? notes,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final entry = JournalEntry(
        id: _uuid.v4(),
        userId: userId,
        mood: mood,
        notes: notes,
        date: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _databaseService.saveJournalEntry(entry);
      _entries.insert(0, entry);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to add mood entry.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Update mood entry - SRS 2.8.1 (SRS-119)
  Future<bool> updateMoodEntry(JournalEntry entry) async {
    try {
      final updatedEntry = entry.copyWith(updatedAt: DateTime.now());
      await _databaseService.updateJournalEntry(updatedEntry);

      final index = _entries.indexWhere((e) => e.id == entry.id);
      if (index != -1) {
        _entries[index] = updatedEntry;
      }

      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to update mood entry.';
      notifyListeners();
      return false;
    }
  }

  /// Delete mood entry
  Future<bool> deleteMoodEntry(String entryId) async {
    try {
      await _databaseService.deleteJournalEntry(entryId);
      _entries.removeWhere((e) => e.id == entryId);

      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to delete mood entry.';
      notifyListeners();
      return false;
    }
  }

  /// Generate daily challenges - SRS 2.8.2 (SRS-120, SRS-121)
  Future<void> generateDailyChallenges({
    required String userId,
    String? currentMood,
    List<String>? chronicIllnesses,
    double? adherenceRate,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      List<String> challengeTitles = [];

      // SRS-120: Try to generate personalized challenges using Gemini API
      try {
        challengeTitles = await _chatbotService.generatePersonalizedChallenges(
          mood: currentMood,
          chronicIllnesses: chronicIllnesses,
          adherenceRate: adherenceRate,
        );
      } catch (e) {
        // SRS-121: Use static fallback if API fails
        debugPrint('API failed, using fallback challenges');
        challengeTitles = _getRandomFallbackChallenges(3);
      }

      // Create challenge objects
      _challenges = challengeTitles.map((title) {
        return Challenge(
          id: _uuid.v4(),
          title: title,
          date: DateTime.now(),
        );
      }).toList();

      // Save challenges
      for (final challenge in _challenges) {
        await _databaseService.saveChallenge(userId, challenge);
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      // SRS-121: Use fallback on any error
      _challenges = _getRandomFallbackChallenges(3).map((title) {
        return Challenge(
          id: _uuid.v4(),
          title: title,
          date: DateTime.now(),
        );
      }).toList();

      _isLoading = false;
      notifyListeners();
    }
  }

  /// Get random fallback challenges - SRS 2.8.2 (SRS-121)
  List<String> _getRandomFallbackChallenges(int count) {
    final random = Random();
    final challenges = List<String>.from(AppConstants.fallbackChallenges);
    challenges.shuffle(random);
    return challenges.take(count).toList();
  }

  /// Complete challenge - SRS 2.8.2 (SRS-122)
  Future<bool> completeChallenge(String challengeId) async {
    try {
      final index = _challenges.indexWhere((c) => c.id == challengeId);
      if (index == -1) return false;

      // SRS-122: Challenges are optional
      final updatedChallenge = _challenges[index].copyWith(isCompleted: true);
      _challenges[index] = updatedChallenge;

      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Skip challenge - SRS 2.8.2 (SRS-122)
  Future<bool> skipChallenge(String challengeId) async {
    try {
      final index = _challenges.indexWhere((c) => c.id == challengeId);
      if (index == -1) return false;

      // SRS-122: No penalty for skipping
      final updatedChallenge = _challenges[index].copyWith(isSkipped: true);
      _challenges[index] = updatedChallenge;

      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Update streak - SRS 2.8.3 (SRS-123, SRS-124, SRS-125)
  Future<void> updateStreak({
    required String userId,
    required bool achieved100Adherence,
  }) async {
    if (_streak == null) return;

    try {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final lastDate = _streak!.lastAdherenceDate;

      int newStreak = _streak!.currentStreak;
      int newLongestStreak = _streak!.longestStreak;

      if (achieved100Adherence) {
        if (lastDate == null) {
          // First time achieving 100%
          newStreak = 1;
        } else {
          final lastDateOnly = DateTime(lastDate.year, lastDate.month, lastDate.day);
          final difference = today.difference(lastDateOnly).inDays;

          if (difference == 1) {
            // SRS-123: Consecutive day
            newStreak++;
          } else if (difference == 0) {
            // Same day, no change
          } else {
            // SRS-125: Missed day(s), reset streak
            newStreak = 1;
          }
        }

        // Update longest streak
        if (newStreak > newLongestStreak) {
          newLongestStreak = newStreak;
        }

        _streak = _streak!.copyWith(
          currentStreak: newStreak,
          longestStreak: newLongestStreak,
          lastAdherenceDate: today,
        );
      } else {
        // SRS-125: Failed to log medication, reset streak
        if (lastDate != null) {
          final lastDateOnly = DateTime(lastDate.year, lastDate.month, lastDate.day);
          final difference = today.difference(lastDateOnly).inDays;

          if (difference >= 1) {
            _streak = _streak!.copyWith(
              currentStreak: 0,
            );
          }
        }
      }

      await _databaseService.updateStreak(_streak!);
      notifyListeners();
    } catch (e) {
      debugPrint('Error updating streak: $e');
    }
  }

  /// Get entry for today
  JournalEntry? getTodayEntry() {
    final now = DateTime.now();
    try {
      return _entries.firstWhere((e) =>
        e.date.year == now.year &&
        e.date.month == now.month &&
        e.date.day == now.day
      );
    } catch (e) {
      return null;
    }
  }

  /// Get entries for date range
  List<JournalEntry> getEntriesForDateRange(DateTime start, DateTime end) {
    return _entries.where((e) =>
      e.date.isAfter(start.subtract(const Duration(days: 1))) &&
      e.date.isBefore(end.add(const Duration(days: 1)))
    ).toList();
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
