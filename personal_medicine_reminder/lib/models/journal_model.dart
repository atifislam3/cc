/// Journal Model
/// 
/// Implements SRS 2.8 - Journaling & Motivation
/// Contains mood entries, notes, and streak information
class JournalEntry {
  final String id;
  final String userId;
  final String mood; // SRS 2.8.1 (SRS-117)
  final String? notes; // SRS 2.8.1 (SRS-118)
  final DateTime date;
  final DateTime createdAt;
  final DateTime updatedAt;

  JournalEntry({
    required this.id,
    required this.userId,
    required this.mood,
    this.notes,
    required this.date,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create from JSON (local storage)
  factory JournalEntry.fromJson(Map<String, dynamic> json) {
    return JournalEntry(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      mood: json['mood'] ?? 'Neutral',
      notes: json['notes'],
      date: json['date'] != null
          ? DateTime.parse(json['date'])
          : DateTime.now(),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  /// Convert to JSON (local storage)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'mood': mood,
      'notes': notes,
      'date': date.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Create copy with updated fields - SRS 2.8.1 (SRS-119)
  JournalEntry copyWith({
    String? id,
    String? userId,
    String? mood,
    String? notes,
    DateTime? date,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return JournalEntry(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      mood: mood ?? this.mood,
      notes: notes ?? this.notes,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  @override
  String toString() {
    return 'JournalEntry(id: $id, mood: $mood, date: $date)';
  }
}

/// Challenge Model
/// 
/// Implements SRS 2.8.2 - User Challenges
class Challenge {
  final String id;
  final String title;
  final String? description;
  final bool isCompleted;
  final bool isSkipped;
  final DateTime date;

  Challenge({
    required this.id,
    required this.title,
    this.description,
    this.isCompleted = false,
    this.isSkipped = false,
    required this.date,
  });

  /// Create from JSON
  factory Challenge.fromJson(Map<String, dynamic> json) {
    return Challenge(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'],
      isCompleted: json['isCompleted'] ?? false,
      isSkipped: json['isSkipped'] ?? false,
      date: json['date'] != null
          ? DateTime.parse(json['date'])
          : DateTime.now(),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'isSkipped': isSkipped,
      'date': date.toIso8601String(),
    };
  }

  /// Create copy with updated fields
  Challenge copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    bool? isSkipped,
    DateTime? date,
  }) {
    return Challenge(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      isSkipped: isSkipped ?? this.isSkipped,
      date: date ?? this.date,
    );
  }
}

/// Streak Model
/// 
/// Implements SRS 2.8.3 - Visual Streak Tracker
class StreakModel {
  final String userId;
  final int currentStreak; // SRS 2.8.3 (SRS-123)
  final int longestStreak;
  final DateTime? lastAdherenceDate;
  final DateTime updatedAt;

  StreakModel({
    required this.userId,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.lastAdherenceDate,
    required this.updatedAt,
  });

  /// Create from JSON
  factory StreakModel.fromJson(Map<String, dynamic> json) {
    return StreakModel(
      userId: json['userId'] ?? '',
      currentStreak: json['currentStreak'] ?? 0,
      longestStreak: json['longestStreak'] ?? 0,
      lastAdherenceDate: json['lastAdherenceDate'] != null
          ? DateTime.parse(json['lastAdherenceDate'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'lastAdherenceDate': lastAdherenceDate?.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Create copy with updated fields
  StreakModel copyWith({
    String? userId,
    int? currentStreak,
    int? longestStreak,
    DateTime? lastAdherenceDate,
    DateTime? updatedAt,
  }) {
    return StreakModel(
      userId: userId ?? this.userId,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      lastAdherenceDate: lastAdherenceDate ?? this.lastAdherenceDate,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}
