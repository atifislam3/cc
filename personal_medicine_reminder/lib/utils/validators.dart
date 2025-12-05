import 'package:email_validator/email_validator.dart';

import '../config/constants.dart';

/// Form validators for the application
class Validators {
  // Private constructor
  Validators._();

  /// Validate email address - SRS 2.1.1 (SRS-1)
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    
    if (!EmailValidator.validate(value)) {
      return 'Please enter a valid email address';
    }
    
    return null;
  }

  /// Validate password - SRS 2.1.1 (SRS-3)
  /// Must be at least 8 characters with one uppercase letter and one number
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    
    if (value.length < AppConstants.minPasswordLength) {
      return 'Password must be at least ${AppConstants.minPasswordLength} characters';
    }
    
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }
    
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }
    
    return null;
  }

  /// Validate confirm password - SRS 2.1.5 (SRS-22)
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    
    if (value != password) {
      return 'Passwords do not match';
    }
    
    return null;
  }

  /// Validate required field - SRS 2.1.1 (SRS-4)
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  /// Validate full name - SRS 2.1.1 (SRS-1)
  static String? validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Full name is required';
    }
    
    if (value.trim().length < 2) {
      return 'Full name must be at least 2 characters';
    }
    
    if (value.trim().length > 100) {
      return 'Full name must be less than 100 characters';
    }
    
    return null;
  }

  /// Validate height - SRS 2.2.3 (SRS-49)
  static String? validateHeight(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Height is optional
    }
    
    final height = double.tryParse(value);
    if (height == null) {
      return 'Please enter a valid height';
    }
    
    if (height < 30 || height > 300) {
      return 'Height must be between 30 and 300 cm';
    }
    
    return null;
  }

  /// Validate weight - SRS 2.2.3 (SRS-50)
  static String? validateWeight(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Weight is optional
    }
    
    final weight = double.tryParse(value);
    if (weight == null) {
      return 'Please enter a valid weight';
    }
    
    if (weight < 1 || weight > 500) {
      return 'Weight must be between 1 and 500 kg';
    }
    
    return null;
  }

  /// Validate medicine name - SRS 2.3.1 (SRS-62)
  static String? validateMedicineName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Medicine name is required';
    }
    
    if (value.trim().length < 2) {
      return 'Medicine name must be at least 2 characters';
    }
    
    if (value.trim().length > 100) {
      return 'Medicine name must be less than 100 characters';
    }
    
    return null;
  }

  /// Validate dosage - SRS 2.3.1 (SRS-62)
  static String? validateDosage(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Dosage is required';
    }
    
    if (value.trim().length > 50) {
      return 'Dosage must be less than 50 characters';
    }
    
    return null;
  }

  /// Validate stock quantity - SRS 2.3.1 (SRS-65)
  static String? validateStock(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Stock is optional
    }
    
    final stock = int.tryParse(value);
    if (stock == null) {
      return 'Please enter a valid number';
    }
    
    if (stock < 0) {
      return 'Stock cannot be negative';
    }
    
    if (stock > 10000) {
      return 'Stock must be less than 10,000';
    }
    
    return null;
  }

  /// Validate doctor name - SRS 2.7.1 (SRS-105)
  static String? validateDoctorName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Doctor name is required';
    }
    
    if (value.trim().length < 2) {
      return 'Doctor name must be at least 2 characters';
    }
    
    if (value.trim().length > 100) {
      return 'Doctor name must be less than 100 characters';
    }
    
    return null;
  }

  /// Validate appointment date - SRS 2.7.1 (SRS-105)
  static String? validateAppointmentDate(DateTime? date) {
    if (date == null) {
      return 'Appointment date is required';
    }
    
    // Cannot schedule in the past (allow today)
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final appointmentDate = DateTime(date.year, date.month, date.day);
    
    if (appointmentDate.isBefore(today)) {
      return 'Cannot schedule appointment in the past';
    }
    
    // Cannot schedule more than 1 year in advance
    final maxDate = today.add(const Duration(days: 365));
    if (appointmentDate.isAfter(maxDate)) {
      return 'Cannot schedule appointment more than 1 year in advance';
    }
    
    return null;
  }

  /// Validate report title - SRS 2.9.1 (SRS-126)
  static String? validateReportTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Report title is required';
    }
    
    if (value.trim().length < 2) {
      return 'Title must be at least 2 characters';
    }
    
    if (value.trim().length > 200) {
      return 'Title must be less than 200 characters';
    }
    
    return null;
  }

  /// Validate allergy entry - SRS 2.5.1 (SRS-90)
  static String? validateAllergy(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Allergy name is required';
    }
    
    if (value.trim().length < 2) {
      return 'Allergy name must be at least 2 characters';
    }
    
    if (value.trim().length > 100) {
      return 'Allergy name must be less than 100 characters';
    }
    
    return null;
  }

  /// Validate notes field
  static String? validateNotes(String? value, {int maxLength = 1000}) {
    if (value == null || value.isEmpty) {
      return null; // Notes are optional
    }
    
    if (value.length > maxLength) {
      return 'Notes must be less than $maxLength characters';
    }
    
    return null;
  }

  /// Validate phone number (optional)
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Phone is optional
    }
    
    // Remove any non-digit characters for validation
    final digitsOnly = value.replaceAll(RegExp(r'[^\d]'), '');
    
    if (digitsOnly.length < 10) {
      return 'Phone number must be at least 10 digits';
    }
    
    if (digitsOnly.length > 15) {
      return 'Phone number must be less than 15 digits';
    }
    
    return null;
  }
}
