import 'package:flutter_test/flutter_test.dart';
import 'package:personal_medicine_reminder/utils/validators.dart';
import 'package:personal_medicine_reminder/utils/helpers.dart';
import 'package:personal_medicine_reminder/models/user_model.dart';
import 'package:personal_medicine_reminder/models/medicine_model.dart';

void main() {
  group('Validators', () {
    group('Email Validation - SRS 2.1.1 (SRS-1)', () {
      test('should return error for empty email', () {
        expect(Validators.validateEmail(''), 'Email is required');
        expect(Validators.validateEmail(null), 'Email is required');
      });

      test('should return error for invalid email', () {
        expect(Validators.validateEmail('invalid'), 'Please enter a valid email address');
        expect(Validators.validateEmail('test@'), 'Please enter a valid email address');
      });

      test('should return null for valid email', () {
        expect(Validators.validateEmail('test@example.com'), null);
        expect(Validators.validateEmail('user.name@domain.co'), null);
      });
    });

    group('Password Validation - SRS 2.1.1 (SRS-3)', () {
      test('should return error for empty password', () {
        expect(Validators.validatePassword(''), 'Password is required');
        expect(Validators.validatePassword(null), 'Password is required');
      });

      test('should return error for short password', () {
        expect(
          Validators.validatePassword('Ab1'),
          'Password must be at least 8 characters',
        );
      });

      test('should return error for password without uppercase', () {
        expect(
          Validators.validatePassword('password123'),
          'Password must contain at least one uppercase letter',
        );
      });

      test('should return error for password without number', () {
        expect(
          Validators.validatePassword('Passworddd'),
          'Password must contain at least one number',
        );
      });

      test('should return null for valid password', () {
        expect(Validators.validatePassword('Password1'), null);
        expect(Validators.validatePassword('MySecure123'), null);
      });
    });

    group('Confirm Password Validation - SRS 2.1.5 (SRS-22)', () {
      test('should return error for empty confirm password', () {
        expect(
          Validators.validateConfirmPassword('', 'Password1'),
          'Please confirm your password',
        );
      });

      test('should return error for mismatched passwords', () {
        expect(
          Validators.validateConfirmPassword('Password1', 'Password2'),
          'Passwords do not match',
        );
      });

      test('should return null for matching passwords', () {
        expect(
          Validators.validateConfirmPassword('Password1', 'Password1'),
          null,
        );
      });
    });

    group('Medicine Name Validation - SRS 2.3.1 (SRS-62)', () {
      test('should return error for empty medicine name', () {
        expect(
          Validators.validateMedicineName(''),
          'Medicine name is required',
        );
      });

      test('should return error for short medicine name', () {
        expect(
          Validators.validateMedicineName('A'),
          'Medicine name must be at least 2 characters',
        );
      });

      test('should return null for valid medicine name', () {
        expect(Validators.validateMedicineName('Paracetamol'), null);
      });
    });

    group('Height Validation - SRS 2.2.3 (SRS-49)', () {
      test('should return null for empty height (optional)', () {
        expect(Validators.validateHeight(''), null);
        expect(Validators.validateHeight(null), null);
      });

      test('should return error for invalid height', () {
        expect(Validators.validateHeight('abc'), 'Please enter a valid height');
        expect(
          Validators.validateHeight('10'),
          'Height must be between 30 and 300 cm',
        );
      });

      test('should return null for valid height', () {
        expect(Validators.validateHeight('170'), null);
      });
    });

    group('Weight Validation - SRS 2.2.3 (SRS-50)', () {
      test('should return null for empty weight (optional)', () {
        expect(Validators.validateWeight(''), null);
      });

      test('should return error for invalid weight', () {
        expect(Validators.validateWeight('abc'), 'Please enter a valid weight');
        expect(
          Validators.validateWeight('0'),
          'Weight must be between 1 and 500 kg',
        );
      });

      test('should return null for valid weight', () {
        expect(Validators.validateWeight('70'), null);
      });
    });
  });

  group('Helpers', () {
    group('BMI Calculation - SRS 2.2.1 (SRS-34)', () {
      test('should return null for invalid inputs', () {
        expect(Helpers.calculateBMI(null, 70), null);
        expect(Helpers.calculateBMI(170, null), null);
        expect(Helpers.calculateBMI(0, 70), null);
      });

      test('should calculate BMI correctly', () {
        // BMI = 70 / (1.7 * 1.7) ≈ 24.22
        final bmi = Helpers.calculateBMI(170, 70);
        expect(bmi, closeTo(24.22, 0.1));
      });
    });

    group('BMI Category', () {
      test('should return correct category', () {
        expect(Helpers.getBMICategory(17), 'Underweight');
        expect(Helpers.getBMICategory(22), 'Normal');
        expect(Helpers.getBMICategory(27), 'Overweight');
        expect(Helpers.getBMICategory(32), 'Obese');
      });
    });

    group('Date Formatting', () {
      test('should format date correctly', () {
        final date = DateTime(2025, 11, 27);
        expect(Helpers.formatDate(date), 'Nov 27, 2025');
      });
    });

    group('Mood Emoji', () {
      test('should return correct emoji for mood', () {
        expect(Helpers.getMoodEmoji('Happy'), '😊');
        expect(Helpers.getMoodEmoji('Sad'), '😢');
        expect(Helpers.getMoodEmoji('Neutral'), '😐');
      });
    });

    group('Medicine Category Icon', () {
      test('should return correct icon for category', () {
        expect(Helpers.getMedicineCategoryIcon('Tablet'), '💊');
        expect(Helpers.getMedicineCategoryIcon('Syrup'), '🥤');
        expect(Helpers.getMedicineCategoryIcon('Injection'), '💉');
      });
    });

    group('Initials Generation', () {
      test('should generate initials correctly', () {
        expect(Helpers.getInitials('John Doe'), 'JD');
        expect(Helpers.getInitials('Alice'), 'A');
        expect(Helpers.getInitials(''), '');
      });
    });
  });

  group('UserModel', () {
    group('BMI Calculation - SRS 2.2.3 (SRS-52)', () {
      test('should calculate BMI from user model', () {
        final user = UserModel(
          id: '1',
          email: 'test@test.com',
          fullName: 'Test User',
          height: 170,
          weight: 70,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        expect(user.bmi, closeTo(24.22, 0.1));
        expect(user.bmiCategory, 'Normal');
      });

      test('should return null for missing data', () {
        final user = UserModel(
          id: '1',
          email: 'test@test.com',
          fullName: 'Test User',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        expect(user.bmi, null);
        expect(user.bmiCategory, null);
      });
    });

    group('Age Calculation', () {
      test('should calculate age correctly', () {
        final user = UserModel(
          id: '1',
          email: 'test@test.com',
          fullName: 'Test User',
          dateOfBirth: DateTime(1990, 1, 1),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        expect(user.age, greaterThan(30));
      });
    });
  });

  group('MedicineModel', () {
    group('Low Stock Check - SRS 2.6.1 (SRS-98)', () {
      test('should return true for low stock', () {
        final medicine = MedicineModel(
          id: '1',
          userId: '1',
          name: 'Test Medicine',
          category: 'Tablet',
          dosage: '500mg',
          currentStock: 3,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        expect(medicine.isLowStock, true);
      });

      test('should return false for adequate stock', () {
        final medicine = MedicineModel(
          id: '1',
          userId: '1',
          name: 'Test Medicine',
          category: 'Tablet',
          dosage: '500mg',
          currentStock: 10,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        expect(medicine.isLowStock, false);
      });
    });
  });
}
