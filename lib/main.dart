import 'package:flutter/material.dart';
import 'package:flutter_application_api_bloc/core/di/dependency_injection.dart';
import 'package:flutter_application_api_bloc/core/helper/sharedpreferences.dart';
import 'package:flutter_application_api_bloc/core/helper/themes.dart';
import 'package:flutter_application_api_bloc/core/services/firebase_auth_service.dart';
import 'package:flutter_application_api_bloc/core/services/firebase_notification_service.dart';
import 'package:flutter_application_api_bloc/core/services/local_notification.dart';
import 'package:flutter_application_api_bloc/features/add_task/cubit/tasks_cubit.dart';
import 'package:flutter_application_api_bloc/features/home/cubit/theme_cubit.dart';
import 'package:flutter_application_api_bloc/features/localization/cubit/locale_cubit.dart';
import 'package:flutter_application_api_bloc/features/splash_onbording/views/splash.dart';
import 'package:flutter_application_api_bloc/generated/l10n.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_localizations/flutter_localizations.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Future.wait([
    CacheHelper.init(),
    initDependencies(),
    FirebaseNotification.initFirebaseMessaging(),
    LocalNotificationService.init(),
    LocalNotificationService.showDailySchduledNotification()
  ]);

  // await CacheHelper.init(); // ✅ تهيئة SharedPreferences
  // await LocalNotificationService.init();
  // await FirebaseNotification.initFirebaseMessaging();
  runApp(MultiBlocProvider(
    providers: [
      // BlocProvider(
      //     create: (_) =>
      //         TasksCubit(repository: sl<TasksRepositoryImplement>())),
      //OR

      BlocProvider(
        create: (_) => locator<TasksCubit>()
          ..listenToTasks(FirebaseAuthService().currentUser!.uid),
        //OR

        // create: (_) => TasksCubit(
        //   repository: TasksRepositoryImplement(
        //     firebaseHomeService: FirebaseHomeService(),
        //   ),
        // )..listenToTasks(FirebaseAuthService().currentUser!.uid),
      ),
      BlocProvider(create: (_) => ThemeCubit()..loadTheme()),
      BlocProvider(create: (_) => LocaleCubit()..loadLocale()), // ✅ أضفناها
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: false,
      // Use builder only if you need to use library outside ScreenUtilInit context
      builder: (_, child) {
        return BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, themeMode) {
          return MaterialApp(
            locale:
                context.watch<LocaleCubit>().state, // 🧠 ربط اللغة بالـ Cubit
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'),
              Locale('ar'),
            ],
            debugShowCheckedModeBanner: false,
            title: 'First Method',
            // You can use the library anywhere in the app even in theme
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode, // 🔥 ربط الثيم بالـ Cubit
            home: child,
          );
        });
      },
      child: const SplashScreen(),
    );
  }
}
