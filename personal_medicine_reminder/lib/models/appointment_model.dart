import 'package:cloud_firestore/cloud_firestore.dart';

/// Appointment Model
/// 
/// Implements SRS 2.7 - Appointment Management
/// Contains appointment details, reminders, and visit notes
class AppointmentModel {
  final String id;
  final String userId;
  final String doctorName;
  final String? clinicName;
  final String category; // SRS 2.7.3 (SRS-109)
  final DateTime appointmentDate;
  final String status; // Upcoming, Completed, Cancelled
  final String? visitNotes; // SRS 2.7.5 (SRS-114)
  final bool reminderEnabled;
  final int? reminderMinutesBefore; // SRS 2.7.4 (SRS-112)
  final bool isRecurring; // SRS 2.7.4 (SRS-113)
  final String? recurringPattern;
  final DateTime createdAt;
  final DateTime updatedAt;

  AppointmentModel({
    required this.id,
    required this.userId,
    required this.doctorName,
    this.clinicName,
    required this.category,
    required this.appointmentDate,
    this.status = 'Upcoming',
    this.visitNotes,
    this.reminderEnabled = true,
    this.reminderMinutesBefore = 30,
    this.isRecurring = false,
    this.recurringPattern,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Check if appointment is upcoming
  bool get isUpcoming => 
      appointmentDate.isAfter(DateTime.now()) && status == 'Upcoming';

  /// Check if appointment is completed
  bool get isCompleted => status == 'Completed';

  /// Check if appointment is today
  bool get isToday {
    final now = DateTime.now();
    return appointmentDate.year == now.year &&
           appointmentDate.month == now.month &&
           appointmentDate.day == now.day;
  }

  /// Create from Firestore document
  factory AppointmentModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AppointmentModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      doctorName: data['doctorName'] ?? '',
      clinicName: data['clinicName'],
      category: data['category'] ?? 'General Checkup',
      appointmentDate: (data['appointmentDate'] as Timestamp).toDate(),
      status: data['status'] ?? 'Upcoming',
      visitNotes: data['visitNotes'],
      reminderEnabled: data['reminderEnabled'] ?? true,
      reminderMinutesBefore: data['reminderMinutesBefore'] ?? 30,
      isRecurring: data['isRecurring'] ?? false,
      recurringPattern: data['recurringPattern'],
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      updatedAt: data['updatedAt'] != null
          ? (data['updatedAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  /// Create from JSON (local storage)
  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      doctorName: json['doctorName'] ?? '',
      clinicName: json['clinicName'],
      category: json['category'] ?? 'General Checkup',
      appointmentDate: DateTime.parse(json['appointmentDate']),
      status: json['status'] ?? 'Upcoming',
      visitNotes: json['visitNotes'],
      reminderEnabled: json['reminderEnabled'] ?? true,
      reminderMinutesBefore: json['reminderMinutesBefore'] ?? 30,
      isRecurring: json['isRecurring'] ?? false,
      recurringPattern: json['recurringPattern'],
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
      'doctorName': doctorName,
      'clinicName': clinicName,
      'category': category,
      'appointmentDate': Timestamp.fromDate(appointmentDate),
      'status': status,
      'visitNotes': visitNotes,
      'reminderEnabled': reminderEnabled,
      'reminderMinutesBefore': reminderMinutesBefore,
      'isRecurring': isRecurring,
      'recurringPattern': recurringPattern,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  /// Convert to JSON (local storage)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'doctorName': doctorName,
      'clinicName': clinicName,
      'category': category,
      'appointmentDate': appointmentDate.toIso8601String(),
      'status': status,
      'visitNotes': visitNotes,
      'reminderEnabled': reminderEnabled,
      'reminderMinutesBefore': reminderMinutesBefore,
      'isRecurring': isRecurring,
      'recurringPattern': recurringPattern,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Create copy with updated fields - SRS 2.7.2
  AppointmentModel copyWith({
    String? id,
    String? userId,
    String? doctorName,
    String? clinicName,
    String? category,
    DateTime? appointmentDate,
    String? status,
    String? visitNotes,
    bool? reminderEnabled,
    int? reminderMinutesBefore,
    bool? isRecurring,
    String? recurringPattern,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AppointmentModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      doctorName: doctorName ?? this.doctorName,
      clinicName: clinicName ?? this.clinicName,
      category: category ?? this.category,
      appointmentDate: appointmentDate ?? this.appointmentDate,
      status: status ?? this.status,
      visitNotes: visitNotes ?? this.visitNotes,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      reminderMinutesBefore: reminderMinutesBefore ?? this.reminderMinutesBefore,
      isRecurring: isRecurring ?? this.isRecurring,
      recurringPattern: recurringPattern ?? this.recurringPattern,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  @override
  String toString() {
    return 'AppointmentModel(id: $id, doctorName: $doctorName, date: $appointmentDate)';
  }
}
