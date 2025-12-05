import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import '../config/constants.dart';

/// Notification Service
/// 
/// Implements SRS 2.3.3, 2.6.3, 2.7.4 - Notification Management
/// Handles medicine reminders, stock alerts, and appointment reminders
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications = 
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  /// Initialize notification service
  Future<void> initialize() async {
    if (_isInitialized) return;

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Create notification channels
    await _createNotificationChannels();

    _isInitialized = true;
  }

  /// Create notification channels for Android
  Future<void> _createNotificationChannels() async {
    // Medicine reminders channel
    const medicineChannel = AndroidNotificationChannel(
      AppConstants.medicineChannelId,
      AppConstants.medicineChannelName,
      description: AppConstants.medicineChannelDescription,
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
    );

    // Appointment reminders channel
    const appointmentChannel = AndroidNotificationChannel(
      AppConstants.appointmentChannelId,
      AppConstants.appointmentChannelName,
      description: AppConstants.appointmentChannelDescription,
      importance: Importance.high,
      playSound: true,
    );

    // Stock alerts channel
    const stockChannel = AndroidNotificationChannel(
      AppConstants.stockChannelId,
      AppConstants.stockChannelName,
      description: AppConstants.stockChannelDescription,
      importance: Importance.defaultImportance,
    );

    final androidPlugin = _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    await androidPlugin?.createNotificationChannel(medicineChannel);
    await androidPlugin?.createNotificationChannel(appointmentChannel);
    await androidPlugin?.createNotificationChannel(stockChannel);
  }

  /// Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    // Handle notification tap based on payload
    final payload = response.payload;
    if (payload != null) {
      debugPrint('Notification tapped with payload: $payload');
      // Navigation will be handled by the app
    }
  }

  /// Schedule medicine reminder - SRS 2.3.3 (SRS-74, SRS-75)
  Future<void> scheduleMedicineReminder({
    required String medicineId,
    required String medicineName,
    required String dosage,
    required TimeOfDay time,
    int offsetMinutes = 0,
  }) async {
    final now = DateTime.now();
    var scheduledDate = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    ).add(Duration(minutes: offsetMinutes));

    // If time has passed today, schedule for tomorrow
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    final notificationId = _generateNotificationId(medicineId, time, offsetMinutes);

    // SRS-76: Create notification with action buttons
    final androidDetails = AndroidNotificationDetails(
      AppConstants.medicineChannelId,
      AppConstants.medicineChannelName,
      channelDescription: AppConstants.medicineChannelDescription,
      importance: Importance.high,
      priority: Priority.high,
      category: AndroidNotificationCategory.reminder,
      actions: const [
        AndroidNotificationAction('take', 'Take', showsUserInterface: true),
        AndroidNotificationAction('missed', 'Missed', showsUserInterface: true),
        AndroidNotificationAction('snooze', 'Snooze', showsUserInterface: true),
      ],
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    String title = 'Time to take your medicine';
    if (offsetMinutes < 0) {
      title = 'Medicine reminder in ${-offsetMinutes} minutes';
    } else if (offsetMinutes > 0) {
      title = 'Don\'t forget your medicine!';
    }

    await _notifications.zonedSchedule(
      notificationId,
      title,
      '$medicineName - $dosage',
      tz.TZDateTime.from(scheduledDate, tz.local),
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time, // Daily repeat
      payload: 'medicine:$medicineId',
    );
  }

  /// Cancel medicine reminders
  Future<void> cancelMedicineReminders(String medicineId) async {
    // Cancel all notifications for this medicine
    // In production, you would track notification IDs and cancel specific ones
    final pendingNotifications = await _notifications.pendingNotificationRequests();
    for (final notification in pendingNotifications) {
      if (notification.payload?.startsWith('medicine:$medicineId') == true) {
        await _notifications.cancel(notification.id);
      }
    }
  }

  /// Schedule appointment reminder - SRS 2.7.4 (SRS-112)
  Future<void> scheduleAppointmentReminder({
    required String appointmentId,
    required String doctorName,
    String? clinicName,
    required DateTime appointmentDate,
    int minutesBefore = 30,
  }) async {
    final scheduledDate = appointmentDate.subtract(Duration(minutes: minutesBefore));

    // Don't schedule if time has passed
    if (scheduledDate.isBefore(DateTime.now())) return;

    final notificationId = appointmentId.hashCode;

    final androidDetails = AndroidNotificationDetails(
      AppConstants.appointmentChannelId,
      AppConstants.appointmentChannelName,
      channelDescription: AppConstants.appointmentChannelDescription,
      importance: Importance.high,
      priority: Priority.high,
      category: AndroidNotificationCategory.reminder,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final body = clinicName != null
        ? 'Appointment with $doctorName at $clinicName'
        : 'Appointment with $doctorName';

    await _notifications.zonedSchedule(
      notificationId,
      'Upcoming Appointment',
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: 'appointment:$appointmentId',
    );
  }

  /// Cancel appointment reminder
  Future<void> cancelAppointmentReminder(String appointmentId) async {
    await _notifications.cancel(appointmentId.hashCode);
  }

  /// Show stock alert - SRS 2.6.3 (SRS-102)
  Future<void> showStockAlert({
    required String medicineId,
    required String medicineName,
    required int currentStock,
  }) async {
    final notificationId = 'stock_$medicineId'.hashCode;

    final androidDetails = AndroidNotificationDetails(
      AppConstants.stockChannelId,
      AppConstants.stockChannelName,
      channelDescription: AppConstants.stockChannelDescription,
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
    );

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      notificationId,
      'Low Stock Alert',
      '$medicineName has only $currentStock left. Time to refill!',
      notificationDetails,
      payload: 'stock:$medicineId',
    );
  }

  /// Generate unique notification ID
  int _generateNotificationId(String medicineId, TimeOfDay time, int offset) {
    return '$medicineId${time.hour}${time.minute}$offset'.hashCode;
  }

  /// Request notification permissions
  Future<bool> requestPermissions() async {
    final androidPlugin = _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    
    if (androidPlugin != null) {
      final granted = await androidPlugin.requestNotificationsPermission();
      return granted ?? false;
    }

    final iosPlugin = _notifications.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    
    if (iosPlugin != null) {
      final granted = await iosPlugin.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      return granted ?? false;
    }

    return false;
  }

  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  /// Get pending notifications
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _notifications.pendingNotificationRequests();
  }
}
