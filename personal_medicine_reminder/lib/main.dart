import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'config/themes.dart';
import 'config/routes.dart';
import 'providers/auth_provider.dart';
import 'providers/medicine_provider.dart';
import 'providers/appointment_provider.dart';
import 'providers/settings_provider.dart';
import 'providers/health_records_provider.dart';
import 'providers/journal_provider.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp();
  
  // Initialize Hive for local storage
  await Hive.initFlutter();
  
  // Initialize timezone for notifications
  tz.initializeTimeZones();
  
  // Initialize notification service
  await NotificationService().initialize();
  
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  runApp(const PersonalMedicineReminderApp());
}

/// Main Application Widget
/// 
/// Implements SRS Section 1 - Personal Medicine Reminder Application (PMRA)
/// A mobile-based health management system designed to assist patients
/// in organizing their daily medication intake, appointments, and health information.
class PersonalMedicineReminderApp extends StatelessWidget {
  const PersonalMedicineReminderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Authentication Provider - SRS 2.1
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        
        // Medicine Management Provider - SRS 2.3
        ChangeNotifierProvider(create: (_) => MedicineProvider()),
        
        // Appointment Management Provider - SRS 2.7
        ChangeNotifierProvider(create: (_) => AppointmentProvider()),
        
        // Health Records Provider - SRS 2.5
        ChangeNotifierProvider(create: (_) => HealthRecordsProvider()),
        
        // Journal Provider - SRS 2.8
        ChangeNotifierProvider(create: (_) => JournalProvider()),
        
        // Settings Provider - SRS 2.12
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settingsProvider, child) {
          return MaterialApp(
            title: 'Personal Medicine Reminder',
            debugShowCheckedModeBanner: false,
            
            // Theme Configuration - SRS 2.12.1
            theme: AppThemes.lightTheme,
            darkTheme: AppThemes.darkTheme,
            themeMode: settingsProvider.themeMode,
            
            // Route Configuration
            initialRoute: AppRoutes.splash,
            routes: AppRoutes.routes,
            onGenerateRoute: AppRoutes.onGenerateRoute,
          );
        },
      ),
    );
  }
}
