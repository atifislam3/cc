# System Sequence Diagrams (SSD)
## Health Management Application

This document provides System Sequence Diagrams with methods and parameters for all functional requirements outlined in the Software Requirements Specification (SRS).

---

## 2.2.1 Authentication

### 2.2.1.1 Process SignIn (Registration)

**System Operations:**

#### `registerUser(userData: UserRegistrationData): RegistrationResult`
- **Parameters:**
  - `userData.fullName: string` - User's full name
  - `userData.email: string` - User's email address (must be unique)
  - `userData.password: string` - User's password (min 8 chars, 1 uppercase, 1 number)
  - `userData.confirmPassword: string` - Password confirmation
- **Returns:** `RegistrationResult { success: boolean, userId: string, message: string }`
- **Related SRS:** SRS-1, SRS-2, SRS-3, SRS-4

#### `validateRegistrationFields(userData: UserRegistrationData): ValidationResult`
- **Parameters:**
  - `userData: UserRegistrationData` - All registration fields
- **Returns:** `ValidationResult { isValid: boolean, errors: string[] }`
- **Related SRS:** SRS-4

#### `checkEmailUniqueness(email: string): boolean`
- **Parameters:**
  - `email: string` - Email to check
- **Returns:** `boolean` - true if email is available
- **Related SRS:** SRS-2, SRS-6

#### `validatePasswordStrength(password: string): ValidationResult`
- **Parameters:**
  - `password: string` - Password to validate
- **Returns:** `ValidationResult { isValid: boolean, message: string }`
- **Related SRS:** SRS-3

#### `sendVerificationEmail(email: string, userId: string): EmailResult`
- **Parameters:**
  - `email: string` - User's email address
  - `userId: string` - Unique user identifier
- **Returns:** `EmailResult { sent: boolean, verificationToken: string }`
- **Related SRS:** SRS-5

#### `redirectToLogin(): void`
- **Parameters:** None
- **Returns:** `void`
- **Related SRS:** SRS-7

---

### 2.2.1.2 Process Login

**System Operations:**

#### `loginUser(credentials: LoginCredentials): LoginResult`
- **Parameters:**
  - `credentials.email: string` - User's email
  - `credentials.password: string` - User's password
- **Returns:** `LoginResult { success: boolean, userId: string, sessionToken: string, message: string }`
- **Related SRS:** SRS-8

#### `validateCredentials(email: string, password: string): boolean`
- **Parameters:**
  - `email: string` - User's email
  - `password: string` - User's password
- **Returns:** `boolean` - true if credentials are valid
- **Related SRS:** SRS-9

#### `redirectToDashboard(userId: string): void`
- **Parameters:**
  - `userId: string` - Authenticated user's ID
- **Returns:** `void`
- **Related SRS:** SRS-10

#### `displayLoginError(errorType: string): void`
- **Parameters:**
  - `errorType: string` - Type of error (e.g., "INVALID_CREDENTIALS", "NO_INTERNET")
- **Returns:** `void`
- **Related SRS:** SRS-11

---

### 2.2.1.3 Process Logout

**System Operations:**

#### `logoutUser(userId: string, sessionToken: string): LogoutResult`
- **Parameters:**
  - `userId: string` - Current user's ID
  - `sessionToken: string` - Current session token
- **Returns:** `LogoutResult { success: boolean, message: string }`
- **Related SRS:** SRS-12

#### `terminateUserSession(sessionToken: string): void`
- **Parameters:**
  - `sessionToken: string` - Session to terminate
- **Returns:** `void`
- **Related SRS:** SRS-13

#### `redirectToLoginScreen(): void`
- **Parameters:** None
- **Returns:** `void`
- **Related SRS:** SRS-14

---

### 2.2.1.4 Forget Password

**System Operations:**

#### `requestPasswordReset(email: string): ResetRequestResult`
- **Parameters:**
  - `email: string` - User's registered email
- **Returns:** `ResetRequestResult { success: boolean, message: string }`
- **Related SRS:** SRS-15

#### `sendPasswordResetLink(email: string): EmailResult`
- **Parameters:**
  - `email: string` - User's email
- **Returns:** `EmailResult { sent: boolean, resetToken: string, expiryTime: timestamp }`
- **Related SRS:** SRS-16

#### `verifyResetLink(resetToken: string): VerificationResult`
- **Parameters:**
  - `resetToken: string` - Password reset token from email link
- **Returns:** `VerificationResult { isValid: boolean, userId: string, expiryTime: timestamp }`
- **Related SRS:** SRS-17

#### `resetPassword(resetToken: string, newPassword: string, confirmPassword: string): ResetResult`
- **Parameters:**
  - `resetToken: string` - Valid reset token
  - `newPassword: string` - New password (must meet security requirements)
  - `confirmPassword: string` - Password confirmation
- **Returns:** `ResetResult { success: boolean, message: string }`
- **Related SRS:** SRS-17, SRS-18

#### `storeNewPassword(userId: string, hashedPassword: string): boolean`
- **Parameters:**
  - `userId: string` - User's ID
  - `hashedPassword: string` - Securely hashed password
- **Returns:** `boolean` - true if stored successfully
- **Related SRS:** SRS-18

---

### 2.2.1.5 Change Password

**System Operations:**

#### `changePassword(changeRequest: PasswordChangeRequest): ChangeResult`
- **Parameters:**
  - `changeRequest.userId: string` - User's ID
  - `changeRequest.currentPassword: string` - Current password
  - `changeRequest.newPassword: string` - New password
  - `changeRequest.confirmPassword: string` - Password confirmation
- **Returns:** `ChangeResult { success: boolean, message: string }`
- **Related SRS:** SRS-19, SRS-20

#### `verifyCurrentPassword(userId: string, currentPassword: string): boolean`
- **Parameters:**
  - `userId: string` - User's ID
  - `currentPassword: string` - Current password to verify
- **Returns:** `boolean` - true if password is correct
- **Related SRS:** SRS-20

#### `validateNewPassword(newPassword: string, confirmPassword: string): ValidationResult`
- **Parameters:**
  - `newPassword: string` - New password
  - `confirmPassword: string` - Password confirmation
- **Returns:** `ValidationResult { isValid: boolean, errors: string[] }`
- **Related SRS:** SRS-21, SRS-22

#### `displayPasswordChangeSuccess(): void`
- **Parameters:** None
- **Returns:** `void`
- **Related SRS:** SRS-23

#### `isGoogleAuthUser(userId: string): boolean`
- **Parameters:**
  - `userId: string` - User's ID
- **Returns:** `boolean` - true if user authenticated via Google
- **Related SRS:** SRS-24

---

### 2.2.1.6 Process Social Login

**System Operations:**

#### `initiateGoogleLogin(): void`
- **Parameters:** None
- **Returns:** `void` - Opens Google authentication flow
- **Related SRS:** SRS-25

#### `handleGoogleAuthCallback(authCode: string): GoogleAuthResult`
- **Parameters:**
  - `authCode: string` - Authorization code from Google
- **Returns:** `GoogleAuthResult { success: boolean, userData: GoogleUserData, isNewUser: boolean }`
- **Related SRS:** SRS-25

#### `retrieveGoogleUserInfo(accessToken: string): GoogleUserData`
- **Parameters:**
  - `accessToken: string` - Google access token
- **Returns:** `GoogleUserData { fullName: string, email: string, profilePhoto: string }`
- **Related SRS:** SRS-26

#### `createGoogleUser(googleData: GoogleUserData): UserResult`
- **Parameters:**
  - `googleData: GoogleUserData` - User data from Google
- **Returns:** `UserResult { userId: string, created: boolean }`
- **Related SRS:** SRS-27

#### `loginExistingGoogleUser(email: string): LoginResult`
- **Parameters:**
  - `email: string` - Google account email
- **Returns:** `LoginResult { success: boolean, userId: string, sessionToken: string }`
- **Related SRS:** SRS-28

#### `redirectToHomeScreen(userId: string): void`
- **Parameters:**
  - `userId: string` - User's ID
- **Returns:** `void`
- **Related SRS:** SRS-29

#### `disablePasswordChange(userId: string): void`
- **Parameters:**
  - `userId: string` - Google-authenticated user's ID
- **Returns:** `void`
- **Related SRS:** SRS-30

---

## 2.2.2 Profile Management

### 2.2.2.1 View Profile

**System Operations:**

#### `getProfileData(userId: string): ProfileData`
- **Parameters:**
  - `userId: string` - User's ID
- **Returns:** `ProfileData { fullName, email, bloodGroup, weight, height, bmi, gender, dateOfBirth, profilePhotoUrl }`
- **Related SRS:** SRS-31 to SRS-37

#### `displayProfile(profileData: ProfileData): void`
- **Parameters:**
  - `profileData: ProfileData` - Complete profile data
- **Returns:** `void`
- **Related SRS:** SRS-31 to SRS-37

#### `calculateBMI(weight: number, height: number): number`
- **Parameters:**
  - `weight: number` - Weight in kilograms
  - `height: number` - Height in centimeters
- **Returns:** `number` - Calculated BMI value
- **Related SRS:** SRS-34

---

### 2.2.2.2 Update Profile

**System Operations:**

#### `updateProfile(userId: string, profileData: ProfileUpdateData): UpdateResult`
- **Parameters:**
  - `userId: string` - User's ID
  - `profileData: ProfileUpdateData` - Updated profile fields
    - `fullName: string`
    - `email: string`
    - `bloodGroup: string`
    - `weight: number`
    - `height: number`
    - `gender: string`
    - `dateOfBirth: Date`
- **Returns:** `UpdateResult { success: boolean, updatedFields: string[], message: string }`
- **Related SRS:** SRS-38 to SRS-43

#### `recalculateBMI(weight: number, height: number): number`
- **Parameters:**
  - `weight: number` - Updated weight
  - `height: number` - Updated height
- **Returns:** `number` - Recalculated BMI
- **Related SRS:** SRS-41

#### `saveProfileToFirebase(userId: string, profileData: ProfileUpdateData): SaveResult`
- **Parameters:**
  - `userId: string` - User's ID
  - `profileData: ProfileUpdateData` - Profile data to save
- **Returns:** `SaveResult { success: boolean, timestamp: timestamp }`
- **Related SRS:** SRS-44, SRS-46

#### `navigateToChangePassword(): void`
- **Parameters:** None
- **Returns:** `void`
- **Related SRS:** SRS-45

#### `displayUpdateConfirmation(message: string): void`
- **Parameters:**
  - `message: string` - Confirmation message
- **Returns:** `void`
- **Related SRS:** SRS-47

#### `updateProfilePhoto(userId: string, photoFile: File): PhotoUpdateResult`
- **Parameters:**
  - `userId: string` - User's ID
  - `photoFile: File` - New profile photo
- **Returns:** `PhotoUpdateResult { success: boolean, photoUrl: string }`
- **Related SRS:** SRS-48

---

### 2.2.2.3 Manage Basic Health Information

**System Operations:**

#### `enterHealthInfo(userId: string, healthData: HealthInfoData): SaveResult`
- **Parameters:**
  - `userId: string` - User's ID
  - `healthData: HealthInfoData`
    - `height: number` - Height in centimeters
    - `weight: number` - Weight in kilograms
    - `bloodGroup: string` - Selected blood group
- **Returns:** `SaveResult { success: boolean, bmi: number, message: string }`
- **Related SRS:** SRS-49 to SRS-52

#### `validateHealthInfo(healthData: HealthInfoData): ValidationResult`
- **Parameters:**
  - `healthData: HealthInfoData` - Health information to validate
- **Returns:** `ValidationResult { isValid: boolean, errors: string[] }`
- **Related SRS:** SRS-53

#### `saveHealthInfoToFirebase(userId: string, healthData: HealthInfoData): SaveResult`
- **Parameters:**
  - `userId: string` - User's ID
  - `healthData: HealthInfoData` - Health data to save
- **Returns:** `SaveResult { success: boolean, timestamp: timestamp }`
- **Related SRS:** SRS-54

#### `displayHealthInfoConfirmation(): void`
- **Parameters:** None
- **Returns:** `void`
- **Related SRS:** SRS-55

---

### 2.2.2.4 Upload Profile Photo

**System Operations:**

#### `selectPhotoFromGallery(): PhotoSelectionResult`
- **Parameters:** None
- **Returns:** `PhotoSelectionResult { selected: boolean, photoFile: File }`
- **Related SRS:** SRS-56

#### `validatePhotoFormat(photoFile: File): ValidationResult`
- **Parameters:**
  - `photoFile: File` - Selected photo file
- **Returns:** `ValidationResult { isValid: boolean, format: string, size: number }`
- **Related SRS:** SRS-57

#### `resizeAndCompressImage(photoFile: File, maxSize: number): File`
- **Parameters:**
  - `photoFile: File` - Original photo
  - `maxSize: number` - Maximum file size in bytes
- **Returns:** `File` - Optimized photo file
- **Related SRS:** SRS-58

#### `uploadPhotoToFirebase(userId: string, photoFile: File): UploadResult`
- **Parameters:**
  - `userId: string` - User's ID
  - `photoFile: File` - Photo to upload
- **Returns:** `UploadResult { success: boolean, photoUrl: string, storageRef: string }`
- **Related SRS:** SRS-59

#### `updateProfilePhotoDisplay(photoUrl: string): void`
- **Parameters:**
  - `photoUrl: string` - URL of new photo
- **Returns:** `void`
- **Related SRS:** SRS-60

#### `removeProfilePhoto(userId: string): RemovalResult`
- **Parameters:**
  - `userId: string` - User's ID
- **Returns:** `RemovalResult { success: boolean, message: string }`
- **Related SRS:** SRS-61

---

## 2.2.3 Medicine Management

### 2.2.3.1 Add Medicine

**System Operations:**

#### `addMedicine(userId: string, medicineData: MedicineData): AddResult`
- **Parameters:**
  - `userId: string` - User's ID
  - `medicineData: MedicineData`
    - `name: string` - Medicine name
    - `dosage: string` - Dosage information
    - `frequency: FrequencyData` - Frequency details
    - `reminders: ReminderData[]` - Multiple notification settings per dose
    - `initialStock: number` - Optional initial quantity
    - `category: string` - Medicine category
    - `schedule: ScheduleData` - Complex schedule (days of week, interval, cyclic)
- **Returns:** `AddResult { success: boolean, medicineId: string, message: string }`
- **Related SRS:** SRS-62 to SRS-67

#### `setMedicineReminders(medicineId: string, reminders: ReminderData[]): ReminderResult`
- **Parameters:**
  - `medicineId: string` - Medicine ID
  - `reminders: ReminderData[]` - Array of reminder configurations
    - `time: timestamp` - When to send notification
    - `offset: number` - Minutes before/after dose time
    - `enabled: boolean` - Reminder status
- **Returns:** `ReminderResult { success: boolean, scheduledCount: number }`
- **Related SRS:** SRS-63

#### `setComplexSchedule(medicineId: string, schedule: ScheduleData): ScheduleResult`
- **Parameters:**
  - `medicineId: string` - Medicine ID
  - `schedule: ScheduleData`
    - `type: string` - "SPECIFIC_DAYS" | "INTERVAL" | "CYCLIC"
    - `daysOfWeek: string[]` - For specific days schedule
    - `intervalDays: number` - For interval-based schedule
    - `cyclicPattern: { onDays: number, offDays: number }` - For cyclic schedule
- **Returns:** `ScheduleResult { success: boolean, nextDoseDate: Date }`
- **Related SRS:** SRS-64

#### `validateMedicineFields(medicineData: MedicineData): ValidationResult`
- **Parameters:**
  - `medicineData: MedicineData` - Medicine data to validate
- **Returns:** `ValidationResult { isValid: boolean, errors: string[] }`
- **Related SRS:** SRS-66

#### `saveMedicineToLocalStorage(medicineData: MedicineData): SaveResult`
- **Parameters:**
  - `medicineData: MedicineData` - Medicine data to save
- **Returns:** `SaveResult { success: boolean, medicineId: string }`
- **Related SRS:** SRS-67

#### `displayMedicineAddedConfirmation(): void`
- **Parameters:** None
- **Returns:** `void`
- **Related SRS:** SRS-68

---

### 2.2.3.2 Update Medicine Details

**System Operations:**

#### `updateMedicine(medicineId: string, updateData: MedicineUpdateData): UpdateResult`
- **Parameters:**
  - `medicineId: string` - Medicine ID
  - `updateData: MedicineUpdateData`
    - `name: string` - Updated name
    - `category: string` - Updated category
    - `dosage: string` - Updated dosage
    - `reminderSchedule: ReminderData[]` - Updated reminders
- **Returns:** `UpdateResult { success: boolean, message: string }`
- **Related SRS:** SRS-69, SRS-70

#### `validateMedicineUpdate(updateData: MedicineUpdateData): ValidationResult`
- **Parameters:**
  - `updateData: MedicineUpdateData` - Update data to validate
- **Returns:** `ValidationResult { isValid: boolean, errors: string[] }`
- **Related SRS:** SRS-71

#### `saveUpdatedMedicine(medicineId: string, updateData: MedicineUpdateData): SaveResult`
- **Parameters:**
  - `medicineId: string` - Medicine ID
  - `updateData: MedicineUpdateData` - Updated data
- **Returns:** `SaveResult { success: boolean, timestamp: timestamp }`
- **Related SRS:** SRS-72

#### `displayUpdateConfirmation(): void`
- **Parameters:** None
- **Returns:** `void`
- **Related SRS:** SRS-73

---

### 2.2.3.3 Set Medicine Reminder

**System Operations:**

#### `scheduleNotifications(medicineId: string, schedule: ScheduleData): NotificationResult`
- **Parameters:**
  - `medicineId: string` - Medicine ID
  - `schedule: ScheduleData` - Complete schedule configuration
- **Returns:** `NotificationResult { success: boolean, scheduledNotificationIds: string[] }`
- **Related SRS:** SRS-74

#### `setMultipleNotificationsPerDose(medicineId: string, doseTime: timestamp, offsets: number[]): NotificationResult`
- **Parameters:**
  - `medicineId: string` - Medicine ID
  - `doseTime: timestamp` - Actual dose time
  - `offsets: number[]` - Minutes before/after (e.g., [-5, 0, 2])
- **Returns:** `NotificationResult { success: boolean, notificationIds: string[] }`
- **Related SRS:** SRS-75

#### `addNotificationActions(notificationId: string, actions: string[]): void`
- **Parameters:**
  - `notificationId: string` - Notification ID
  - `actions: string[]` - Action buttons ["Take", "Missed", "Snooze"]
- **Returns:** `void`
- **Related SRS:** SRS-76

#### `handleNotificationAction(notificationId: string, action: string, medicineId: string, doseTime: timestamp): ActionResult`
- **Parameters:**
  - `notificationId: string` - Notification ID
  - `action: string` - "TAKE" | "MISSED" | "SNOOZE"
  - `medicineId: string` - Medicine ID
  - `doseTime: timestamp` - Dose time
- **Returns:** `ActionResult { success: boolean, newStatus: string, snoozeTime: timestamp }`
- **Related SRS:** SRS-77

#### `saveReminderStatus(medicineId: string, doseTime: timestamp, status: string): SaveResult`
- **Parameters:**
  - `medicineId: string` - Medicine ID
  - `doseTime: timestamp` - Dose time
  - `status: string` - "TAKEN" | "MISSED" | "SNOOZED" | "PENDING"
- **Returns:** `SaveResult { success: boolean }`
- **Related SRS:** SRS-78

---

### 2.2.3.4 Disable Medicine Alert

**System Operations:**

#### `disableMedicineNotifications(medicineId: string): DisableResult`
- **Parameters:**
  - `medicineId: string` - Medicine ID
- **Returns:** `DisableResult { success: boolean, disabledCount: number }`
- **Related SRS:** SRS-79

#### `removeMedicineFromAlerts(medicineId: string, keepInInventory: boolean): RemovalResult`
- **Parameters:**
  - `medicineId: string` - Medicine ID
  - `keepInInventory: boolean` - Whether to keep in inventory
- **Returns:** `RemovalResult { success: boolean, message: string }`
- **Related SRS:** SRS-80

#### `updateReminderSystem(userId: string): void`
- **Parameters:**
  - `userId: string` - User's ID
- **Returns:** `void`
- **Related SRS:** SRS-81

---

### 2.2.3.5 Categorize Medicine

**System Operations:**

#### `selectMedicineCategory(medicineId: string, category: string): CategoryResult`
- **Parameters:**
  - `medicineId: string` - Medicine ID
  - `category: string` - "Tablet" | "Syrup" | "Injection" | "Insulin" | custom
- **Returns:** `CategoryResult { success: boolean, categoryId: string }`
- **Related SRS:** SRS-82

#### `createCustomCategory(categoryName: string, userId: string): CategoryResult`
- **Parameters:**
  - `categoryName: string` - Custom category name
  - `userId: string` - User's ID
- **Returns:** `CategoryResult { success: boolean, categoryId: string }`
- **Related SRS:** SRS-83

#### `saveCategoryData(medicineId: string, categoryId: string): SaveResult`
- **Parameters:**
  - `medicineId: string` - Medicine ID
  - `categoryId: string` - Category ID
- **Returns:** `SaveResult { success: boolean }`
- **Related SRS:** SRS-84

---

## 2.2.4 Schedule Management

### 2.2.4.1 View Calendar

**System Operations:**

#### `getCalendarView(userId: string, month: number, year: number): CalendarData`
- **Parameters:**
  - `userId: string` - User's ID
  - `month: number` - Month (1-12)
  - `year: number` - Year
- **Returns:** `CalendarData { dates: DateData[], highlightedDates: Date[] }`
- **Related SRS:** SRS-85

#### `highlightScheduledDates(calendarData: CalendarData): void`
- **Parameters:**
  - `calendarData: CalendarData` - Calendar data with scheduled items
- **Returns:** `void`
- **Related SRS:** SRS-85

---

### 2.2.4.2 View Daily Schedule

**System Operations:**

#### `getDailySchedule(userId: string, date: Date): DailyScheduleData`
- **Parameters:**
  - `userId: string` - User's ID
  - `date: Date` - Date (defaults to today)
- **Returns:** `DailyScheduleData { medicines: MedicineSchedule[], appointments: AppointmentData[] }`
- **Related SRS:** SRS-86

#### `displayDailySchedule(scheduleData: DailyScheduleData): void`
- **Parameters:**
  - `scheduleData: DailyScheduleData` - Schedule data for display
- **Returns:** `void`
- **Related SRS:** SRS-86

---

### 2.2.4.3 View Date Schedule

**System Operations:**

#### `getDateSchedule(userId: string, specificDate: Date): DateScheduleData`
- **Parameters:**
  - `userId: string` - User's ID
  - `specificDate: Date` - Specific date to view
- **Returns:** `DateScheduleData { medicines: MedicineSchedule[], appointments: AppointmentData[] }`
- **Related SRS:** SRS-87

#### `displayDateScheduleDetails(scheduleData: DateScheduleData): void`
- **Parameters:**
  - `scheduleData: DateScheduleData` - Schedule details
- **Returns:** `void`
- **Related SRS:** SRS-87

---

### 2.2.4.4 Apply Date Range Limitation

**System Operations:**

#### `applyDateRangeFilter(currentDate: Date): DateRange`
- **Parameters:**
  - `currentDate: Date` - Current date
- **Returns:** `DateRange { startDate: Date, endDate: Date }` - 15 days past to 15 days future
- **Related SRS:** SRS-88

#### `filterCalendarData(calendarData: CalendarData, dateRange: DateRange): CalendarData`
- **Parameters:**
  - `calendarData: CalendarData` - Complete calendar data
  - `dateRange: DateRange` - Date range filter
- **Returns:** `CalendarData` - Filtered calendar data
- **Related SRS:** SRS-88

---

## 2.2.5 User Health Records

### 2.2.5.1 Add Allergies List

**System Operations:**

#### `addAllergy(userId: string, allergyData: AllergyData): AddResult`
- **Parameters:**
  - `userId: string` - User's ID
  - `allergyData: AllergyData`
    - `allergyName: string` - Name of allergy
    - `severity: string` - Severity level
    - `reaction: string` - Reaction description
- **Returns:** `AddResult { success: boolean, allergyId: string }`
- **Related SRS:** SRS-89

#### `viewAllergies(userId: string): AllergyData[]`
- **Parameters:**
  - `userId: string` - User's ID
- **Returns:** `AllergyData[]` - List of allergies
- **Related SRS:** SRS-89

#### `updateAllergy(allergyId: string, allergyData: AllergyData): UpdateResult`
- **Parameters:**
  - `allergyId: string` - Allergy ID
  - `allergyData: AllergyData` - Updated allergy data
- **Returns:** `UpdateResult { success: boolean, message: string }`
- **Related SRS:** SRS-89

#### `validateAllergyEntry(allergyData: AllergyData): ValidationResult`
- **Parameters:**
  - `allergyData: AllergyData` - Allergy data to validate
- **Returns:** `ValidationResult { isValid: boolean, errors: string[] }`
- **Related SRS:** SRS-90

---

### 2.2.5.2 View Current Medication

**System Operations:**

#### `getCurrentMedications(userId: string): MedicineData[]`
- **Parameters:**
  - `userId: string` - User's ID
- **Returns:** `MedicineData[]` - List of current medicines
- **Related SRS:** SRS-91

#### `displayCurrentMedications(medicines: MedicineData[]): void`
- **Parameters:**
  - `medicines: MedicineData[]` - Current medicines
- **Returns:** `void`
- **Related SRS:** SRS-91

#### `markMedicineStatus(medicineId: string, status: string): StatusResult`
- **Parameters:**
  - `medicineId: string` - Medicine ID
  - `status: string` - "ACTIVE" | "COMPLETED"
- **Returns:** `StatusResult { success: boolean, newStatus: string }`
- **Related SRS:** SRS-92

---

### 2.2.5.3 View Past Medication

**System Operations:**

#### `getPastMedications(userId: string): MedicineData[]`
- **Parameters:**
  - `userId: string` - User's ID
- **Returns:** `MedicineData[]` - List of past medicines
- **Related SRS:** SRS-93

#### `displayPastMedications(medicines: MedicineData[]): void`
- **Parameters:**
  - `medicines: MedicineData[]` - Past medicines
- **Returns:** `void`
- **Related SRS:** SRS-93

#### `updatePastMedications(medicineId: string): void`
- **Parameters:**
  - `medicineId: string` - Medicine marked as completed/removed
- **Returns:** `void`
- **Related SRS:** SRS-94

---

### 2.2.5.4 Add Restraints

**System Operations:**

#### `addRestraint(userId: string, restraintData: RestraintData): AddResult`
- **Parameters:**
  - `userId: string` - User's ID
  - `restraintData: RestraintData`
    - `type: string` - "MEDICATION" | "DIETARY"
    - `description: string` - Restraint description
    - `severity: string` - Severity level
- **Returns:** `AddResult { success: boolean, restraintId: string }`
- **Related SRS:** SRS-95

---

### 2.2.5.5 Add Chronic Illnesses

**System Operations:**

#### `addChronicIllness(userId: string, illnessData: IllnessData): AddResult`
- **Parameters:**
  - `userId: string` - User's ID
  - `illnessData: IllnessData`
    - `illnessName: string` - Name of illness
    - `diagnosedDate: Date` - When diagnosed
    - `notes: string` - Additional notes
- **Returns:** `AddResult { success: boolean, illnessId: string }`
- **Related SRS:** SRS-96

#### `viewChronicIllnesses(userId: string): IllnessData[]`
- **Parameters:**
  - `userId: string` - User's ID
- **Returns:** `IllnessData[]` - List of chronic illnesses
- **Related SRS:** SRS-96

#### `updateChronicIllness(illnessId: string, illnessData: IllnessData): UpdateResult`
- **Parameters:**
  - `illnessId: string` - Illness ID
  - `illnessData: IllnessData` - Updated illness data
- **Returns:** `UpdateResult { success: boolean, message: string }`
- **Related SRS:** SRS-96

---

## 2.2.6 Inventory Control

### 2.2.6.1 View Current Stock

**System Operations:**

#### `getCurrentStock(userId: string): StockData[]`
- **Parameters:**
  - `userId: string` - User's ID
- **Returns:** `StockData[]` - List of medicines with stock quantities
  - Each `StockData { medicineId, medicineName, currentStock, lowStockThreshold }`
- **Related SRS:** SRS-97

#### `displayStockList(stockData: StockData[]): void`
- **Parameters:**
  - `stockData: StockData[]` - Stock data sorted with low stock items at top
- **Returns:** `void`
- **Related SRS:** SRS-97, SRS-98

#### `sortStockByQuantity(stockData: StockData[]): StockData[]`
- **Parameters:**
  - `stockData: StockData[]` - Unsorted stock data
- **Returns:** `StockData[]` - Sorted with stock ≤ 5 at top
- **Related SRS:** SRS-98

---

### 2.2.6.2 Update Current Stock

**System Operations:**

#### `updateStock(medicineId: string, operation: string, quantity: number): UpdateResult`
- **Parameters:**
  - `medicineId: string` - Medicine ID
  - `operation: string` - "INCREASE" | "DECREASE"
  - `quantity: number` - Amount to add/remove
- **Returns:** `UpdateResult { success: boolean, newStock: number, message: string }`
- **Related SRS:** SRS-99

#### `saveStockUpdate(medicineId: string, newStock: number): SaveResult`
- **Parameters:**
  - `medicineId: string` - Medicine ID
  - `newStock: number` - Updated stock quantity
- **Returns:** `SaveResult { success: boolean, timestamp: timestamp }`
- **Related SRS:** SRS-100

#### `displayStockUpdateConfirmation(message: string): void`
- **Parameters:**
  - `message: string` - Confirmation message
- **Returns:** `void`
- **Related SRS:** SRS-101

---

### 2.2.6.3 Generate Stock Alerts

**System Operations:**

#### `checkStockThreshold(medicineId: string, currentStock: number, threshold: number): boolean`
- **Parameters:**
  - `medicineId: string` - Medicine ID
  - `currentStock: number` - Current stock level
  - `threshold: number` - Stock alert threshold
- **Returns:** `boolean` - true if threshold reached
- **Related SRS:** SRS-102

#### `triggerStockAlert(medicineId: string, medicineName: string, currentStock: number): NotificationResult`
- **Parameters:**
  - `medicineId: string` - Medicine ID
  - `medicineName: string` - Medicine name
  - `currentStock: number` - Current stock level
- **Returns:** `NotificationResult { success: boolean, notificationId: string }`
- **Related SRS:** SRS-102

#### `displayLowStockSection(lowStockMedicines: StockData[]): void`
- **Parameters:**
  - `lowStockMedicines: StockData[]` - Medicines with low stock
- **Returns:** `void`
- **Related SRS:** SRS-103

#### `updateStockAlertsAfterChange(medicineId: string, newStock: number): void`
- **Parameters:**
  - `medicineId: string` - Medicine ID
  - `newStock: number` - Updated stock
- **Returns:** `void`
- **Related SRS:** SRS-104

---

## 2.2.7 Appointment Management

### 2.2.7.1 Add Appointment

**System Operations:**

#### `addAppointment(userId: string, appointmentData: AppointmentData): AddResult`
- **Parameters:**
  - `userId: string` - User's ID
  - `appointmentData: AppointmentData`
    - `date: Date` - Appointment date
    - `time: timestamp` - Appointment time
    - `doctorName: string` - Doctor/Clinic name
    - `category: string` - Appointment category
    - `reminder: ReminderData` - Reminder settings
- **Returns:** `AddResult { success: boolean, appointmentId: string, message: string }`
- **Related SRS:** SRS-105

#### `setAppointmentReminder(appointmentId: string, reminderData: ReminderData): ReminderResult`
- **Parameters:**
  - `appointmentId: string` - Appointment ID
  - `reminderData: ReminderData`
    - `enabled: boolean` - Reminder status
    - `timeBefore: number` - Minutes before appointment
- **Returns:** `ReminderResult { success: boolean, reminderTime: timestamp }`
- **Related SRS:** SRS-106

---

### 2.2.7.2 Update Appointment

**System Operations:**

#### `updateAppointment(appointmentId: string, updateData: AppointmentUpdateData): UpdateResult`
- **Parameters:**
  - `appointmentId: string` - Appointment ID
  - `updateData: AppointmentUpdateData`
    - `date: Date` - Updated date
    - `time: timestamp` - Updated time
    - `category: string` - Updated category
    - `doctorName: string` - Updated doctor/clinic name
    - `visitNotes: string` - Updated notes
    - `reminder: ReminderData` - Updated reminder settings
- **Returns:** `UpdateResult { success: boolean, message: string }`
- **Related SRS:** SRS-107, SRS-108

---

### 2.2.7.3 Manage Appointment Categories/Status

**System Operations:**

#### `categorizeAppointment(appointmentId: string, date: Date, time: timestamp): string`
- **Parameters:**
  - `appointmentId: string` - Appointment ID
  - `date: Date` - Appointment date
  - `time: timestamp` - Appointment time
- **Returns:** `string` - "UPCOMING" | "COMPLETED"
- **Related SRS:** SRS-109

#### `getUpcomingAppointments(userId: string): AppointmentData[]`
- **Parameters:**
  - `userId: string` - User's ID
- **Returns:** `AppointmentData[]` - List of upcoming appointments (sorted at top)
- **Related SRS:** SRS-110

#### `markAppointmentCompleted(appointmentId: string): StatusResult`
- **Parameters:**
  - `appointmentId: string` - Appointment ID
- **Returns:** `StatusResult { success: boolean, newStatus: string }`
- **Related SRS:** SRS-111

---

### 2.2.7.4 Set Appointment Reminder

**System Operations:**

#### `scheduleAppointmentNotification(appointmentId: string, appointmentTime: timestamp, minutesBefore: number): NotificationResult`
- **Parameters:**
  - `appointmentId: string` - Appointment ID
  - `appointmentTime: timestamp` - Appointment time
  - `minutesBefore: number` - How many minutes before to notify
- **Returns:** `NotificationResult { success: boolean, notificationId: string, scheduledTime: timestamp }`
- **Related SRS:** SRS-112

#### `enableRecurringReminder(appointmentId: string, recurringConfig: RecurringData): ReminderResult`
- **Parameters:**
  - `appointmentId: string` - Appointment ID
  - `recurringConfig: RecurringData`
    - `enabled: boolean` - Recurring status
    - `frequency: string` - Frequency of reminders
- **Returns:** `ReminderResult { success: boolean, recurringReminderId: string }`
- **Related SRS:** SRS-113

---

### 2.2.7.5 Add Visit Notes

**System Operations:**

#### `addVisitNotes(appointmentId: string, notes: string): NotesResult`
- **Parameters:**
  - `appointmentId: string` - Appointment ID
  - `notes: string` - Visit notes text
- **Returns:** `NotesResult { success: boolean, notesId: string, timestamp: timestamp }`
- **Related SRS:** SRS-114

---

### 2.2.7.6 View Appointment History

**System Operations:**

#### `getAppointmentHistory(userId: string): AppointmentData[]`
- **Parameters:**
  - `userId: string` - User's ID
- **Returns:** `AppointmentData[]` - List of completed appointments
- **Related SRS:** SRS-115

#### `displayAppointmentHistory(appointments: AppointmentData[]): void`
- **Parameters:**
  - `appointments: AppointmentData[]` - Historical appointments
- **Returns:** `void`
- **Related SRS:** SRS-115

#### `filterAppointmentHistory(userId: string, filterCriteria: FilterData): AppointmentData[]`
- **Parameters:**
  - `userId: string` - User's ID
  - `filterCriteria: FilterData`
    - `startDate: Date` - Filter start date
    - `endDate: Date` - Filter end date
    - `category: string` - Appointment category
- **Returns:** `AppointmentData[]` - Filtered appointments
- **Related SRS:** SRS-116

#### `searchAppointments(userId: string, searchTerm: string): AppointmentData[]`
- **Parameters:**
  - `userId: string` - User's ID
  - `searchTerm: string` - Search term
- **Returns:** `AppointmentData[]` - Matching appointments
- **Related SRS:** SRS-116

---

## 2.2.8 Journaling & Motivation

### 2.2.8.1 Record Mood & Notes Journal

**System Operations:**

#### `addMoodEntry(userId: string, moodData: MoodData): AddResult`
- **Parameters:**
  - `userId: string` - User's ID
  - `moodData: MoodData`
    - `date: Date` - Entry date
    - `mood: string` - "HAPPY" | "SAD" | "NEUTRAL" | other predefined options
    - `notes: string` - Optional text notes
- **Returns:** `AddResult { success: boolean, entryId: string, timestamp: timestamp }`
- **Related SRS:** SRS-117, SRS-118

#### `updateMoodEntry(entryId: string, moodData: MoodData): UpdateResult`
- **Parameters:**
  - `entryId: string` - Entry ID
  - `moodData: MoodData` - Updated mood and notes
- **Returns:** `UpdateResult { success: boolean, message: string }`
- **Related SRS:** SRS-119

---

### 2.2.8.2 Attempt User Challenges

**System Operations:**

#### `generatePersonalizedChallenge(userId: string, contextData: ChallengeContextData): ChallengeResult`
- **Parameters:**
  - `userId: string` - User's ID
  - `contextData: ChallengeContextData`
    - `currentMood: string` - User's current mood
    - `chronicIllnesses: string[]` - List of chronic illnesses
    - `adherenceHistory: AdherenceData` - Recent adherence data
- **Returns:** `ChallengeResult { success: boolean, challenge: ChallengeData, source: string }` - Uses Gemini API
- **Related SRS:** SRS-120

#### `getFallbackChallenge(): ChallengeData`
- **Parameters:** None
- **Returns:** `ChallengeData { challengeId, title, description, type }` - Static challenge (e.g., "Drink Water")
- **Related SRS:** SRS-121

#### `markChallengeOptional(challengeId: string): void`
- **Parameters:**
  - `challengeId: string` - Challenge ID
- **Returns:** `void` - Ensures no penalties for skipping
- **Related SRS:** SRS-122

---

### 2.2.8.3 Display Visual Streak Tracker

**System Operations:**

#### `calculateStreak(userId: string): StreakData`
- **Parameters:**
  - `userId: string` - User's ID
- **Returns:** `StreakData { currentStreak: number, longestStreak: number, lastUpdated: Date }`
- **Related SRS:** SRS-123

#### `checkDailyAdherence(userId: string, date: Date): AdherenceResult`
- **Parameters:**
  - `userId: string` - User's ID
  - `date: Date` - Date to check
- **Returns:** `AdherenceResult { adherencePercentage: number, allMedicinesTaken: boolean }`
- **Related SRS:** SRS-123

#### `displayStreakCounter(streakData: StreakData): void`
- **Parameters:**
  - `streakData: StreakData` - Streak information
- **Returns:** `void` - Displays prominent visual counter
- **Related SRS:** SRS-124

#### `resetStreak(userId: string): ResetResult`
- **Parameters:**
  - `userId: string` - User's ID
- **Returns:** `ResetResult { success: boolean, previousStreak: number }`
- **Related SRS:** SRS-125

---

## 2.2.9 Report Management

### 2.2.9.1 Add/Upload Report

**System Operations:**

#### `addReport(userId: string, reportData: ReportData): AddResult`
- **Parameters:**
  - `userId: string` - User's ID
  - `reportData: ReportData`
    - `title: string` - Report title
    - `date: Date` - Report date
    - `type: string` - Report type
    - `file: File` - Report file
- **Returns:** `AddResult { success: boolean, reportId: string, message: string }`
- **Related SRS:** SRS-126

#### `saveReportToStorage(reportFile: File, userId: string): SaveResult`
- **Parameters:**
  - `reportFile: File` - Report file
  - `userId: string` - User's ID
- **Returns:** `SaveResult { success: boolean, storagePath: string }`
- **Related SRS:** SRS-127

---

### 2.2.9.2 Search Report

**System Operations:**

#### `searchReports(userId: string, searchCriteria: SearchCriteria): ReportData[]`
- **Parameters:**
  - `userId: string` - User's ID
  - `searchCriteria: SearchCriteria`
    - `title: string` - Search by title
    - `date: Date` - Search by date
    - `type: string` - Search by type
- **Returns:** `ReportData[]` - Matching reports
- **Related SRS:** SRS-128

#### `displaySearchResults(reports: ReportData[]): void`
- **Parameters:**
  - `reports: ReportData[]` - Search results
- **Returns:** `void` - Displays results in list format
- **Related SRS:** SRS-129

---

### 2.2.9.3 View Report

**System Operations:**

#### `viewReport(reportId: string): ViewResult`
- **Parameters:**
  - `reportId: string` - Report ID
- **Returns:** `ViewResult { success: boolean, reportUrl: string, viewerType: string }`
- **Related SRS:** SRS-130

#### `openBuiltInViewer(reportUrl: string, fileType: string): void`
- **Parameters:**
  - `reportUrl: string` - URL to report
  - `fileType: string` - File type (PDF, image, etc.)
- **Returns:** `void` - Opens in-app viewer
- **Related SRS:** SRS-130

---

## 2.2.10 ChatBot Assistant

### 2.2.10.1 Access Chat Interface

**System Operations:**

#### `openChatInterface(userId: string): ChatSession`
- **Parameters:**
  - `userId: string` - User's ID
- **Returns:** `ChatSession { sessionId: string, startTime: timestamp }`
- **Related SRS:** SRS-131

#### `displayChatMessages(messages: MessageData[]): void`
- **Parameters:**
  - `messages: MessageData[]` - Array of user and bot messages
    - Each `MessageData { senderId, messageText, timestamp, isUserMessage: boolean }`
- **Returns:** `void`
- **Related SRS:** SRS-132

#### `sendMessage(sessionId: string, messageText: string): MessageResult`
- **Parameters:**
  - `sessionId: string` - Chat session ID
  - `messageText: string` - User's message
- **Returns:** `MessageResult { success: boolean, botResponse: string, timestamp: timestamp }`
- **Related SRS:** SRS-132

---

### 2.2.10.2 Apply Safety Filters & Rules

**System Operations:**

#### `applySafetyFilters(messageText: string): FilterResult`
- **Parameters:**
  - `messageText: string` - Message to filter
- **Returns:** `FilterResult { isAllowed: boolean, reason: string }`
- **Related SRS:** SRS-133

#### `blockInappropriateContent(messageText: string): boolean`
- **Parameters:**
  - `messageText: string` - Message to check
- **Returns:** `boolean` - true if content should be blocked
- **Related SRS:** SRS-133

#### `updateSafetyRules(): UpdateResult`
- **Parameters:** None
- **Returns:** `UpdateResult { success: boolean, rulesVersion: string }`
- **Related SRS:** SRS-134

---

## 2.2.11 Help & Support

### 2.2.11.1 View User Guide

**System Operations:**

#### `displayUserGuide(): GuideData`
- **Parameters:** None
- **Returns:** `GuideData { sections: GuideSection[], version: string }`
- **Related SRS:** SRS-135

#### `navigateGuideSection(sectionId: string): void`
- **Parameters:**
  - `sectionId: string` - Guide section ID
- **Returns:** `void`
- **Related SRS:** SRS-135

---

### 2.2.11.2 Submit Contact/Feedback Form

**System Operations:**

#### `openFeedbackForm(): void`
- **Parameters:** None
- **Returns:** `void` - Launches default email client
- **Related SRS:** SRS-136

#### `sendFeedback(feedbackData: FeedbackData): SendResult`
- **Parameters:**
  - `feedbackData: FeedbackData`
    - `userEmail: string` - User's email
    - `subject: string` - Feedback subject
    - `message: string` - Feedback message
- **Returns:** `SendResult { success: boolean, emailClient: string }`
- **Related SRS:** SRS-136

---

### 2.2.11.3 View About Section

**System Operations:**

#### `displayAboutSection(): AboutData`
- **Parameters:** None
- **Returns:** `AboutData { appVersion: string, developerNames: string[], contactInfo: ContactData }`
- **Related SRS:** SRS-137

---

## 2.2.12 Settings & Preferences

### 2.2.12.1 Change App Theme

**System Operations:**

#### `toggleTheme(currentTheme: string): ThemeResult`
- **Parameters:**
  - `currentTheme: string` - "LIGHT" | "DARK"
- **Returns:** `ThemeResult { newTheme: string, success: boolean }`
- **Related SRS:** SRS-138

#### `saveThemePreference(userId: string, theme: string): SaveResult`
- **Parameters:**
  - `userId: string` - User's ID
  - `theme: string` - Selected theme
- **Returns:** `SaveResult { success: boolean }`
- **Related SRS:** SRS-139

---

### 2.2.12.2 Configure Notification Settings

**System Operations:**

#### `setNotificationAppearance(appearance: string): SettingResult`
- **Parameters:**
  - `appearance: string` - "LARGE_ALERT" | "STANDARD"
- **Returns:** `SettingResult { success: boolean, appliedSetting: string }`
- **Related SRS:** SRS-140

#### `setRecurringReminders(reminderConfig: RecurringReminderConfig): ReminderResult`
- **Parameters:**
  - `reminderConfig: RecurringReminderConfig`
    - `time: timestamp` - Reminder time
    - `frequency: string` - Reminder frequency
- **Returns:** `ReminderResult { success: boolean, reminderId: string }`
- **Related SRS:** SRS-141

#### `setNotificationSound(soundId: string): SettingResult`
- **Parameters:**
  - `soundId: string` - Selected sound ID
- **Returns:** `SettingResult { success: boolean, soundName: string }`
- **Related SRS:** SRS-142

---

### 2.2.12.3 Detect & Adjust Time Zone Automatically

**System Operations:**

#### `detectTimeZone(): string`
- **Parameters:** None
- **Returns:** `string` - Detected time zone (e.g., "America/New_York")
- **Related SRS:** SRS-143

#### `adjustRemindersForTimeZone(userId: string, timeZone: string): AdjustmentResult`
- **Parameters:**
  - `userId: string` - User's ID
  - `timeZone: string` - Detected/selected time zone
- **Returns:** `AdjustmentResult { success: boolean, adjustedCount: number }`
- **Related SRS:** SRS-144

---

## 2.2.13 Analytics & Data Visualization

### 2.2.13.1 View Medicine Consumption Reports

**System Operations:**

#### `getMedicineConsumptionReport(userId: string, filterData: ReportFilterData): ConsumptionReportData`
- **Parameters:**
  - `userId: string` - User's ID
  - `filterData: ReportFilterData`
    - `medicineId: string` - Optional filter by medicine
    - `period: string` - "DAILY" | "WEEKLY" | "MONTHLY"
    - `startDate: Date` - Period start
    - `endDate: Date` - Period end
- **Returns:** `ConsumptionReportData { medicines: MedicineConsumptionData[], totalDoses: number }`
- **Related SRS:** SRS-145, SRS-146

#### `displayConsumptionReport(reportData: ConsumptionReportData): void`
- **Parameters:**
  - `reportData: ConsumptionReportData` - Report data
- **Returns:** `void`
- **Related SRS:** SRS-145

#### `highlightIrregularIntake(reportData: ConsumptionReportData): MedicineData[]`
- **Parameters:**
  - `reportData: ConsumptionReportData` - Consumption report
- **Returns:** `MedicineData[]` - Medicines with irregular intake
- **Related SRS:** SRS-147

---

### 2.2.13.2 View Missed Doses Reports

**System Operations:**

#### `getMissedDosesReport(userId: string, period: string): MissedDosesReportData`
- **Parameters:**
  - `userId: string` - User's ID
  - `period: string` - "DAILY" | "WEEKLY" | "MONTHLY"
- **Returns:** `MissedDosesReportData { missedDoses: MissedDoseData[], totalMissed: number }`
  - Each `MissedDoseData { medicineId, medicineName, date, time }`
- **Related SRS:** SRS-148, SRS-149

#### `displayMissedDosesList(missedDoses: MissedDoseData[]): void`
- **Parameters:**
  - `missedDoses: MissedDoseData[]` - List of missed doses
- **Returns:** `void`
- **Related SRS:** SRS-148

#### `getTotalMissedCount(userId: string, period: string): number`
- **Parameters:**
  - `userId: string` - User's ID
  - `period: string` - Time period
- **Returns:** `number` - Total count of missed doses
- **Related SRS:** SRS-149

---

### 2.2.13.3 Display Monthly Summary

**System Operations:**

#### `generateMonthlySummary(userId: string, month: number, year: number): MonthlySummaryData`
- **Parameters:**
  - `userId: string` - User's ID
  - `month: number` - Month (1-12)
  - `year: number` - Year
- **Returns:** `MonthlySummaryData { intakeChart: ChartData, missedChart: ChartData, statistics: StatisticsData }`
- **Related SRS:** SRS-150

#### `displayMonthlyCharts(summaryData: MonthlySummaryData): void`
- **Parameters:**
  - `summaryData: MonthlySummaryData` - Summary data with charts
- **Returns:** `void` - Displays charts for intake and missed doses
- **Related SRS:** SRS-150

---

## Data Type Definitions

### Common Data Types Used Across Operations

```typescript
// User and Authentication
interface UserRegistrationData {
  fullName: string;
  email: string;
  password: string;
  confirmPassword: string;
}

interface LoginCredentials {
  email: string;
  password: string;
}

interface GoogleUserData {
  fullName: string;
  email: string;
  profilePhoto: string;
}

// Profile
interface ProfileData {
  fullName: string;
  email: string;
  bloodGroup: string;
  weight: number;
  height: number;
  bmi: number;
  gender: string;
  dateOfBirth: Date;
  profilePhotoUrl: string;
}

interface HealthInfoData {
  height: number;  // centimeters
  weight: number;  // kilograms
  bloodGroup: string;
}

// Medicine
interface MedicineData {
  medicineId: string;
  name: string;
  dosage: string;
  frequency: FrequencyData;
  reminders: ReminderData[];
  initialStock: number;
  category: string;
  schedule: ScheduleData;
  status: string;  // "ACTIVE" | "COMPLETED"
}

interface FrequencyData {
  timesPerDay: number;
  times: timestamp[];
}

interface ReminderData {
  time: timestamp;
  offset: number;  // minutes before/after
  enabled: boolean;
}

interface ScheduleData {
  type: string;  // "SPECIFIC_DAYS" | "INTERVAL" | "CYCLIC"
  daysOfWeek?: string[];  // ["MON", "WED", "FRI"]
  intervalDays?: number;  // Every X days
  cyclicPattern?: {
    onDays: number;
    offDays: number;
  };
}

// Appointments
interface AppointmentData {
  appointmentId: string;
  date: Date;
  time: timestamp;
  doctorName: string;
  category: string;
  reminder: ReminderData;
  visitNotes: string;
  status: string;  // "UPCOMING" | "COMPLETED"
}

// Health Records
interface AllergyData {
  allergyId: string;
  allergyName: string;
  severity: string;
  reaction: string;
}

interface RestraintData {
  restraintId: string;
  type: string;  // "MEDICATION" | "DIETARY"
  description: string;
  severity: string;
}

interface IllnessData {
  illnessId: string;
  illnessName: string;
  diagnosedDate: Date;
  notes: string;
}

// Inventory
interface StockData {
  medicineId: string;
  medicineName: string;
  currentStock: number;
  lowStockThreshold: number;
}

// Journaling
interface MoodData {
  date: Date;
  mood: string;  // "HAPPY" | "SAD" | "NEUTRAL" | etc.
  notes: string;
}

interface ChallengeData {
  challengeId: string;
  title: string;
  description: string;
  type: string;
}

interface StreakData {
  currentStreak: number;
  longestStreak: number;
  lastUpdated: Date;
}

// Reports
interface ReportData {
  reportId: string;
  title: string;
  date: Date;
  type: string;
  fileUrl: string;
}

// Results
interface ValidationResult {
  isValid: boolean;
  errors?: string[];
  message?: string;
}

interface AddResult {
  success: boolean;
  id: string;
  message: string;
}

interface UpdateResult {
  success: boolean;
  message: string;
}

interface SaveResult {
  success: boolean;
  timestamp?: timestamp;
}
```

---

## Sequence Diagram Notation Guide

When creating actual SSD diagrams, use the following notation:

1. **Actors**: User, System
2. **Messages**: 
   - Actor → System: `methodName(parameters)`
   - System → Actor: `return value`
3. **Activation Boxes**: Show when object is processing
4. **Return Messages**: Dashed lines with return values

### Example SSD Structure:
```
User                    System
 |                        |
 |--registerUser(data)--->|
 |                        |--validate fields
 |                        |--check uniqueness
 |                        |--hash password
 |                        |--send verification email
 |<---RegistrationResult--|
 |                        |
```

---

## Notes

- All timestamps are in ISO 8601 format
- All IDs are unique string identifiers (UUIDs recommended)
- All passwords must be hashed before storage
- All Firebase operations should include error handling
- All validations should occur before database operations
- All user-facing messages should be localized
- All dates should respect user's time zone
- All notifications require appropriate permissions

---

**Document Version:** 1.0  
**Last Updated:** December 2025  
**Status:** Complete
