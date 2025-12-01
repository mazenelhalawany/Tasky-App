import 'package:flutter/material.dart';
import 'package:flutter_application_api_bloc/core/helper/sharedpreferences.dart';
import 'package:flutter_application_api_bloc/core/services/firebase_auth_service.dart';
import 'package:flutter_application_api_bloc/features/auth/view/login.dart';
import 'package:flutter_application_api_bloc/features/home/views/home.dart';
import 'package:flutter_application_api_bloc/features/splash_onbording/views/onbording.dart';

class AuthCheck extends StatelessWidget {
  const AuthCheck({super.key});
  

  Future<Widget> _getNextScreen() async {
      FirebaseAuthService authRepository = FirebaseAuthService();   

    final onboardingSeen = CacheHelper.getData(key: 'onboarding_seen') ?? false;
    final loginSuccess = CacheHelper.getData(key: 'login_success') ?? false;

    if (!onboardingSeen) {
      CacheHelper.saveData(key: 'onboarding_seen', value: true);
      return const Onbording();
    } else if (loginSuccess) {
      return  Home(userId:authRepository.currentUser!.uid ,);
    } else {
      return const Login();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _getNextScreen(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return snapshot.data!;
      },
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_application_api_bloc/core/helper/sharedpreferences.dart';
// import 'package:flutter_application_api_bloc/features/auth/view/login.dart';
// import 'package:flutter_application_api_bloc/features/home/views/home.dart';
// import 'package:flutter_application_api_bloc/features/splash_onbording/views/onbording.dart';

// class AuthCheck extends StatefulWidget {
//   const AuthCheck({super.key});

//   @override
//   State<AuthCheck> createState() => _AuthCheckState();
// }

// class _AuthCheckState extends State<AuthCheck> {
//   Widget nextScreen=const Onbording();

//   @override
//   void initState() {
//     super.initState();
//     checkOnboardingStatus();
//   }

//   void checkOnboardingStatus() {
//     bool? onboardingSeen = CacheHelper.getData(key: 'onboarding_seen');

//     bool? loginSuccess = CacheHelper.getData(key: 'login_success');

//     // نحدد الشاشة اللي هنروحها بعد السبلاتش

//     if (onboardingSeen == null || onboardingSeen == false) {
//       nextScreen = const Onbording();
//       CacheHelper.saveData(key: 'onboarding_seen', value: true);
//     } else if (loginSuccess == true) {
//       nextScreen = const Home();
//     } else {
//       nextScreen = const Login();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // نحاول نقرأ القيمة المخزنة

//     return nextScreen;
//   }
// }

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_application_api_bloc/features/auth/view/login.dart';
// import 'package:flutter_application_api_bloc/features/home/views/home.dart';

// class AuthCheck extends StatelessWidget {
//   const AuthCheck({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<User?>(
//       stream: FirebaseAuth.instance.authStateChanges(),
//       builder: (context, snapshot) {
//         // لسه بيفحص
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         }
//         // مسجل دخول
//         if (snapshot.hasData) {
//           return const Home();
//         }
//         // مش مسجل
//         return const Login();
//       },
//     );
//   }
// }
