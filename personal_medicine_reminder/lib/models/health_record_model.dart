import 'package:cloud_firestore/cloud_firestore.dart';

/// Health Record Model
/// 
/// Implements SRS 2.5 - User Health Records
/// Contains allergies, chronic illnesses, and restraints
class HealthRecordModel {
  final String id;
  final String userId;
  final List<String> allergies; // SRS 2.5.1 (SRS-89)
  final List<String> chronicIllnesses; // SRS 2.5.5 (SRS-96)
  final List<String> restraints; // SRS 2.5.4 (SRS-95)
  final DateTime createdAt;
  final DateTime updatedAt;

  HealthRecordModel({
    required this.id,
    required this.userId,
    this.allergies = const [],
    this.chronicIllnesses = const [],
    this.restraints = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create from Firestore document
  factory HealthRecordModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return HealthRecordModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      allergies: List<String>.from(data['allergies'] ?? []),
      chronicIllnesses: List<String>.from(data['chronicIllnesses'] ?? []),
      restraints: List<String>.from(data['restraints'] ?? []),
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      updatedAt: data['updatedAt'] != null
          ? (data['updatedAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  /// Create from JSON (local storage)
  factory HealthRecordModel.fromJson(Map<String, dynamic> json) {
    return HealthRecordModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      allergies: List<String>.from(json['allergies'] ?? []),
      chronicIllnesses: List<String>.from(json['chronicIllnesses'] ?? []),
      restraints: List<String>.from(json['restraints'] ?? []),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  /// Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'allergies': allergies,
      'chronicIllnesses': chronicIllnesses,
      'restraints': restraints,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  /// Convert to JSON (local storage)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'allergies': allergies,
      'chronicIllnesses': chronicIllnesses,
      'restraints': restraints,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Create copy with updated fields
  HealthRecordModel copyWith({
    String? id,
    String? userId,
    List<String>? allergies,
    List<String>? chronicIllnesses,
    List<String>? restraints,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return HealthRecordModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      allergies: allergies ?? this.allergies,
      chronicIllnesses: chronicIllnesses ?? this.chronicIllnesses,
      restraints: restraints ?? this.restraints,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  @override
  String toString() {
    return 'HealthRecordModel(id: $id, userId: $userId)';
  }
}
