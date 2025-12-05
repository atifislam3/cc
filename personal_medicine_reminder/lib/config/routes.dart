import 'package:flutter/material.dart';

// Auth Screens
import '../screens/auth/splash_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/auth/change_password_screen.dart';

// Main Screens
import '../screens/home/home_screen.dart';
import '../screens/home/main_navigation_screen.dart';

// Medicine Screens
import '../screens/medicine/medicine_list_screen.dart';
import '../screens/medicine/add_medicine_screen.dart';
import '../screens/medicine/medicine_detail_screen.dart';

// Schedule Screens
import '../screens/schedule/schedule_screen.dart';
import '../screens/schedule/calendar_screen.dart';

// Health Records Screens
import '../screens/health_records/health_records_screen.dart';
import '../screens/health_records/allergies_screen.dart';
import '../screens/health_records/chronic_illnesses_screen.dart';

// Inventory Screens
import '../screens/inventory/inventory_screen.dart';

// Appointment Screens
import '../screens/appointments/appointments_screen.dart';
import '../screens/appointments/add_appointment_screen.dart';
import '../screens/appointments/appointment_detail_screen.dart';

// Journal Screens
import '../screens/journal/journal_screen.dart';
import '../screens/journal/add_mood_screen.dart';
import '../screens/journal/challenges_screen.dart';

// Report Screens
import '../screens/reports/reports_screen.dart';
import '../screens/reports/add_report_screen.dart';
import '../screens/reports/report_viewer_screen.dart';

// ChatBot Screens
import '../screens/chatbot/chatbot_screen.dart';

// Settings Screens
import '../screens/settings/settings_screen.dart';
import '../screens/settings/notification_settings_screen.dart';

// Profile Screens
import '../screens/profile/profile_screen.dart';
import '../screens/profile/edit_profile_screen.dart';

// Analytics Screens
import '../screens/analytics/analytics_screen.dart';

// Help & Support
import '../screens/help/help_screen.dart';
import '../screens/help/about_screen.dart';

/// Application Routes Configuration
/// 
/// Manages navigation throughout the app
class AppRoutes {
  // Private constructor
  AppRoutes._();

  // Route names
  static const String splash = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String changePassword = '/change-password';
  
  static const String mainNavigation = '/main';
  static const String home = '/home';
  
  static const String medicineList = '/medicines';
  static const String addMedicine = '/medicines/add';
  static const String medicineDetail = '/medicines/detail';
  
  static const String schedule = '/schedule';
  static const String calendar = '/calendar';
  
  static const String healthRecords = '/health-records';
  static const String allergies = '/health-records/allergies';
  static const String chronicIllnesses = '/health-records/chronic-illnesses';
  
  static const String inventory = '/inventory';
  
  static const String appointments = '/appointments';
  static const String addAppointment = '/appointments/add';
  static const String appointmentDetail = '/appointments/detail';
  
  static const String journal = '/journal';
  static const String addMood = '/journal/add-mood';
  static const String challenges = '/journal/challenges';
  
  static const String reports = '/reports';
  static const String addReport = '/reports/add';
  static const String reportViewer = '/reports/viewer';
  
  static const String chatbot = '/chatbot';
  
  static const String settings = '/settings';
  static const String notificationSettings = '/settings/notifications';
  
  static const String profile = '/profile';
  static const String editProfile = '/profile/edit';
  
  static const String analytics = '/analytics';
  
  static const String help = '/help';
  static const String about = '/about';

  // Routes map
  static Map<String, WidgetBuilder> get routes => {
    splash: (_) => const SplashScreen(),
    login: (_) => const LoginScreen(),
    signup: (_) => const SignupScreen(),
    forgotPassword: (_) => const ForgotPasswordScreen(),
    changePassword: (_) => const ChangePasswordScreen(),
    
    mainNavigation: (_) => const MainNavigationScreen(),
    home: (_) => const HomeScreen(),
    
    medicineList: (_) => const MedicineListScreen(),
    addMedicine: (_) => const AddMedicineScreen(),
    
    schedule: (_) => const ScheduleScreen(),
    calendar: (_) => const CalendarScreen(),
    
    healthRecords: (_) => const HealthRecordsScreen(),
    allergies: (_) => const AllergiesScreen(),
    chronicIllnesses: (_) => const ChronicIllnessesScreen(),
    
    inventory: (_) => const InventoryScreen(),
    
    appointments: (_) => const AppointmentsScreen(),
    addAppointment: (_) => const AddAppointmentScreen(),
    
    journal: (_) => const JournalScreen(),
    addMood: (_) => const AddMoodScreen(),
    challenges: (_) => const ChallengesScreen(),
    
    reports: (_) => const ReportsScreen(),
    addReport: (_) => const AddReportScreen(),
    
    chatbot: (_) => const ChatbotScreen(),
    
    settings: (_) => const SettingsScreen(),
    notificationSettings: (_) => const NotificationSettingsScreen(),
    
    profile: (_) => const ProfileScreen(),
    editProfile: (_) => const EditProfileScreen(),
    
    analytics: (_) => const AnalyticsScreen(),
    
    help: (_) => const HelpScreen(),
    about: (_) => const AboutScreen(),
  };

  // Handle dynamic routes with arguments
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case medicineDetail:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => MedicineDetailScreen(
            medicineId: args?['medicineId'] ?? '',
          ),
        );
        
      case appointmentDetail:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => AppointmentDetailScreen(
            appointmentId: args?['appointmentId'] ?? '',
          ),
        );
        
      case reportViewer:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => ReportViewerScreen(
            reportId: args?['reportId'] ?? '',
          ),
        );
        
      default:
        return null;
    }
  }
}
