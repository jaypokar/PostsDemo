import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../core/constants/app_constants.dart';
import '../models/user_model.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final FirebaseFirestore _firestore;

  AuthRepository({
    FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
    FirebaseFirestore? firestore,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn(),
        _firestore = firestore ?? FirebaseFirestore.instance;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  User? get currentUser => _firebaseAuth.currentUser;

  Future<UserModel?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);

      if (userCredential.user != null) {
        final user = userCredential.user!;
        final userModel = UserModel(
          id: user.uid,
          email: user.email ?? '',
          username: user.displayName ?? 'User',
          photoUrl: user.photoURL,
          createdAt: DateTime.now(),
        );

        await _saveUserToFirestore(userModel);
        return userModel;
      }
    } catch (e) {
      throw Exception('Google sign in failed: $e');
    }
    return null;
  }

  Future<UserModel?> signInWithEmailPassword(String email, String password) async {
    try {
      final UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        final user = userCredential.user!;
        var userModel = await getUserData(user.uid);

        // If user document doesn't exist, create it
        if (userModel == null) {
          userModel = UserModel(
            id: user.uid,
            email: user.email ?? email,
            username: user.displayName ?? email.split('@')[0],
            photoUrl: user.photoURL,
            createdAt: DateTime.now(),
          );
          await _saveUserToFirestore(userModel);
        }

        return userModel;
      }
    } catch (e) {
      throw Exception('Email sign in failed: $e');
    }
    return null;
  }

  Future<UserModel?> signUpWithEmailPassword(
    String email,
    String password,
    String username,
  ) async {
    try {
      debugPrint('🔄 AuthRepository - Creating user with email: $email');

      final UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      debugPrint('✅ AuthRepository - User created successfully');

      if (userCredential.user != null) {
        final user = userCredential.user!;
        debugPrint('🔄 AuthRepository - Creating user model');

        final userModel = UserModel(
          id: user.uid,
          email: email,
          username: username,
          createdAt: DateTime.now(),
        );

        debugPrint('🔄 AuthRepository - Saving user to Firestore');
        await _saveUserToFirestore(userModel);
        debugPrint('✅ AuthRepository - User saved to Firestore');

        return userModel;
      }
    } on FirebaseAuthException catch (e) {
      debugPrint('❌ AuthRepository - Firebase Auth Exception: ${e.code} - ${e.message}');
      throw Exception('Email sign up failed: ${e.message}');
    } catch (e) {
      debugPrint('❌ AuthRepository - General Exception: $e');
      // Handle the specific type cast error
      if (e.toString().contains('PigeonUserDetails')) {
        debugPrint('🔧 AuthRepository - Handling PigeonUserDetails error, retrying...');

        // Wait a moment and try to get the current user
        await Future.delayed(const Duration(milliseconds: 500));

        final currentUser = _firebaseAuth.currentUser;
        if (currentUser != null) {
          debugPrint('✅ AuthRepository - Found current user after retry');

          final userModel = UserModel(
            id: currentUser.uid,
            email: email,
            username: username,
            createdAt: DateTime.now(),
          );

          await _saveUserToFirestore(userModel);
          return userModel;
        }
      }
      throw Exception('Email sign up failed: $e');
    }
    return null;
  }

  Future<void> signOut() async {
    await Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }

  Future<UserModel?> getUserData(String userId) async {
    try {
      debugPrint('🔍 AuthRepository - Getting user data for: $userId');
      final doc = await _firestore.collection(AppConstants.usersCollection).doc(userId).get();

      if (doc.exists) {
        debugPrint('✅ AuthRepository - User document found');
        return UserModel.fromMap(doc.data()!);
      } else {
        debugPrint('❌ AuthRepository - User document not found');
        // If user document doesn't exist, create it from Firebase Auth user
        final firebaseUser = _firebaseAuth.currentUser;
        if (firebaseUser != null && firebaseUser.uid == userId) {
          debugPrint('🔧 AuthRepository - Creating user document from Firebase Auth user');
          final userModel = UserModel(
            id: firebaseUser.uid,
            email: firebaseUser.email ?? '',
            username: firebaseUser.displayName ?? firebaseUser.email?.split('@')[0] ?? 'User',
            photoUrl: firebaseUser.photoURL,
            createdAt: DateTime.now(),
          );
          await _saveUserToFirestore(userModel);
          return userModel;
        }
      }
    } catch (e) {
      debugPrint('❌ AuthRepository - Error getting user data: $e');
      throw Exception('Failed to get user data: $e');
    }
    return null;
  }

  Future<void> _saveUserToFirestore(UserModel user) async {
    await _firestore
        .collection(AppConstants.usersCollection)
        .doc(user.id)
        .set(user.toMap(), SetOptions(merge: true));
  }
}
