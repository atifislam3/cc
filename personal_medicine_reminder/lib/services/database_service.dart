import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';

import '../models/medicine_model.dart';
import '../models/appointment_model.dart';
import '../models/health_record_model.dart';
import '../models/report_model.dart';
import '../models/journal_model.dart';
import '../config/constants.dart';

/// Database Service
/// 
/// Implements local storage for offline support
/// Handles medicine, appointment, and health record data
class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  Database? _database;

  /// Get database instance
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// Initialize database
  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, AppConstants.localDbName);

    return await openDatabase(
      path,
      version: AppConstants.localDbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  /// Create database tables
  Future<void> _onCreate(Database db, int version) async {
    // Medicines table
    await db.execute('''
      CREATE TABLE medicines (
        id TEXT PRIMARY KEY,
        userId TEXT NOT NULL,
        data TEXT NOT NULL,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL
      )
    ''');

    // Dose logs table
    await db.execute('''
      CREATE TABLE dose_logs (
        id TEXT PRIMARY KEY,
        medicineId TEXT NOT NULL,
        data TEXT NOT NULL,
        scheduledTime TEXT NOT NULL
      )
    ''');

    // Appointments table
    await db.execute('''
      CREATE TABLE appointments (
        id TEXT PRIMARY KEY,
        userId TEXT NOT NULL,
        data TEXT NOT NULL,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL
      )
    ''');

    // Health records table
    await db.execute('''
      CREATE TABLE health_records (
        id TEXT PRIMARY KEY,
        userId TEXT NOT NULL UNIQUE,
        data TEXT NOT NULL,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL
      )
    ''');

    // Reports table
    await db.execute('''
      CREATE TABLE reports (
        id TEXT PRIMARY KEY,
        userId TEXT NOT NULL,
        data TEXT NOT NULL,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL
      )
    ''');

    // Journal entries table
    await db.execute('''
      CREATE TABLE journal_entries (
        id TEXT PRIMARY KEY,
        userId TEXT NOT NULL,
        data TEXT NOT NULL,
        date TEXT NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');

    // Challenges table
    await db.execute('''
      CREATE TABLE challenges (
        id TEXT PRIMARY KEY,
        userId TEXT NOT NULL,
        data TEXT NOT NULL,
        date TEXT NOT NULL
      )
    ''');

    // Streak table
    await db.execute('''
      CREATE TABLE streaks (
        userId TEXT PRIMARY KEY,
        data TEXT NOT NULL,
        updatedAt TEXT NOT NULL
      )
    ''');

    // Create indexes
    await db.execute('CREATE INDEX idx_medicines_userId ON medicines(userId)');
    await db.execute('CREATE INDEX idx_dose_logs_medicineId ON dose_logs(medicineId)');
    await db.execute('CREATE INDEX idx_appointments_userId ON appointments(userId)');
    await db.execute('CREATE INDEX idx_journal_userId ON journal_entries(userId)');
  }

  /// Handle database upgrades
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle schema migrations here
  }

  // ==================== MEDICINES ====================

  /// Save medicine
  Future<void> saveMedicine(MedicineModel medicine) async {
    final db = await database;
    await db.insert(
      'medicines',
      {
        'id': medicine.id,
        'userId': medicine.userId,
        'data': jsonEncode(medicine.toJson()),
        'createdAt': medicine.createdAt.toIso8601String(),
        'updatedAt': medicine.updatedAt.toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Update medicine
  Future<void> updateMedicine(MedicineModel medicine) async {
    final db = await database;
    await db.update(
      'medicines',
      {
        'data': jsonEncode(medicine.toJson()),
        'updatedAt': medicine.updatedAt.toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [medicine.id],
    );
  }

  /// Delete medicine
  Future<void> deleteMedicine(String medicineId) async {
    final db = await database;
    await db.delete(
      'medicines',
      where: 'id = ?',
      whereArgs: [medicineId],
    );
    // Also delete associated dose logs
    await db.delete(
      'dose_logs',
      where: 'medicineId = ?',
      whereArgs: [medicineId],
    );
  }

  /// Get medicines for user
  Future<List<MedicineModel>> getMedicines(String userId) async {
    final db = await database;
    final results = await db.query(
      'medicines',
      where: 'userId = ?',
      whereArgs: [userId],
    );

    return results.map((row) {
      final data = jsonDecode(row['data'] as String) as Map<String, dynamic>;
      return MedicineModel.fromJson(data);
    }).toList();
  }

  /// Get medicine by ID
  Future<MedicineModel?> getMedicineById(String medicineId) async {
    final db = await database;
    final results = await db.query(
      'medicines',
      where: 'id = ?',
      whereArgs: [medicineId],
    );

    if (results.isEmpty) return null;

    final data = jsonDecode(results.first['data'] as String) as Map<String, dynamic>;
    return MedicineModel.fromJson(data);
  }

  // ==================== DOSE LOGS ====================

  /// Save dose log
  Future<void> saveDoseLog(DoseLog log) async {
    final db = await database;
    await db.insert(
      'dose_logs',
      {
        'id': log.id,
        'medicineId': log.medicineId,
        'data': jsonEncode(log.toJson()),
        'scheduledTime': log.scheduledTime.toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Get dose logs for date range
  Future<List<DoseLog>> getDoseLogsForDateRange(
    String userId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final db = await database;
    
    // First get all medicine IDs for the user
    final medicines = await getMedicines(userId);
    final medicineIds = medicines.map((m) => m.id).toList();
    
    if (medicineIds.isEmpty) return [];

    final placeholders = List.generate(medicineIds.length, (_) => '?').join(',');
    
    final results = await db.query(
      'dose_logs',
      where: 'medicineId IN ($placeholders) AND scheduledTime BETWEEN ? AND ?',
      whereArgs: [
        ...medicineIds,
        startDate.toIso8601String(),
        endDate.toIso8601String(),
      ],
    );

    return results.map((row) {
      final data = jsonDecode(row['data'] as String) as Map<String, dynamic>;
      return DoseLog.fromJson(data);
    }).toList();
  }

  // ==================== APPOINTMENTS ====================

  /// Save appointment
  Future<void> saveAppointment(AppointmentModel appointment) async {
    final db = await database;
    await db.insert(
      'appointments',
      {
        'id': appointment.id,
        'userId': appointment.userId,
        'data': jsonEncode(appointment.toJson()),
        'createdAt': appointment.createdAt.toIso8601String(),
        'updatedAt': appointment.updatedAt.toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Update appointment
  Future<void> updateAppointment(AppointmentModel appointment) async {
    final db = await database;
    await db.update(
      'appointments',
      {
        'data': jsonEncode(appointment.toJson()),
        'updatedAt': appointment.updatedAt.toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [appointment.id],
    );
  }

  /// Delete appointment
  Future<void> deleteAppointment(String appointmentId) async {
    final db = await database;
    await db.delete(
      'appointments',
      where: 'id = ?',
      whereArgs: [appointmentId],
    );
  }

  /// Get appointments for user
  Future<List<AppointmentModel>> getAppointments(String userId) async {
    final db = await database;
    final results = await db.query(
      'appointments',
      where: 'userId = ?',
      whereArgs: [userId],
    );

    return results.map((row) {
      final data = jsonDecode(row['data'] as String) as Map<String, dynamic>;
      return AppointmentModel.fromJson(data);
    }).toList();
  }

  // ==================== HEALTH RECORDS ====================

  /// Save health record
  Future<void> saveHealthRecord(HealthRecordModel record) async {
    final db = await database;
    await db.insert(
      'health_records',
      {
        'id': record.id,
        'userId': record.userId,
        'data': jsonEncode(record.toJson()),
        'createdAt': record.createdAt.toIso8601String(),
        'updatedAt': record.updatedAt.toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Update health record
  Future<void> updateHealthRecord(HealthRecordModel record) async {
    final db = await database;
    await db.update(
      'health_records',
      {
        'data': jsonEncode(record.toJson()),
        'updatedAt': record.updatedAt.toIso8601String(),
      },
      where: 'userId = ?',
      whereArgs: [record.userId],
    );
  }

  /// Get health record for user
  Future<HealthRecordModel?> getHealthRecord(String userId) async {
    final db = await database;
    final results = await db.query(
      'health_records',
      where: 'userId = ?',
      whereArgs: [userId],
    );

    if (results.isEmpty) return null;

    final data = jsonDecode(results.first['data'] as String) as Map<String, dynamic>;
    return HealthRecordModel.fromJson(data);
  }

  // ==================== REPORTS ====================

  /// Save report
  Future<void> saveReport(ReportModel report) async {
    final db = await database;
    await db.insert(
      'reports',
      {
        'id': report.id,
        'userId': report.userId,
        'data': jsonEncode(report.toJson()),
        'createdAt': report.createdAt.toIso8601String(),
        'updatedAt': report.updatedAt.toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Update report
  Future<void> updateReport(ReportModel report) async {
    final db = await database;
    await db.update(
      'reports',
      {
        'data': jsonEncode(report.toJson()),
        'updatedAt': report.updatedAt.toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [report.id],
    );
  }

  /// Delete report
  Future<void> deleteReport(String reportId) async {
    final db = await database;
    await db.delete(
      'reports',
      where: 'id = ?',
      whereArgs: [reportId],
    );
  }

  /// Get reports for user
  Future<List<ReportModel>> getReports(String userId) async {
    final db = await database;
    final results = await db.query(
      'reports',
      where: 'userId = ?',
      whereArgs: [userId],
    );

    return results.map((row) {
      final data = jsonDecode(row['data'] as String) as Map<String, dynamic>;
      return ReportModel.fromJson(data);
    }).toList();
  }

  /// Search reports - SRS 2.9.2 (SRS-128)
  Future<List<ReportModel>> searchReports(String userId, String query) async {
    final reports = await getReports(userId);
    final lowerQuery = query.toLowerCase();
    
    return reports.where((r) {
      return r.title.toLowerCase().contains(lowerQuery) ||
             r.reportType.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  // ==================== JOURNAL ====================

  /// Save journal entry
  Future<void> saveJournalEntry(JournalEntry entry) async {
    final db = await database;
    await db.insert(
      'journal_entries',
      {
        'id': entry.id,
        'userId': entry.userId,
        'data': jsonEncode(entry.toJson()),
        'date': entry.date.toIso8601String(),
        'createdAt': entry.createdAt.toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Update journal entry
  Future<void> updateJournalEntry(JournalEntry entry) async {
    final db = await database;
    await db.update(
      'journal_entries',
      {
        'data': jsonEncode(entry.toJson()),
      },
      where: 'id = ?',
      whereArgs: [entry.id],
    );
  }

  /// Delete journal entry
  Future<void> deleteJournalEntry(String entryId) async {
    final db = await database;
    await db.delete(
      'journal_entries',
      where: 'id = ?',
      whereArgs: [entryId],
    );
  }

  /// Get journal entries for user
  Future<List<JournalEntry>> getJournalEntries(String userId) async {
    final db = await database;
    final results = await db.query(
      'journal_entries',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'date DESC',
    );

    return results.map((row) {
      final data = jsonDecode(row['data'] as String) as Map<String, dynamic>;
      return JournalEntry.fromJson(data);
    }).toList();
  }

  // ==================== CHALLENGES ====================

  /// Save challenge
  Future<void> saveChallenge(String userId, Challenge challenge) async {
    final db = await database;
    await db.insert(
      'challenges',
      {
        'id': challenge.id,
        'userId': userId,
        'data': jsonEncode(challenge.toJson()),
        'date': challenge.date.toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Get challenges for date
  Future<List<Challenge>> getChallenges(String userId, DateTime date) async {
    final db = await database;
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    
    final results = await db.query(
      'challenges',
      where: 'userId = ? AND date BETWEEN ? AND ?',
      whereArgs: [
        userId,
        startOfDay.toIso8601String(),
        endOfDay.toIso8601String(),
      ],
    );

    return results.map((row) {
      final data = jsonDecode(row['data'] as String) as Map<String, dynamic>;
      return Challenge.fromJson(data);
    }).toList();
  }

  // ==================== STREAK ====================

  /// Save streak
  Future<void> saveStreak(StreakModel streak) async {
    final db = await database;
    await db.insert(
      'streaks',
      {
        'userId': streak.userId,
        'data': jsonEncode(streak.toJson()),
        'updatedAt': streak.updatedAt.toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Update streak
  Future<void> updateStreak(StreakModel streak) async {
    final db = await database;
    await db.update(
      'streaks',
      {
        'data': jsonEncode(streak.toJson()),
        'updatedAt': streak.updatedAt.toIso8601String(),
      },
      where: 'userId = ?',
      whereArgs: [streak.userId],
    );
  }

  /// Get streak for user
  Future<StreakModel?> getStreak(String userId) async {
    final db = await database;
    final results = await db.query(
      'streaks',
      where: 'userId = ?',
      whereArgs: [userId],
    );

    if (results.isEmpty) return null;

    final data = jsonDecode(results.first['data'] as String) as Map<String, dynamic>;
    return StreakModel.fromJson(data);
  }

  /// Close database
  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }
}
