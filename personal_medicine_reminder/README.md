# Personal Medicine Reminder Application

A comprehensive Flutter-based health management application designed to help users manage their daily medication intake, appointments, and health information.

## Features

### 🔐 Authentication
- Email/Password Sign Up and Login
- Google Sign-In Integration
- Password Reset via Email
- Secure Session Management

### 👤 Profile Management
- View and Update Personal Information
- Manage Basic Health Information (Height, Weight, Blood Group, BMI)
- Upload Profile Photo

### 💊 Medicine Management
- Add and Manage Multiple Medicines
- Set Multiple Reminder Times per Dose
- Complex Scheduling (Daily, Weekly, Interval-based, Cyclic)
- Medicine Categories (Tablet, Syrup, Injection, etc.)
- Enable/Disable Alerts

### 📅 Schedule Management
- Calendar View with Medicine/Appointment Highlights
- Daily Schedule Overview
- Date-specific Schedule View
- 15-day Past/Future View Limitation

### 🏥 User Health Records
- Allergies List Management
- Current and Past Medications
- Dietary Restraints
- Chronic Illnesses Tracking

### 📦 Inventory Control
- Stock Quantity Tracking
- Low Stock Alerts (≤5 items)
- Automatic Stock Updates

### 📋 Appointment Management
- Add/Update Appointments
- Doctor/Clinic Information
- Appointment Categories and Status
- Visit Notes
- Appointment History

### 📓 Journaling & Motivation
- Daily Mood Tracking
- Optional Notes
- AI-Powered Health Challenges (via Gemini API)
- Visual Streak Tracker for Medication Adherence

### 📄 Report Management
- Upload and Store Medical Reports
- Search Reports by Title, Date, or Type
- Built-in Report Viewer

### 🤖 ChatBot Assistant
- AI-Powered Health Assistant
- Safety Filters for Appropriate Responses

### ⚙️ Settings & Preferences
- Light/Dark Theme Toggle
- Notification Customization
- Automatic Timezone Detection

### 📊 Analytics & Visualization
- Medicine Consumption Reports
- Missed Doses Reports
- Monthly Summary Charts

## Tech Stack

- **Frontend**: Flutter (Dart)
- **Backend**: Firebase (Authentication, Firestore, Storage)
- **Local Storage**: SQLite, Hive
- **State Management**: Provider
- **Notifications**: flutter_local_notifications
- **Charts**: fl_chart
- **Calendar**: table_calendar

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── config/                   # Configuration files
│   ├── themes.dart
│   ├── routes.dart
│   └── constants.dart
├── models/                   # Data models
│   ├── user_model.dart
│   ├── medicine_model.dart
│   ├── appointment_model.dart
│   ├── health_record_model.dart
│   ├── report_model.dart
│   └── journal_model.dart
├── providers/                # State management
│   ├── auth_provider.dart
│   ├── medicine_provider.dart
│   ├── appointment_provider.dart
│   └── settings_provider.dart
├── screens/                  # UI screens
│   ├── auth/
│   ├── home/
│   ├── medicine/
│   ├── schedule/
│   ├── health_records/
│   ├── inventory/
│   ├── appointments/
│   ├── journal/
│   ├── reports/
│   ├── chatbot/
│   ├── settings/
│   └── profile/
├── services/                 # Backend services
│   ├── auth_service.dart
│   ├── database_service.dart
│   ├── notification_service.dart
│   ├── firebase_service.dart
│   └── chatbot_service.dart
├── widgets/                  # Reusable widgets
│   ├── common/
│   └── custom/
└── utils/                    # Utility functions
    ├── helpers.dart
    └── validators.dart
```

## Installation

1. Clone the repository:
```bash
git clone https://github.com/atifislam3/cc.git
cd cc/personal_medicine_reminder
```

2. Install dependencies:
```bash
flutter pub get
```

3. Configure Firebase:
   - Create a Firebase project
   - Add Android/iOS apps to Firebase
   - Download and add `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
   - Enable Authentication (Email/Password, Google)
   - Create Firestore database
   - Set up Firebase Storage

4. Run the app:
```bash
flutter run
```

## Requirements

- Flutter SDK >= 3.0.0
- Dart SDK >= 3.0.0
- Android Studio / VS Code
- Firebase Account

## Authors

- **Atif Islam**
- **Muhammad Awais Ali**

## Version

1.1 - November 27, 2025

## License

This project is licensed under the Apache License 2.0 - see the LICENSE file for details.
