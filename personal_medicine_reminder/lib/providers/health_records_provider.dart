import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../models/health_record_model.dart';
import '../services/database_service.dart';

/// Health Records Provider
/// 
/// Implements SRS 2.5 - User Health Records
/// Manages allergies, chronic illnesses, and restraints
class HealthRecordsProvider with ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  final Uuid _uuid = const Uuid();

  HealthRecordModel? _healthRecord;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  HealthRecordModel? get healthRecord => _healthRecord;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  List<String> get allergies => _healthRecord?.allergies ?? [];
  List<String> get chronicIllnesses => _healthRecord?.chronicIllnesses ?? [];
  List<String> get restraints => _healthRecord?.restraints ?? [];

  /// Load health records from local storage
  Future<void> loadHealthRecords(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _healthRecord = await _databaseService.getHealthRecord(userId);
      
      // Create new record if not exists
      if (_healthRecord == null) {
        _healthRecord = HealthRecordModel(
          id: _uuid.v4(),
          userId: userId,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        await _databaseService.saveHealthRecord(_healthRecord!);
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load health records.';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Add allergy - SRS 2.5.1 (SRS-89)
  Future<bool> addAllergy(String allergy) async {
    if (_healthRecord == null) return false;

    try {
      // SRS-90: Validate allergy entry
      if (allergy.trim().isEmpty) {
        _errorMessage = 'Allergy name cannot be empty.';
        notifyListeners();
        return false;
      }

      // Check for duplicate
      if (_healthRecord!.allergies.contains(allergy.trim())) {
        _errorMessage = 'Allergy already exists.';
        notifyListeners();
        return false;
      }

      final updatedRecord = _healthRecord!.copyWith(
        allergies: [..._healthRecord!.allergies, allergy.trim()],
      );

      await _databaseService.updateHealthRecord(updatedRecord);
      _healthRecord = updatedRecord;

      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to add allergy.';
      notifyListeners();
      return false;
    }
  }

  /// Remove allergy - SRS 2.5.1 (SRS-89)
  Future<bool> removeAllergy(String allergy) async {
    if (_healthRecord == null) return false;

    try {
      final updatedAllergies = List<String>.from(_healthRecord!.allergies)
        ..remove(allergy);

      final updatedRecord = _healthRecord!.copyWith(
        allergies: updatedAllergies,
      );

      await _databaseService.updateHealthRecord(updatedRecord);
      _healthRecord = updatedRecord;

      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to remove allergy.';
      notifyListeners();
      return false;
    }
  }

  /// Update allergies list - SRS 2.5.1 (SRS-89)
  Future<bool> updateAllergies(List<String> allergies) async {
    if (_healthRecord == null) return false;

    try {
      final updatedRecord = _healthRecord!.copyWith(
        allergies: allergies,
      );

      await _databaseService.updateHealthRecord(updatedRecord);
      _healthRecord = updatedRecord;

      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to update allergies.';
      notifyListeners();
      return false;
    }
  }

  /// Add chronic illness - SRS 2.5.5 (SRS-96)
  Future<bool> addChronicIllness(String illness) async {
    if (_healthRecord == null) return false;

    try {
      if (illness.trim().isEmpty) {
        _errorMessage = 'Illness name cannot be empty.';
        notifyListeners();
        return false;
      }

      if (_healthRecord!.chronicIllnesses.contains(illness.trim())) {
        _errorMessage = 'Illness already exists.';
        notifyListeners();
        return false;
      }

      final updatedRecord = _healthRecord!.copyWith(
        chronicIllnesses: [..._healthRecord!.chronicIllnesses, illness.trim()],
      );

      await _databaseService.updateHealthRecord(updatedRecord);
      _healthRecord = updatedRecord;

      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to add chronic illness.';
      notifyListeners();
      return false;
    }
  }

  /// Remove chronic illness - SRS 2.5.5 (SRS-96)
  Future<bool> removeChronicIllness(String illness) async {
    if (_healthRecord == null) return false;

    try {
      final updatedIllnesses = List<String>.from(_healthRecord!.chronicIllnesses)
        ..remove(illness);

      final updatedRecord = _healthRecord!.copyWith(
        chronicIllnesses: updatedIllnesses,
      );

      await _databaseService.updateHealthRecord(updatedRecord);
      _healthRecord = updatedRecord;

      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to remove chronic illness.';
      notifyListeners();
      return false;
    }
  }

  /// Update chronic illnesses list - SRS 2.5.5 (SRS-96)
  Future<bool> updateChronicIllnesses(List<String> illnesses) async {
    if (_healthRecord == null) return false;

    try {
      final updatedRecord = _healthRecord!.copyWith(
        chronicIllnesses: illnesses,
      );

      await _databaseService.updateHealthRecord(updatedRecord);
      _healthRecord = updatedRecord;

      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to update chronic illnesses.';
      notifyListeners();
      return false;
    }
  }

  /// Add restraint - SRS 2.5.4 (SRS-95)
  Future<bool> addRestraint(String restraint) async {
    if (_healthRecord == null) return false;

    try {
      if (restraint.trim().isEmpty) {
        _errorMessage = 'Restraint cannot be empty.';
        notifyListeners();
        return false;
      }

      if (_healthRecord!.restraints.contains(restraint.trim())) {
        _errorMessage = 'Restraint already exists.';
        notifyListeners();
        return false;
      }

      final updatedRecord = _healthRecord!.copyWith(
        restraints: [..._healthRecord!.restraints, restraint.trim()],
      );

      await _databaseService.updateHealthRecord(updatedRecord);
      _healthRecord = updatedRecord;

      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to add restraint.';
      notifyListeners();
      return false;
    }
  }

  /// Remove restraint - SRS 2.5.4 (SRS-95)
  Future<bool> removeRestraint(String restraint) async {
    if (_healthRecord == null) return false;

    try {
      final updatedRestraints = List<String>.from(_healthRecord!.restraints)
        ..remove(restraint);

      final updatedRecord = _healthRecord!.copyWith(
        restraints: updatedRestraints,
      );

      await _databaseService.updateHealthRecord(updatedRecord);
      _healthRecord = updatedRecord;

      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to remove restraint.';
      notifyListeners();
      return false;
    }
  }

  /// Update restraints list - SRS 2.5.4 (SRS-95)
  Future<bool> updateRestraints(List<String> restraints) async {
    if (_healthRecord == null) return false;

    try {
      final updatedRecord = _healthRecord!.copyWith(
        restraints: restraints,
      );

      await _databaseService.updateHealthRecord(updatedRecord);
      _healthRecord = updatedRecord;

      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to update restraints.';
      notifyListeners();
      return false;
    }
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
