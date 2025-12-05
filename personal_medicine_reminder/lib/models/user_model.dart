import 'package:cloud_firestore/cloud_firestore.dart';

/// User Model
/// 
/// Implements SRS 2.2 - Profile Management
/// Contains user profile information including basic health data
class UserModel {
  final String id;
  final String email;
  final String fullName;
  final String? profilePhotoUrl;
  final String? bloodGroup;
  final double? height; // in centimeters - SRS 2.2.3 (SRS-49)
  final double? weight; // in kilograms - SRS 2.2.3 (SRS-50)
  final String? gender;
  final DateTime? dateOfBirth;
  final bool isGoogleUser;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.id,
    required this.email,
    required this.fullName,
    this.profilePhotoUrl,
    this.bloodGroup,
    this.height,
    this.weight,
    this.gender,
    this.dateOfBirth,
    this.isGoogleUser = false,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Calculate BMI - SRS 2.2.1 (SRS-34), SRS 2.2.3 (SRS-52)
  /// BMI = weight (kg) / (height (m))^2
  double? get bmi {
    if (height == null || weight == null || height! <= 0) return null;
    final heightInMeters = height! / 100;
    return weight! / (heightInMeters * heightInMeters);
  }

  /// Get BMI category
  String? get bmiCategory {
    final bmiValue = bmi;
    if (bmiValue == null) return null;
    
    if (bmiValue < 18.5) return 'Underweight';
    if (bmiValue < 25) return 'Normal';
    if (bmiValue < 30) return 'Overweight';
    return 'Obese';
  }

  /// Calculate age from date of birth
  int? get age {
    if (dateOfBirth == null) return null;
    final now = DateTime.now();
    int age = now.year - dateOfBirth!.year;
    if (now.month < dateOfBirth!.month ||
        (now.month == dateOfBirth!.month && now.day < dateOfBirth!.day)) {
      age--;
    }
    return age;
  }

  /// Create from Firestore document
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      email: data['email'] ?? '',
      fullName: data['fullName'] ?? '',
      profilePhotoUrl: data['profilePhotoUrl'],
      bloodGroup: data['bloodGroup'],
      height: data['height']?.toDouble(),
      weight: data['weight']?.toDouble(),
      gender: data['gender'],
      dateOfBirth: data['dateOfBirth'] != null 
          ? (data['dateOfBirth'] as Timestamp).toDate() 
          : null,
      isGoogleUser: data['isGoogleUser'] ?? false,
      createdAt: data['createdAt'] != null 
          ? (data['createdAt'] as Timestamp).toDate() 
          : DateTime.now(),
      updatedAt: data['updatedAt'] != null 
          ? (data['updatedAt'] as Timestamp).toDate() 
          : DateTime.now(),
    );
  }

  /// Create from JSON (for local storage)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      fullName: json['fullName'] ?? '',
      profilePhotoUrl: json['profilePhotoUrl'],
      bloodGroup: json['bloodGroup'],
      height: json['height']?.toDouble(),
      weight: json['weight']?.toDouble(),
      gender: json['gender'],
      dateOfBirth: json['dateOfBirth'] != null 
          ? DateTime.parse(json['dateOfBirth']) 
          : null,
      isGoogleUser: json['isGoogleUser'] ?? false,
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
      'email': email,
      'fullName': fullName,
      'profilePhotoUrl': profilePhotoUrl,
      'bloodGroup': bloodGroup,
      'height': height,
      'weight': weight,
      'gender': gender,
      'dateOfBirth': dateOfBirth != null 
          ? Timestamp.fromDate(dateOfBirth!) 
          : null,
      'isGoogleUser': isGoogleUser,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  /// Convert to JSON (for local storage)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'fullName': fullName,
      'profilePhotoUrl': profilePhotoUrl,
      'bloodGroup': bloodGroup,
      'height': height,
      'weight': weight,
      'gender': gender,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'isGoogleUser': isGoogleUser,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Create copy with updated fields - SRS 2.2.2
  UserModel copyWith({
    String? id,
    String? email,
    String? fullName,
    String? profilePhotoUrl,
    String? bloodGroup,
    double? height,
    double? weight,
    String? gender,
    DateTime? dateOfBirth,
    bool? isGoogleUser,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      isGoogleUser: isGoogleUser ?? this.isGoogleUser,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, fullName: $fullName)';
  }
}
