/// Application Constants
/// 
/// Contains all constant values used throughout the application
class AppConstants {
  // Private constructor
  AppConstants._();

  // App Info
  static const String appName = 'Personal Medicine Reminder';
  static const String appVersion = '1.1.0';
  static const String appDescription = 
      'A comprehensive health management application designed to help users manage '
      'their daily medication intake, appointments, and health information.';

  // Authors - SRS Document
  static const List<String> authors = ['Atif Islam', 'Muhammad Awais Ali'];
  static const String releaseDate = 'November 27, 2025';

  // Firebase Collections
  static const String usersCollection = 'users';
  static const String medicinesCollection = 'medicines';
  static const String appointmentsCollection = 'appointments';
  static const String healthRecordsCollection = 'health_records';
  static const String reportsCollection = 'reports';
  static const String journalCollection = 'journal';
  
  // Local Database
  static const String localDbName = 'pmra_database.db';
  static const int localDbVersion = 1;
  
  // Hive Boxes
  static const String settingsBox = 'settings';
  static const String medicinesBox = 'medicines';
  static const String remindersBox = 'reminders';
  static const String offlineDataBox = 'offline_data';

  // Shared Preferences Keys
  static const String themeKey = 'app_theme';
  static const String notificationSoundKey = 'notification_sound';
  static const String notificationStyleKey = 'notification_style';
  static const String timezoneKey = 'timezone';
  static const String firstLaunchKey = 'first_launch';
  static const String userIdKey = 'user_id';

  // Password Requirements - SRS 2.1.1 (SRS-3)
  static const int minPasswordLength = 8;
  static const String passwordRegex = 
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d@$!%*?&]{8,}$';

  // Medicine Categories - SRS 2.3.5
  static const List<String> medicineCategories = [
    'Tablet',
    'Capsule',
    'Syrup',
    'Injection',
    'Insulin',
    'Inhaler',
    'Drops',
    'Cream',
    'Patch',
    'Powder',
    'Other',
  ];

  // Blood Groups - SRS 2.2
  static const List<String> bloodGroups = [
    'A+', 'A-',
    'B+', 'B-',
    'AB+', 'AB-',
    'O+', 'O-',
  ];

  // Gender Options - SRS 2.2
  static const List<String> genderOptions = [
    'Male',
    'Female',
    'Other',
    'Prefer not to say',
  ];

  // Mood Options - SRS 2.8.1 (SRS-117)
  static const List<String> moodOptions = [
    'Happy',
    'Sad',
    'Neutral',
    'Anxious',
    'Energetic',
    'Tired',
    'Stressed',
    'Calm',
  ];

  // Appointment Categories - SRS 2.7.3
  static const List<String> appointmentCategories = [
    'General Checkup',
    'Follow-up',
    'Specialist',
    'Lab Test',
    'Vaccination',
    'Emergency',
    'Dental',
    'Eye Care',
    'Therapy',
    'Other',
  ];

  // Appointment Status - SRS 2.7.3 (SRS-109)
  static const String statusUpcoming = 'Upcoming';
  static const String statusCompleted = 'Completed';
  static const String statusCancelled = 'Cancelled';

  // Notification Settings - SRS 2.3.3 (SRS-75)
  static const List<int> reminderOffsets = [
    -30, // 30 minutes before
    -15, // 15 minutes before
    -5,  // 5 minutes before
    0,   // At exact time
    5,   // 5 minutes after
    10,  // 10 minutes after
  ];

  // Stock Threshold - SRS 2.6 (SRS-98)
  static const int lowStockThreshold = 5;

  // Calendar Date Range - SRS 2.4.4 (SRS-88)
  static const int calendarPastDays = 15;
  static const int calendarFutureDays = 15;

  // API Endpoints
  static const String geminiApiEndpoint = 
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent';

  // Notification Channel IDs
  static const String medicineChannelId = 'medicine_reminders';
  static const String medicineChannelName = 'Medicine Reminders';
  static const String medicineChannelDescription = 
      'Notifications for medicine reminders';

  static const String appointmentChannelId = 'appointment_reminders';
  static const String appointmentChannelName = 'Appointment Reminders';
  static const String appointmentChannelDescription = 
      'Notifications for appointment reminders';

  static const String stockChannelId = 'stock_alerts';
  static const String stockChannelName = 'Stock Alerts';
  static const String stockChannelDescription = 
      'Notifications for low stock alerts';

  // Image Settings
  static const int maxImageWidth = 800;
  static const int maxImageHeight = 800;
  static const int imageQuality = 85;

  // Error Messages
  static const String networkError = 
      'Please check your internet connection and try again.';
  static const String unknownError = 
      'An unexpected error occurred. Please try again.';
  static const String authError = 
      'Authentication failed. Please check your credentials.';

  // Success Messages
  static const String profileUpdateSuccess = 
      'Profile updated successfully!';
  static const String medicineAddSuccess = 
      'Medicine added successfully!';
  static const String appointmentAddSuccess = 
      'Appointment added successfully!';
  static const String passwordChangeSuccess = 
      'Password changed successfully!';

  // Static Fallback Challenges - SRS 2.8.2 (SRS-121)
  static const List<String> fallbackChallenges = [
    'Drink 8 glasses of water today',
    'Take a 10-minute walk',
    'Practice deep breathing for 5 minutes',
    'Get 7-8 hours of sleep tonight',
    'Eat a serving of fruits or vegetables',
    'Stretch for 5 minutes',
    'Take your vitamins on time',
    'Avoid sugary drinks today',
    'Stand up and move every hour',
    'Write down 3 things you are grateful for',
  ];
}
