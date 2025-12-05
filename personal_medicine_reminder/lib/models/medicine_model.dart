import 'package:flutter/material.dart';

/// Medicine Model
/// 
/// Implements SRS 2.3 - Medicine Management
/// Contains medicine details, dosage, and reminder schedules
class MedicineModel {
  final String id;
  final String userId;
  final String name;
  final String category; // SRS 2.3.5 (SRS-82)
  final String? description;
  final String dosage; // e.g., "500mg", "10ml"
  final int currentStock; // SRS 2.6.1 (SRS-97)
  final bool isActive; // SRS 2.5.2 (SRS-92)
  final bool alertEnabled; // SRS 2.3.4 (SRS-79)
  final List<ReminderSchedule> reminders; // SRS 2.3.3
  final ScheduleType scheduleType; // SRS 2.3.1 (SRS-64)
  final ScheduleConfig? scheduleConfig;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? startDate;
  final DateTime? endDate;

  MedicineModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.category,
    this.description,
    required this.dosage,
    this.currentStock = 0,
    this.isActive = true,
    this.alertEnabled = true,
    this.reminders = const [],
    this.scheduleType = ScheduleType.daily,
    this.scheduleConfig,
    required this.createdAt,
    required this.updatedAt,
    this.startDate,
    this.endDate,
  });

  /// Check if stock is low - SRS 2.6.3 (SRS-102)
  bool get isLowStock => currentStock <= 5;

  /// Create from JSON (local storage)
  factory MedicineModel.fromJson(Map<String, dynamic> json) {
    return MedicineModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      name: json['name'] ?? '',
      category: json['category'] ?? 'Tablet',
      description: json['description'],
      dosage: json['dosage'] ?? '',
      currentStock: json['currentStock'] ?? 0,
      isActive: json['isActive'] ?? true,
      alertEnabled: json['alertEnabled'] ?? true,
      reminders: (json['reminders'] as List<dynamic>?)
          ?.map((r) => ReminderSchedule.fromJson(r))
          .toList() ?? [],
      scheduleType: ScheduleType.values.firstWhere(
        (e) => e.name == json['scheduleType'],
        orElse: () => ScheduleType.daily,
      ),
      scheduleConfig: json['scheduleConfig'] != null
          ? ScheduleConfig.fromJson(json['scheduleConfig'])
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'])
          : null,
      endDate: json['endDate'] != null
          ? DateTime.parse(json['endDate'])
          : null,
    );
  }

  /// Convert to JSON (local storage)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'category': category,
      'description': description,
      'dosage': dosage,
      'currentStock': currentStock,
      'isActive': isActive,
      'alertEnabled': alertEnabled,
      'reminders': reminders.map((r) => r.toJson()).toList(),
      'scheduleType': scheduleType.name,
      'scheduleConfig': scheduleConfig?.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
    };
  }

  /// Create copy with updated fields - SRS 2.3.2
  MedicineModel copyWith({
    String? id,
    String? userId,
    String? name,
    String? category,
    String? description,
    String? dosage,
    int? currentStock,
    bool? isActive,
    bool? alertEnabled,
    List<ReminderSchedule>? reminders,
    ScheduleType? scheduleType,
    ScheduleConfig? scheduleConfig,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return MedicineModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      category: category ?? this.category,
      description: description ?? this.description,
      dosage: dosage ?? this.dosage,
      currentStock: currentStock ?? this.currentStock,
      isActive: isActive ?? this.isActive,
      alertEnabled: alertEnabled ?? this.alertEnabled,
      reminders: reminders ?? this.reminders,
      scheduleType: scheduleType ?? this.scheduleType,
      scheduleConfig: scheduleConfig ?? this.scheduleConfig,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }

  @override
  String toString() {
    return 'MedicineModel(id: $id, name: $name, dosage: $dosage)';
  }
}

/// Schedule Type - SRS 2.3.1 (SRS-64)
/// Supports complex schedules including daily, weekly, interval-based, and cyclic
enum ScheduleType {
  daily,       // Every day
  weekly,      // Specific days of the week
  interval,    // Every X days
  cyclic,      // X days on, Y days off
}

/// Schedule Configuration
class ScheduleConfig {
  final List<int>? weekDays; // For weekly: 0-6 (Sunday-Saturday)
  final int? intervalDays; // For interval: every X days
  final int? cycleDaysOn; // For cyclic: X days on
  final int? cycleDaysOff; // For cyclic: Y days off

  ScheduleConfig({
    this.weekDays,
    this.intervalDays,
    this.cycleDaysOn,
    this.cycleDaysOff,
  });

  factory ScheduleConfig.fromJson(Map<String, dynamic> json) {
    return ScheduleConfig(
      weekDays: (json['weekDays'] as List<dynamic>?)?.cast<int>(),
      intervalDays: json['intervalDays'],
      cycleDaysOn: json['cycleDaysOn'],
      cycleDaysOff: json['cycleDaysOff'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'weekDays': weekDays,
      'intervalDays': intervalDays,
      'cycleDaysOn': cycleDaysOn,
      'cycleDaysOff': cycleDaysOff,
    };
  }
}

/// Reminder Schedule - SRS 2.3.3 (SRS-74, SRS-75)
/// Supports multiple notifications per dose
class ReminderSchedule {
  final String id;
  final TimeOfDay time;
  final List<int> notificationOffsets; // Minutes before/after: -5, 0, 5 (SRS-75)
  final bool isEnabled;

  ReminderSchedule({
    required this.id,
    required this.time,
    this.notificationOffsets = const [-5, 0, 5], // Default: 5 min before, at time, 5 min after
    this.isEnabled = true,
  });

  factory ReminderSchedule.fromJson(Map<String, dynamic> json) {
    return ReminderSchedule(
      id: json['id'] ?? '',
      time: TimeOfDay(
        hour: json['hour'] ?? 8,
        minute: json['minute'] ?? 0,
      ),
      notificationOffsets: (json['notificationOffsets'] as List<dynamic>?)
          ?.cast<int>() ?? [-5, 0, 5],
      isEnabled: json['isEnabled'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hour': time.hour,
      'minute': time.minute,
      'notificationOffsets': notificationOffsets,
      'isEnabled': isEnabled,
    };
  }

  String get formattedTime {
    final hour = time.hour > 12 ? time.hour - 12 : (time.hour == 0 ? 12 : time.hour);
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '${hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')} $period';
  }

  ReminderSchedule copyWith({
    String? id,
    TimeOfDay? time,
    List<int>? notificationOffsets,
    bool? isEnabled,
  }) {
    return ReminderSchedule(
      id: id ?? this.id,
      time: time ?? this.time,
      notificationOffsets: notificationOffsets ?? this.notificationOffsets,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }
}

/// Dose Log - SRS 2.3.3 (SRS-77)
/// Records status of each dose
class DoseLog {
  final String id;
  final String medicineId;
  final DateTime scheduledTime;
  final DateTime? takenTime;
  final DoseStatus status;
  final String? notes;

  DoseLog({
    required this.id,
    required this.medicineId,
    required this.scheduledTime,
    this.takenTime,
    this.status = DoseStatus.pending,
    this.notes,
  });

  factory DoseLog.fromJson(Map<String, dynamic> json) {
    return DoseLog(
      id: json['id'] ?? '',
      medicineId: json['medicineId'] ?? '',
      scheduledTime: DateTime.parse(json['scheduledTime']),
      takenTime: json['takenTime'] != null
          ? DateTime.parse(json['takenTime'])
          : null,
      status: DoseStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => DoseStatus.pending,
      ),
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'medicineId': medicineId,
      'scheduledTime': scheduledTime.toIso8601String(),
      'takenTime': takenTime?.toIso8601String(),
      'status': status.name,
      'notes': notes,
    };
  }
}

/// Dose Status - SRS 2.3.3 (SRS-76, SRS-77)
enum DoseStatus {
  pending,
  taken,
  missed,
  snoozed,
}
