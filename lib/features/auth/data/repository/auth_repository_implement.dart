import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_api_bloc/core/models/user_model.dart';
import 'package:flutter_application_api_bloc/core/services/firebase_auth_service.dart';
import 'package:flutter_application_api_bloc/core/services/firebase_firestore_service.dart';
import 'package:flutter_application_api_bloc/features/auth/data/model/auth_model.dart';
import 'package:flutter_application_api_bloc/features/auth/data/repository/auth_repository.dart';

class AuthRepositoryImplement implements AuthRepository {
  String message = "";
  final FirebaseAuthService _firebaseService = FirebaseAuthService();
  @override
  Future<AuthResult> login({required UserModel user}) async {
    try {
      final credential =
          await _firebaseService.signIn(user.email, user.password!);
      final firebaseUser = credential.user;

      if (firebaseUser != null && !firebaseUser.emailVerified) {
        // await firebaseUser.sendEmailVerification(); // يبعت تاني لو لسه
        await FirebaseAuth.instance.signOut(); // يخرجه مؤقتًا
        return AuthResult(
          success: false,
          message: 'Please verify your email. 📧',
        );
      }

      return AuthResult(
        success: true,
        message: "Login successful ✅",
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided.';
      }
      return AuthResult(
        success: false,
        message: message,
      );
    } catch (e) {
      return AuthResult(
        success: false,
        message: 'Login failed ${e.toString()}',
      );
    }
  }

  @override
  Future<AuthResult> register({required UserModel user}) async {
    try {
      final credential =
          await _firebaseService.register(user.email, user.password!);

      final firebaseUser = credential.user;

      // ✅ استدعاء خدمة Firestore لحفظ البيانات
      final homeService = FirebaseHomeService();
      await homeService.saveUserData(
        UserModel(
          id: firebaseUser!.uid,
          email: user.email,
        ),
      );

      // ✅ بعد إنشاء المستخدم ابعت إيميل التفعيل
      await credential.user?.sendEmailVerification();

      return AuthResult(
        success: true,
        message: 'successful verify your email.',
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
        log(message);
        return AuthResult(
          success: false,
          message: message,
        );
      } else if (e.code == 'email-already-in-use') {
        message = 'The account already exists .';
        log(message);
      }
      return AuthResult(
        success: false,
        message: message,
      );
    } catch (e) {
      log(e.toString());
      return AuthResult(
        success: false,
        message: 'Registration failed ${e.toString()}',
      );
    }
  }
}
