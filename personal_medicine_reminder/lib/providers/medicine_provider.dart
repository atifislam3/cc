import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../models/medicine_model.dart';
import '../services/database_service.dart';
import '../services/notification_service.dart';
import '../config/constants.dart';

/// Medicine Provider
/// 
/// Implements SRS 2.3 - Medicine Management
/// Manages medicines, reminders, and dose tracking
class MedicineProvider with ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  final NotificationService _notificationService = NotificationService();
  final Uuid _uuid = const Uuid();

  List<MedicineModel> _medicines = [];
  List<DoseLog> _doseLogs = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<MedicineModel> get medicines => _medicines;
  List<DoseLog> get doseLogs => _doseLogs;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Get active medicines - SRS 2.5.2 (SRS-91)
  List<MedicineModel> get activeMedicines => 
      _medicines.where((m) => m.isActive).toList();

  /// Get past medicines - SRS 2.5.3 (SRS-93)
  List<MedicineModel> get pastMedicines => 
      _medicines.where((m) => !m.isActive).toList();

  /// Get low stock medicines - SRS 2.6.1 (SRS-98)
  List<MedicineModel> get lowStockMedicines =>
      _medicines.where((m) => m.isLowStock && m.isActive).toList();

  /// Load medicines from local storage
  Future<void> loadMedicines(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _medicines = await _databaseService.getMedicines(userId);
      
      // Sort to show low stock first - SRS 2.6.1 (SRS-98)
      _medicines.sort((a, b) {
        if (a.isLowStock && !b.isLowStock) return -1;
        if (!a.isLowStock && b.isLowStock) return 1;
        return a.name.compareTo(b.name);
      });

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load medicines.';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Add new medicine - SRS 2.3.1
  /// SRS-62 to SRS-68
  Future<bool> addMedicine({
    required String userId,
    required String name,
    required String category,
    required String dosage,
    String? description,
    int initialStock = 0,
    List<ReminderSchedule>? reminders,
    ScheduleType scheduleType = ScheduleType.daily,
    ScheduleConfig? scheduleConfig,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final medicine = MedicineModel(
        id: _uuid.v4(),
        userId: userId,
        name: name,
        category: category, // SRS-82
        dosage: dosage,
        description: description,
        currentStock: initialStock, // SRS-65
        reminders: reminders ?? [],
        scheduleType: scheduleType, // SRS-64
        scheduleConfig: scheduleConfig,
        startDate: startDate,
        endDate: endDate,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // SRS-67: Save to local storage
      await _databaseService.saveMedicine(medicine);
      _medicines.add(medicine);

      // Schedule notifications for reminders - SRS-63
      await _scheduleReminders(medicine);

      // SRS-68: Success notification handled by UI
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to add medicine.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Update medicine - SRS 2.3.2
  /// SRS-69 to SRS-73
  Future<bool> updateMedicine(MedicineModel medicine) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updatedMedicine = medicine.copyWith(updatedAt: DateTime.now());
      
      // SRS-72: Save to local storage
      await _databaseService.updateMedicine(updatedMedicine);
      
      final index = _medicines.indexWhere((m) => m.id == medicine.id);
      if (index != -1) {
        _medicines[index] = updatedMedicine;
      }

      // Update reminders - SRS-70
      await _notificationService.cancelMedicineReminders(medicine.id);
      await _scheduleReminders(updatedMedicine);

      // SRS-73: Success notification handled by UI
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to update medicine.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Schedule reminders for medicine - SRS 2.3.3
  /// SRS-74 to SRS-78
  Future<void> _scheduleReminders(MedicineModel medicine) async {
    if (!medicine.alertEnabled || medicine.reminders.isEmpty) return;

    for (final reminder in medicine.reminders) {
      if (!reminder.isEnabled) continue;

      // SRS-75: Multiple notifications per dose
      for (final offset in reminder.notificationOffsets) {
        await _notificationService.scheduleMedicineReminder(
          medicineId: medicine.id,
          medicineName: medicine.name,
          dosage: medicine.dosage,
          time: reminder.time,
          offsetMinutes: offset,
        );
      }
    }
  }

  /// Disable medicine alerts - SRS 2.3.4
  /// SRS-79 to SRS-81
  Future<bool> disableMedicineAlert(String medicineId) async {
    try {
      final index = _medicines.indexWhere((m) => m.id == medicineId);
      if (index == -1) return false;

      // SRS-79: Disable notifications
      final updatedMedicine = _medicines[index].copyWith(alertEnabled: false);
      await _databaseService.updateMedicine(updatedMedicine);
      _medicines[index] = updatedMedicine;

      // SRS-81: Update reminder system
      await _notificationService.cancelMedicineReminders(medicineId);

      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to disable alert.';
      notifyListeners();
      return false;
    }
  }

  /// Enable medicine alerts
  Future<bool> enableMedicineAlert(String medicineId) async {
    try {
      final index = _medicines.indexWhere((m) => m.id == medicineId);
      if (index == -1) return false;

      final updatedMedicine = _medicines[index].copyWith(alertEnabled: true);
      await _databaseService.updateMedicine(updatedMedicine);
      _medicines[index] = updatedMedicine;

      await _scheduleReminders(updatedMedicine);

      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to enable alert.';
      notifyListeners();
      return false;
    }
  }

  /// Record dose status - SRS 2.3.3 (SRS-77)
  Future<bool> recordDose({
    required String medicineId,
    required DateTime scheduledTime,
    required DoseStatus status,
    String? notes,
  }) async {
    try {
      final doseLog = DoseLog(
        id: _uuid.v4(),
        medicineId: medicineId,
        scheduledTime: scheduledTime,
        takenTime: status == DoseStatus.taken ? DateTime.now() : null,
        status: status,
        notes: notes,
      );

      await _databaseService.saveDoseLog(doseLog);
      _doseLogs.add(doseLog);

      // Update stock if taken
      if (status == DoseStatus.taken) {
        await _decrementStock(medicineId);
      }

      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to record dose.';
      notifyListeners();
      return false;
    }
  }

  /// Update stock quantity - SRS 2.6.2
  /// SRS-99 to SRS-101
  Future<bool> updateStock(String medicineId, int newQuantity) async {
    try {
      final index = _medicines.indexWhere((m) => m.id == medicineId);
      if (index == -1) return false;

      final updatedMedicine = _medicines[index].copyWith(
        currentStock: newQuantity,
      );
      
      // SRS-100: Save locally
      await _databaseService.updateMedicine(updatedMedicine);
      _medicines[index] = updatedMedicine;

      // SRS-104: Check for low stock alert
      if (updatedMedicine.isLowStock) {
        await _notificationService.showStockAlert(
          medicineId: medicineId,
          medicineName: updatedMedicine.name,
          currentStock: newQuantity,
        );
      }

      // SRS-101: Success message handled by UI
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to update stock.';
      notifyListeners();
      return false;
    }
  }

  /// Decrement stock when dose is taken
  Future<void> _decrementStock(String medicineId) async {
    final index = _medicines.indexWhere((m) => m.id == medicineId);
    if (index == -1) return;

    final medicine = _medicines[index];
    if (medicine.currentStock > 0) {
      await updateStock(medicineId, medicine.currentStock - 1);
    }
  }

  /// Mark medicine as completed - SRS 2.5.2 (SRS-92)
  Future<bool> markMedicineCompleted(String medicineId) async {
    try {
      final index = _medicines.indexWhere((m) => m.id == medicineId);
      if (index == -1) return false;

      final updatedMedicine = _medicines[index].copyWith(isActive: false);
      await _databaseService.updateMedicine(updatedMedicine);
      _medicines[index] = updatedMedicine;

      await _notificationService.cancelMedicineReminders(medicineId);

      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to update medicine status.';
      notifyListeners();
      return false;
    }
  }

  /// Delete medicine
  Future<bool> deleteMedicine(String medicineId) async {
    try {
      await _databaseService.deleteMedicine(medicineId);
      await _notificationService.cancelMedicineReminders(medicineId);
      _medicines.removeWhere((m) => m.id == medicineId);

      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to delete medicine.';
      notifyListeners();
      return false;
    }
  }

  /// Get medicine by ID
  MedicineModel? getMedicineById(String id) {
    try {
      return _medicines.firstWhere((m) => m.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get medicines for a specific date - SRS 2.4.2, SRS 2.4.3
  List<MedicineModel> getMedicinesForDate(DateTime date) {
    return _medicines.where((medicine) {
      if (!medicine.isActive || !medicine.alertEnabled) return false;

      // Check schedule type
      switch (medicine.scheduleType) {
        case ScheduleType.daily:
          return true;
        case ScheduleType.weekly:
          return medicine.scheduleConfig?.weekDays?.contains(date.weekday % 7) ?? false;
        case ScheduleType.interval:
          if (medicine.startDate == null) return false;
          final daysSinceStart = date.difference(medicine.startDate!).inDays;
          return daysSinceStart % (medicine.scheduleConfig?.intervalDays ?? 1) == 0;
        case ScheduleType.cyclic:
          if (medicine.startDate == null) return false;
          final config = medicine.scheduleConfig;
          if (config == null) return false;
          final daysSinceStart = date.difference(medicine.startDate!).inDays;
          final cycleLength = (config.cycleDaysOn ?? 0) + (config.cycleDaysOff ?? 0);
          if (cycleLength == 0) return false;
          final dayInCycle = daysSinceStart % cycleLength;
          return dayInCycle < (config.cycleDaysOn ?? 0);
      }
    }).toList();
  }

  /// Get dose logs for date range - SRS 2.13
  Future<List<DoseLog>> getDoseLogsForDateRange(
    String userId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    return await _databaseService.getDoseLogsForDateRange(
      userId,
      startDate,
      endDate,
    );
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
