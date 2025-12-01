import 'package:flutter/material.dart';
import 'package:flutter_application_api_bloc/core/di/dependency_injection.dart';
import 'package:flutter_application_api_bloc/core/helper/navigation.dart';
import 'package:flutter_application_api_bloc/core/services/local_notification.dart';
import 'package:flutter_application_api_bloc/core/utils/colors.dart';
import 'package:flutter_application_api_bloc/core/utils/fonts.dart';
import 'package:flutter_application_api_bloc/core/utils/icons.dart';
import 'package:flutter_application_api_bloc/core/utils/pictures.dart';
import 'package:flutter_application_api_bloc/core/widgets/custom_button.dart';
import 'package:flutter_application_api_bloc/core/widgets/custom_card.dart';
import 'package:flutter_application_api_bloc/core/widgets/custom_svg.dart';
import 'package:flutter_application_api_bloc/core/widgets/custom_home_card.dart';
import 'package:flutter_application_api_bloc/features/add_task/cubit/tasks_cubit.dart';
import 'package:flutter_application_api_bloc/features/add_task/cubit/tasks_state.dart';
import 'package:flutter_application_api_bloc/features/add_task/data/model/task_model.dart';
import 'package:flutter_application_api_bloc/features/add_task/views/addtask.dart';
import 'package:flutter_application_api_bloc/features/auth/cubit/logout_cubit.dart';
import 'package:flutter_application_api_bloc/features/auth/cubit/logout_state.dart';
import 'package:flutter_application_api_bloc/features/auth/view/login.dart';
import 'package:flutter_application_api_bloc/features/home/cubit/home_cubit.dart';
import 'package:flutter_application_api_bloc/features/home/cubit/home_state.dart';
import 'package:flutter_application_api_bloc/features/home/cubit/theme_cubit.dart';
import 'package:flutter_application_api_bloc/features/home/views/notificationscreen.dart';
import 'package:flutter_application_api_bloc/features/localization/cubit/locale_cubit.dart';
import 'package:flutter_application_api_bloc/generated/l10n.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.userId,});
  final String userId;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    LocalNotificationService.streamController.stream.listen((response) {
      AppNavigationType.navigate(
        context,
        page: const NotificationScreen(),
        type: AppNavigation.push,
      );
    });

  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => LogoutCubit()),
        BlocProvider(
          create: (_) =>locator<HomeCubit>()..fetchUserData(widget.userId),
        ),
      ],
      child: BlocConsumer<LogoutCubit, LogoutState>(
        listener: (context, state) {
          if (state is LogoutSuccess) {
            AppNavigationType.navigate(
              context,
              page: const Login(),
              type: AppNavigation.pushReplacement,
            );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(S.of(context).logoutsuccess)),
            );
          } else if (state is LogoutFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content:
                      Text("${S.of(context).logoutfailure} ${state.error}")),
            );
          }
        },
        builder: (context, state) {
          final themeCubit = ThemeCubit.get(context);
          final localeCubit = LocaleCubit.get(context);
          final logoutCubit = LogoutCubit.get(context);

          return Scaffold(
            appBar: AppBar(
              leading: null,
              toolbarHeight: 80.h,
              title: BlocBuilder<HomeCubit, HomeState>(
                builder: (context, homeState) {
                  if (homeState is HomeLoadingState) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (homeState is HomeLoadedState) {
                    final user = homeState.user;
                    return Row(
                      children: [
                        Container(
                          margin: const EdgeInsetsDirectional.only(end: 15),
                          height: 50.h,
                          width: 50.h,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: AssetImage(AppImages.plastine),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("${S.of(context).hello} 👋"),
                              Text(user.email,
                                  style: TextStyle(fontSize: 16.sp)),
                            ],
                          ),
                        ),
                      ],
                    );
                  } else if (homeState is HomeErrorState) {
                    return Text(homeState.message);
                  }
                  return const Text("Home");
                },
              ),
              actions: [
                TextButton(
                  child: Text(
                    localeCubit.state.languageCode == 'en' ? 'AR' : 'EN',
                    style: TextStyle(color: Colors.white, fontSize: 15.sp),
                  ),
                  onPressed: () => localeCubit.toggleLocale(),
                ),
                BlocBuilder<ThemeCubit, ThemeMode>(
                  builder: (context, state) {
                    return IconButton(
                      icon: Icon(
                        state == ThemeMode.dark
                            ? Icons.wb_sunny
                            : Icons.nightlight_round,
                        size: 20.sp,
                      ),
                      onPressed: () => themeCubit.toggleTheme(),
                    );
                  },
                ),
                IconButton(
                  onPressed: () => logoutCubit.logout(),
                  icon: Icon(Icons.logout, size: 20.sp),
                ),
              ],
            ),

            // 🔹 هنا عرض التاسكات
            body: BlocBuilder<TasksCubit, TasksState>(
              builder: (context, state) {
                if (state is GetTasksLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is GetTasksSuccessState) {
                  final List<TaskModel> tasks = state.tasks;
                  // عد المهام لكل group
                  int personalCount =
                      tasks.where((task) => task.group == "Personal").length;
                  int homeCount =
                      tasks.where((task) => task.group == "Home").length;
                  int workCount =
                      tasks.where((task) => task.group == "Work").length;

                  if (tasks.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            S.of(context).not_task,
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: AppFonts.light,
                            ),
                          ),
                          SizedBox(height: 20.h),
                          CustomSvg(
                            assetName: AppIcons.tasks,
                            width: 250.w,
                            height: 200.w,
                          ),
                        ],
                      ),
                    );
                  }

                  // 🔹 عرض المهام في ListView
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        CustomCard(
                            needButton: true,
                            descriptionsize: 40.sp,
                            width: 335.w,
                            height: 135.w,
                            title: "Your today’s tasks \n almost done!",
                            description: "80%",
                            icon: null,
                            cardColor: AppColors.buttoncolor,
                            iconColor: null),
                        SizedBox(
                          height: 20.h,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Row(
                            children: [
                              Text(
                                "In Progress",
                                style: TextStyle(fontSize: 15.sp),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.green[100],
                                    borderRadius: BorderRadius.circular(10.r)),
                                width: 22,
                                height: 23,
                                child: Center(
                                  child: Text(
                                    "${tasks.length}",
                                    style: const TextStyle(
                                        color: AppColors.buttoncolor),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        const SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Padding(
                            padding: EdgeInsets.only(left: 5),
                            child: Row(
                              children: [
                                CustomCard(
                                    isBlack: true,
                                    title: "Work Tasks",
                                    description: "Add New Features",
                                    icon: CustomSvg(assetName: AppIcons.work),
                                    cardColor: AppColors.blackcard,
                                    iconColor: null),
                                CustomCard(
                                    title: "Personal Tasks",
                                    description: "Improve my English skills",
                                    icon:
                                        CustomSvg(assetName: AppIcons.personal),
                                    cardColor: AppColors.greencard,
                                    iconColor: null),
                                CustomCard(
                                    title: "Home Tasks",
                                    description: "Add new feature ",
                                    icon: CustomSvg(assetName: AppIcons.home),
                                    cardColor: AppColors.pinkcard,
                                    iconColor: null),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Row(
                            children: [
                              Text(
                                "Task Groups",
                                style: TextStyle(fontSize: 15.sp),
                              ),
                            ],
                          ),
                        ),
                        CustomCardTileHome(
                          title: "Personal Task",
                          count: personalCount,
                          icon: Icons.person,
                          iconBackgroundColor: Colors.green,
                          countBackgroundColor: Colors.green,
                        ),
                        CustomCardTileHome(
                          title: "Home Task",
                          count: homeCount,
                          icon: Icons.home,
                          iconBackgroundColor: Colors.pink,
                          countBackgroundColor: Colors.pink,
                        ),
                        CustomCardTileHome(
                          title: "Work Task",
                          count: workCount,
                          icon: Icons.work,
                          iconBackgroundColor: Colors.black,
                          countBackgroundColor: Colors.black,
                        ),
                        CustomButton(
                            onPressed: () {
                              // RemoteMessage fakeMessage = const RemoteMessage(
                              //   notification: RemoteNotification(
                              //     title: "Hello Mazen 👋",
                              //     body: "This is a custom notification!",
                              //   ),
                              // );
                              LocalNotificationService.showDailySchduledNotification();
                                  
                            },
                            text: "basic notification")
                      ],
                    ),
                  );
                } else if (state is GetTasksErrorState) {
                  return Center(child: Text('Error: ${state.getmessage}'));
                }
                return const SizedBox();
              },
            ),

            floatingActionButton: FloatingActionButton(
              onPressed: () {
                AppNavigationType.navigate(
                  context,
                  page: AddTaskScreen(),
                  type: AppNavigation.push,
                );
              },
              backgroundColor: AppColors.buttoncolor,
              child: Icon(Icons.add, size: 24.sp),
            ),
          );
        },
      ),
    );
  }
}


// import 'dart:math';

// import 'package:flutter/material.dart';
// import 'package:flutter_application_api_bloc/core/helper/navigation.dart';
// import 'package:flutter_application_api_bloc/core/utils/colors.dart';
// import 'package:flutter_application_api_bloc/core/utils/fonts.dart';
// import 'package:flutter_application_api_bloc/core/utils/icons.dart';
// import 'package:flutter_application_api_bloc/core/utils/pictures.dart';
// import 'package:flutter_application_api_bloc/core/widgets/custom_button.dart';
// import 'package:flutter_application_api_bloc/core/widgets/custom_card.dart';
// import 'package:flutter_application_api_bloc/core/widgets/custom_cardtile.dart';
// import 'package:flutter_application_api_bloc/core/widgets/custom_svg.dart';
// import 'package:flutter_application_api_bloc/features/add_task/cubit/tasks_cubit.dart';
// import 'package:flutter_application_api_bloc/features/add_task/cubit/tasks_state.dart';
// import 'package:flutter_application_api_bloc/features/add_task/views/addtask.dart';
// import 'package:flutter_application_api_bloc/features/auth/cubit/logout_cubit.dart';
// import 'package:flutter_application_api_bloc/features/auth/cubit/logout_state.dart';
// import 'package:flutter_application_api_bloc/features/auth/view/login.dart';
// import 'package:flutter_application_api_bloc/features/home/cubit/home_cubit.dart';
// import 'package:flutter_application_api_bloc/features/home/cubit/home_state.dart';
// import 'package:flutter_application_api_bloc/features/home/cubit/theme_cubit.dart';
// import 'package:flutter_application_api_bloc/features/home/data/repository/home_repository_implement.dart';
// import 'package:flutter_application_api_bloc/core/services/firebase_firestore_service.dart';
// import 'package:flutter_application_api_bloc/features/localization/cubit/locale_cubit.dart';
// import 'package:flutter_application_api_bloc/generated/l10n.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class Home extends StatelessWidget {
//   const Home({super.key, required this.userId});
//   final String userId;
//   @override
//   Widget build(BuildContext context) {
//     bool isDataLoaded = true; //Random().nextBool();

//     return MultiBlocProvider(
//       providers: [
//         BlocProvider(create: (_) => LogoutCubit()),
//         BlocProvider(
//           create: (_) => HomeCubit(
//             repository: HomeRepositoryImplement(
//               firebaseHomeService: FirebaseHomeService(),
//             ),
//           )..fetchUserData(userId),
//         ),
//       ],
//       child: BlocConsumer<LogoutCubit, LogoutState>(
//         listener: (context, state) {
//           if (state is LogoutSuccess) {
//             AppNavigationType.navigate(
//               context,
//               page: const Login(),
//               type: AppNavigation.pushReplacement,
//             );
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text(S.of(context).logoutsuccess)),
//             );
//           } else if (state is LogoutFailure) {
//             ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//               content: Text("${S.of(context).logoutfailure}${(state.error)})"),
//             ));
//           }
//         },
//         builder: (context, state) {
//           final taskcubit = TasksCubit.get(context);
//           final themeCubit = ThemeCubit.get(context);
//           final localcubit = LocaleCubit.get(context);
//           final cubit = LogoutCubit.get(context);

//           if (state is AddTaskSuccessState) {
//             return Scaffold(
//               appBar: AppBar(
//                 leading: null,
//                 toolbarHeight: 80.h,
//                 title: BlocBuilder<HomeCubit, HomeState>(
//                   builder: (context, homeState) {
//                     if (homeState is HomeLoadingState) {
//                       return const Center(child: CircularProgressIndicator());
//                     } else if (homeState is HomeLoadedState) {
//                       final user = homeState.user;
//                       return Row(
//                         children: [
//                           Container(
//                             margin: const EdgeInsetsDirectional.only(end: 15),
//                             height: 50.h,
//                             width: 50.h,
//                             decoration: const BoxDecoration(
//                               shape: BoxShape.circle,
//                               image: DecorationImage(
//                                 image: NetworkImage(AppImages.plastine),
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           ),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text("${S.of(context).hello} 👋"),
//                                 Text(user.email,
//                                     style: TextStyle(fontSize: 16.sp)),
//                               ],
//                             ),
//                           ),
//                         ],
//                       );
//                     } else if (homeState is HomeErrorState) {
//                       return Text(homeState.message);
//                     }
//                     return const Text("Home");
//                   },
//                 ),
//                 actions: [
//                   TextButton(
//                     child: Text(
//                       localcubit.state.languageCode == 'en' ? 'AR' : 'EN',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 15.sp,
//                       ),
//                     ),
//                     onPressed: () {
//                       localcubit.toggleLocale();
//                     },
//                   ),
//                   BlocBuilder<ThemeCubit, ThemeMode>(
//                     builder: (context, state) {
//                       return IconButton(
//                         icon: Icon(
//                           state == ThemeMode.dark
//                               ? Icons.wb_sunny
//                               : Icons.nightlight_round,
//                           size: 15.sp,
//                         ),
//                         onPressed: () {
//                           themeCubit.toggleTheme();
//                         },
//                       );
//                     },
//                   ),
//                   IconButton(
//                     onPressed: () {
//                       cubit.logout();
//                     },
//                     icon: Icon(
//                       Icons.logout,
//                       size: 15.sp,
//                     ),
//                   )
//                 ],
//               ),
//               body: Center(
//                 child: SingleChildScrollView(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(S.of(context).not_task,
//                           style: TextStyle(
//                             fontSize: 15.sp,
//                             fontWeight: AppFonts.light,
//                           )),
//                       CustomSvg(
//                         assetName: AppIcons.tasks,
//                         width: 370.w,
//                         height: 270.w,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               floatingActionButton: FloatingActionButton(
//                 onPressed: () {
//                   AppNavigationType.navigate(context,
//                       page: const AddTaskScreen(), type: AppNavigation.push);
//                 },
//                 backgroundColor: AppColors.buttoncolor,
//                 child: Icon(
//                   Icons.add,
//                   size: 24.sp,
//                 ),
//               ),
//             );
//           } else {
//             return const Scaffold(
//               body: Text("data"),
//             );
//           }
//         },
//       ),
//     );
//   }
// }


// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_application_api_bloc/core/helper/navigation.dart';
// import 'package:flutter_application_api_bloc/core/widgets/custom_button.dart';
// import 'package:flutter_application_api_bloc/features/auth/view/login.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class Home extends StatefulWidget {
//   const Home({super.key});

//   @override
//   State<Home> createState() => _HomeState();
// }

// class _HomeState extends State<Home> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           const Text("home"),
//           CustomButton(
//               onPressed: () async {
                
//                 // Sign out the user
//                 final prefs = await SharedPreferences.getInstance();
//                 prefs.remove("login_success");
//                 //  await FirebaseAuth.instance.signOut();
//                   if (!mounted) return; // ✅ نتحقق أن الـ widget مازال موجود
//                 AppNavigationType.navigate(context,
//                     page: const Login(), type: AppNavigation.pushReplacement);
//               },
//               text: "signout")
//         ],
//       ),
//     );
//   }
// }
