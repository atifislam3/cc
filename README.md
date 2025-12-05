# Personal Medicine Reminder Application

A comprehensive Flutter-based health management application designed to help users manage their daily medication intake, appointments, and health information.

## 📱 Project Overview

This repository contains the **Personal Medicine Reminder Application (PMRA)**, a mobile-based health management system developed using Flutter for cross-platform compatibility, integrated with Firebase for authentication and storage, and local databases for offline use.

### Target Users
- Patients managing multiple or chronic medications
- Elderly individuals requiring simple, clear reminders
- Caregivers and doctors monitoring treatment adherence

## ✨ Features

### 🔐 Authentication (SRS 2.1)
- Email/Password Sign Up and Login
- Google Sign-In Integration
- Password Reset via Email
- Secure Session Management

### 👤 Profile Management (SRS 2.2)
- View and Update Personal Information
- Basic Health Information (Height, Weight, Blood Group, BMI)
- Profile Photo Upload

### 💊 Medicine Management (SRS 2.3)
- Add and Manage Multiple Medicines
- Multiple Reminder Times per Dose
- Complex Scheduling (Daily, Weekly, Interval-based, Cyclic)
- Medicine Categories (Tablet, Syrup, Injection, etc.)

### 📅 Schedule Management (SRS 2.4)
- Calendar View with Medicine/Appointment Highlights
- Daily and Date-specific Schedule Views
- 15-day Past/Future View

### 🏥 User Health Records (SRS 2.5)
- Allergies Management
- Current and Past Medications
- Chronic Illnesses Tracking

### 📦 Inventory Control (SRS 2.6)
- Stock Quantity Tracking
- Low Stock Alerts

### 📋 Appointment Management (SRS 2.7)
- Add/Update Appointments
- Visit Notes and Reminders
- Appointment History

### 📓 Journaling & Motivation (SRS 2.8)
- Daily Mood Tracking
- AI-Powered Health Challenges
- Visual Streak Tracker

### 📄 Report Management (SRS 2.9)
- Upload and Store Medical Reports
- Search and View Reports

### 🤖 ChatBot Assistant (SRS 2.10)
- AI-Powered Health Assistant
- Safety Filters

### ⚙️ Settings (SRS 2.12)
- Light/Dark Theme
- Notification Customization
- Automatic Timezone Detection

### 📊 Analytics (SRS 2.13)
- Medicine Consumption Reports
- Missed Doses Reports
- Monthly Summary Charts

## 🛠️ Tech Stack

- **Frontend**: Flutter (Dart)
- **Backend**: Firebase (Authentication, Firestore, Storage)
- **Local Storage**: SQLite, Hive
- **State Management**: Provider
- **Notifications**: flutter_local_notifications
- **Charts**: fl_chart
- **Calendar**: table_calendar
- **AI Integration**: Gemini API

## 📁 Project Structure

```
personal_medicine_reminder/
├── lib/
│   ├── main.dart
│   ├── config/           # App configuration
│   ├── models/           # Data models
│   ├── providers/        # State management
│   ├── screens/          # UI screens
│   ├── services/         # Backend services
│   ├── widgets/          # Reusable widgets
│   └── utils/            # Utility functions
├── test/                 # Unit tests
├── android/              # Android configuration
├── ios/                  # iOS configuration
└── pubspec.yaml          # Dependencies
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK >= 3.0.0
- Dart SDK >= 3.0.0
- Android Studio / VS Code
- Firebase Account

### Installation

1. Navigate to the Flutter project:
```bash
cd personal_medicine_reminder
```

2. Install dependencies:
```bash
flutter pub get
```

3. Configure Firebase:
   - Create a Firebase project
   - Add Android/iOS apps to Firebase
   - Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
   - Enable Authentication and Firestore

4. Run the app:
```bash
flutter run
```

## 📖 Documentation

The complete Software Requirements Specification (SRS) document is available, covering:
- Functional Requirements (150+ requirements)
- Non-Functional Requirements
- System Architecture

## 👥 Authors

- **Atif Islam**
- **Muhammad Awais Ali**

## 📄 License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.

## 📅 Version

**Version 1.1** - November 27, 2025
