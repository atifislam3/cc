import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_model.dart';
import '../config/constants.dart';

/// Authentication Provider
/// 
/// Implements SRS 2.1 - Authentication
/// Handles user authentication, registration, and session management
class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _firebaseUser;
  UserModel? _user;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  User? get firebaseUser => _firebaseUser;
  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _firebaseUser != null;
  bool get isGoogleUser => _user?.isGoogleUser ?? false;

  AuthProvider() {
    // Listen to auth state changes
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  /// Handle auth state changes
  void _onAuthStateChanged(User? firebaseUser) async {
    _firebaseUser = firebaseUser;
    if (firebaseUser != null) {
      await _loadUserData();
    } else {
      _user = null;
    }
    notifyListeners();
  }

  /// Load user data from Firestore
  Future<void> _loadUserData() async {
    if (_firebaseUser == null) return;
    
    try {
      final doc = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(_firebaseUser!.uid)
          .get();
      
      if (doc.exists) {
        _user = UserModel.fromFirestore(doc);
      }
    } catch (e) {
      debugPrint('Error loading user data: $e');
    }
  }

  /// Sign Up with Email/Password - SRS 2.1.1
  /// SRS-1 to SRS-7
  Future<bool> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // SRS-3: Validate password requirements
      if (!_isValidPassword(password)) {
        _errorMessage = 'Password must be at least 8 characters with one uppercase letter and one number.';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Create user with Firebase Auth
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        // SRS-5: Send verification email
        await credential.user!.sendEmailVerification();

        // Create user document in Firestore
        final newUser = UserModel(
          id: credential.user!.uid,
          email: email,
          fullName: fullName,
          isGoogleUser: false,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await _firestore
            .collection(AppConstants.usersCollection)
            .doc(credential.user!.uid)
            .set(newUser.toFirestore());

        _user = newUser;
        _isLoading = false;
        notifyListeners();
        return true;
      }

      _isLoading = false;
      notifyListeners();
      return false;
    } on FirebaseAuthException catch (e) {
      // SRS-6: Handle duplicate email
      if (e.code == 'email-already-in-use') {
        _errorMessage = 'An account already exists with this email address.';
      } else {
        _errorMessage = e.message ?? 'Registration failed. Please try again.';
      }
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'An error occurred. Please try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Login with Email/Password - SRS 2.1.2
  /// SRS-8 to SRS-11
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // SRS-9: Validate credentials
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        await _loadUserData();
        _isLoading = false;
        notifyListeners();
        // SRS-10: Redirect to dashboard (handled by navigation)
        return true;
      }

      _isLoading = false;
      notifyListeners();
      return false;
    } on FirebaseAuthException catch (e) {
      // SRS-11: Display error message
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        _errorMessage = 'Invalid email or password.';
      } else {
        _errorMessage = e.message ?? 'Login failed. Please try again.';
      }
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'An error occurred. Please try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Logout - SRS 2.1.3
  /// SRS-12 to SRS-14
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      // SRS-13: Terminate session
      await _googleSignIn.signOut();
      await _auth.signOut();
      
      _user = null;
      _firebaseUser = null;
      _isLoading = false;
      // SRS-14: Redirect to login (handled by navigation)
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Forgot Password - SRS 2.1.4
  /// SRS-15 to SRS-18
  Future<bool> forgotPassword(String email) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // SRS-16: Send password reset link
      await _auth.sendPasswordResetEmail(email: email);
      
      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _errorMessage = 'No user found with this email address.';
      } else {
        _errorMessage = e.message ?? 'Failed to send reset email.';
      }
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'An error occurred. Please try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Change Password - SRS 2.1.5
  /// SRS-19 to SRS-24
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    // SRS-24: Disable for Google users
    if (isGoogleUser) {
      _errorMessage = 'Password cannot be changed for Google login accounts.';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // SRS-21: Validate new password
      if (!_isValidPassword(newPassword)) {
        _errorMessage = 'Password must be at least 8 characters with one uppercase letter and one number.';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // SRS-20: Verify current password
      final credential = EmailAuthProvider.credential(
        email: _firebaseUser!.email!,
        password: currentPassword,
      );
      await _firebaseUser!.reauthenticateWithCredential(credential);

      // Update password
      await _firebaseUser!.updatePassword(newPassword);

      _isLoading = false;
      // SRS-23: Success message handled by UI
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        _errorMessage = 'Current password is incorrect.';
      } else {
        _errorMessage = e.message ?? 'Failed to change password.';
      }
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'An error occurred. Please try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Google Sign In - SRS 2.1.6
  /// SRS-25 to SRS-30
  Future<bool> signInWithGoogle() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // SRS-25: Sign in with Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final GoogleSignInAuthentication googleAuth = 
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);

      if (userCredential.user != null) {
        // SRS-26: Retrieve basic user info
        // SRS-27: Create new user if not exists
        final docRef = _firestore
            .collection(AppConstants.usersCollection)
            .doc(userCredential.user!.uid);
        
        final doc = await docRef.get();
        
        if (!doc.exists) {
          final newUser = UserModel(
            id: userCredential.user!.uid,
            email: userCredential.user!.email ?? '',
            fullName: userCredential.user!.displayName ?? '',
            profilePhotoUrl: userCredential.user!.photoURL,
            isGoogleUser: true, // SRS-30
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

          await docRef.set(newUser.toFirestore());
          _user = newUser;
        } else {
          // SRS-28: Log in existing user
          _user = UserModel.fromFirestore(doc);
        }

        _isLoading = false;
        // SRS-29: Redirect to home (handled by navigation)
        notifyListeners();
        return true;
      }

      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Google sign in failed. Please try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Update user profile - SRS 2.2.2
  Future<bool> updateProfile(UserModel updatedUser) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(_firebaseUser!.uid)
          .update(updatedUser.toFirestore());

      _user = updatedUser;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to update profile.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Validate password - SRS-3, SRS-21
  bool _isValidPassword(String password) {
    if (password.length < AppConstants.minPasswordLength) return false;
    
    // At least one uppercase letter
    if (!password.contains(RegExp(r'[A-Z]'))) return false;
    
    // At least one number
    if (!password.contains(RegExp(r'[0-9]'))) return false;
    
    return true;
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
