import 'package:intl/intl.dart';

/// Helper utilities for the application
class Helpers {
  // Private constructor
  Helpers._();

  /// Format date to readable string
  static String formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  /// Format date with time
  static String formatDateTime(DateTime date) {
    return DateFormat('MMM dd, yyyy hh:mm a').format(date);
  }

  /// Format time only
  static String formatTime(DateTime date) {
    return DateFormat('hh:mm a').format(date);
  }

  /// Format date for calendar
  static String formatCalendarDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly == today) {
      return 'Today';
    } else if (dateOnly == today.add(const Duration(days: 1))) {
      return 'Tomorrow';
    } else if (dateOnly == today.subtract(const Duration(days: 1))) {
      return 'Yesterday';
    } else {
      return DateFormat('EEE, MMM dd').format(date);
    }
  }

  /// Format relative time
  static String formatRelativeTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? "year" : "years"} ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? "month" : "months"} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? "day" : "days"} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? "hour" : "hours"} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? "minute" : "minutes"} ago';
    } else {
      return 'Just now';
    }
  }

  /// Calculate BMI
  static double? calculateBMI(double? height, double? weight) {
    if (height == null || weight == null || height <= 0) return null;
    final heightInMeters = height / 100;
    return weight / (heightInMeters * heightInMeters);
  }

  /// Get BMI category
  static String getBMICategory(double bmi) {
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25) return 'Normal';
    if (bmi < 30) return 'Overweight';
    return 'Obese';
  }

  /// Get BMI category color
  static String getBMICategoryColor(double bmi) {
    if (bmi < 18.5) return '#FFA500'; // Orange
    if (bmi < 25) return '#22C55E'; // Green
    if (bmi < 30) return '#F59E0B'; // Amber
    return '#EF4444'; // Red
  }

  /// Format BMI value
  static String formatBMI(double? bmi) {
    if (bmi == null) return '-';
    return bmi.toStringAsFixed(1);
  }

  /// Get greeting based on time of day
  static String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  /// Get mood emoji
  static String getMoodEmoji(String mood) {
    switch (mood.toLowerCase()) {
      case 'happy':
        return '😊';
      case 'sad':
        return '😢';
      case 'neutral':
        return '😐';
      case 'anxious':
        return '😰';
      case 'energetic':
        return '⚡';
      case 'tired':
        return '😴';
      case 'stressed':
        return '😫';
      case 'calm':
        return '😌';
      default:
        return '😊';
    }
  }

  /// Get medicine category icon
  static String getMedicineCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'tablet':
        return '💊';
      case 'capsule':
        return '💊';
      case 'syrup':
        return '🥤';
      case 'injection':
        return '💉';
      case 'insulin':
        return '💉';
      case 'inhaler':
        return '🌬️';
      case 'drops':
        return '💧';
      case 'cream':
        return '🧴';
      case 'patch':
        return '🩹';
      case 'powder':
        return '🥄';
      default:
        return '💊';
    }
  }

  /// Truncate text with ellipsis
  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  /// Capitalize first letter
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  /// Generate initials from name
  static String getInitials(String name) {
    if (name.isEmpty) return '';
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }

  /// Check if date is today
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
           date.month == now.month &&
           date.day == now.day;
  }

  /// Check if date is within range
  static bool isWithinDateRange(DateTime date, int pastDays, int futureDays) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final startDate = today.subtract(Duration(days: pastDays));
    final endDate = today.add(Duration(days: futureDays));
    
    return date.isAfter(startDate.subtract(const Duration(days: 1))) &&
           date.isBefore(endDate.add(const Duration(days: 1)));
  }

  /// Format file size
  static String formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else {
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
    }
  }

  /// Calculate adherence rate
  static double calculateAdherenceRate(int taken, int total) {
    if (total == 0) return 1.0;
    return taken / total;
  }

  /// Format percentage
  static String formatPercentage(double value) {
    return '${(value * 100).toStringAsFixed(0)}%';
  }
}
