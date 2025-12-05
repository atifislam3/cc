import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../models/appointment_model.dart';
import '../services/database_service.dart';
import '../services/notification_service.dart';

/// Appointment Provider
/// 
/// Implements SRS 2.7 - Appointment Management
/// Manages appointments, reminders, and visit notes
class AppointmentProvider with ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  final NotificationService _notificationService = NotificationService();
  final Uuid _uuid = const Uuid();

  List<AppointmentModel> _appointments = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<AppointmentModel> get appointments => _appointments;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Get upcoming appointments - SRS 2.7.3 (SRS-110)
  List<AppointmentModel> get upcomingAppointments =>
      _appointments.where((a) => a.isUpcoming).toList()
        ..sort((a, b) => a.appointmentDate.compareTo(b.appointmentDate));

  /// Get completed appointments - SRS 2.7.6 (SRS-115)
  List<AppointmentModel> get completedAppointments =>
      _appointments.where((a) => a.isCompleted).toList()
        ..sort((a, b) => b.appointmentDate.compareTo(a.appointmentDate));

  /// Get today's appointments
  List<AppointmentModel> get todayAppointments =>
      _appointments.where((a) => a.isToday).toList()
        ..sort((a, b) => a.appointmentDate.compareTo(b.appointmentDate));

  /// Load appointments from local storage
  Future<void> loadAppointments(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _appointments = await _databaseService.getAppointments(userId);
      
      // Auto-update status for past appointments
      await _updatePastAppointmentsStatus();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load appointments.';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update status for past appointments
  Future<void> _updatePastAppointmentsStatus() async {
    final now = DateTime.now();
    for (var i = 0; i < _appointments.length; i++) {
      final appointment = _appointments[i];
      if (appointment.appointmentDate.isBefore(now) && 
          appointment.status == 'Upcoming') {
        // Mark as completed if past
        final updated = appointment.copyWith(status: 'Completed');
        await _databaseService.updateAppointment(updated);
        _appointments[i] = updated;
      }
    }
  }

  /// Add new appointment - SRS 2.7.1
  /// SRS-105, SRS-106
  Future<bool> addAppointment({
    required String userId,
    required String doctorName,
    String? clinicName,
    required String category,
    required DateTime appointmentDate,
    bool reminderEnabled = true,
    int reminderMinutesBefore = 30,
    bool isRecurring = false,
    String? recurringPattern,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final appointment = AppointmentModel(
        id: _uuid.v4(),
        userId: userId,
        doctorName: doctorName,
        clinicName: clinicName,
        category: category,
        appointmentDate: appointmentDate,
        reminderEnabled: reminderEnabled, // SRS-106
        reminderMinutesBefore: reminderMinutesBefore,
        isRecurring: isRecurring,
        recurringPattern: recurringPattern,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _databaseService.saveAppointment(appointment);
      _appointments.add(appointment);

      // Schedule reminder - SRS-106
      if (reminderEnabled) {
        await _scheduleAppointmentReminder(appointment);
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to add appointment.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Update appointment - SRS 2.7.2
  /// SRS-107, SRS-108
  Future<bool> updateAppointment(AppointmentModel appointment) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updatedAppointment = appointment.copyWith(updatedAt: DateTime.now());
      await _databaseService.updateAppointment(updatedAppointment);

      final index = _appointments.indexWhere((a) => a.id == appointment.id);
      if (index != -1) {
        _appointments[index] = updatedAppointment;
      }

      // Update reminder
      await _notificationService.cancelAppointmentReminder(appointment.id);
      if (updatedAppointment.reminderEnabled) {
        await _scheduleAppointmentReminder(updatedAppointment);
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to update appointment.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Schedule appointment reminder - SRS 2.7.4
  /// SRS-112, SRS-113
  Future<void> _scheduleAppointmentReminder(AppointmentModel appointment) async {
    if (!appointment.reminderEnabled) return;

    await _notificationService.scheduleAppointmentReminder(
      appointmentId: appointment.id,
      doctorName: appointment.doctorName,
      clinicName: appointment.clinicName,
      appointmentDate: appointment.appointmentDate,
      minutesBefore: appointment.reminderMinutesBefore ?? 30,
    );

    // SRS-113: Handle recurring reminders
    if (appointment.isRecurring && appointment.recurringPattern != null) {
      // TODO: Schedule recurring reminders based on pattern
    }
  }

  /// Mark appointment as completed - SRS 2.7.3 (SRS-111)
  Future<bool> markAsCompleted(String appointmentId) async {
    try {
      final index = _appointments.indexWhere((a) => a.id == appointmentId);
      if (index == -1) return false;

      final updatedAppointment = _appointments[index].copyWith(
        status: 'Completed',
      );
      
      await _databaseService.updateAppointment(updatedAppointment);
      _appointments[index] = updatedAppointment;

      await _notificationService.cancelAppointmentReminder(appointmentId);

      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to update appointment status.';
      notifyListeners();
      return false;
    }
  }

  /// Add visit notes - SRS 2.7.5 (SRS-114)
  Future<bool> addVisitNotes(String appointmentId, String notes) async {
    try {
      final index = _appointments.indexWhere((a) => a.id == appointmentId);
      if (index == -1) return false;

      final updatedAppointment = _appointments[index].copyWith(
        visitNotes: notes,
      );

      await _databaseService.updateAppointment(updatedAppointment);
      _appointments[index] = updatedAppointment;

      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to add visit notes.';
      notifyListeners();
      return false;
    }
  }

  /// Delete appointment
  Future<bool> deleteAppointment(String appointmentId) async {
    try {
      await _databaseService.deleteAppointment(appointmentId);
      await _notificationService.cancelAppointmentReminder(appointmentId);
      _appointments.removeWhere((a) => a.id == appointmentId);

      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to delete appointment.';
      notifyListeners();
      return false;
    }
  }

  /// Get appointment by ID
  AppointmentModel? getAppointmentById(String id) {
    try {
      return _appointments.firstWhere((a) => a.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get appointments for a specific date - SRS 2.4.3
  List<AppointmentModel> getAppointmentsForDate(DateTime date) {
    return _appointments.where((a) {
      return a.appointmentDate.year == date.year &&
             a.appointmentDate.month == date.month &&
             a.appointmentDate.day == date.day;
    }).toList()
      ..sort((a, b) => a.appointmentDate.compareTo(b.appointmentDate));
  }

  /// Filter appointments by category - SRS 2.7.6 (SRS-116)
  List<AppointmentModel> filterByCategory(String category) {
    return _appointments.where((a) => a.category == category).toList();
  }

  /// Search appointments - SRS 2.7.6 (SRS-116)
  List<AppointmentModel> searchAppointments(String query) {
    final lowerQuery = query.toLowerCase();
    return _appointments.where((a) {
      return a.doctorName.toLowerCase().contains(lowerQuery) ||
             (a.clinicName?.toLowerCase().contains(lowerQuery) ?? false) ||
             a.category.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
