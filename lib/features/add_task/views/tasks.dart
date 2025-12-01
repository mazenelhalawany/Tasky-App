import 'package:flutter/material.dart';
import 'package:flutter_application_api_bloc/core/helper/category.dart';
import 'package:flutter_application_api_bloc/core/helper/navigation.dart';
import 'package:flutter_application_api_bloc/core/services/firebase_auth_service.dart';
import 'package:flutter_application_api_bloc/core/utils/colors.dart';
import 'package:flutter_application_api_bloc/core/utils/pictures.dart';
import 'package:flutter_application_api_bloc/core/widgets/custom_cardtile.dart';
import 'package:flutter_application_api_bloc/features/add_task/cubit/tasks_cubit.dart';
import 'package:flutter_application_api_bloc/features/add_task/cubit/tasks_state.dart';
import 'package:flutter_application_api_bloc/features/add_task/data/model/task_model.dart';
import 'package:flutter_application_api_bloc/features/add_task/views/addtask.dart';
import 'package:flutter_application_api_bloc/features/home/views/home.dart';
import 'package:flutter_application_api_bloc/features/widgets/filterwidget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseAuthService authRepository = FirebaseAuthService();
    final cubit = TasksCubit.get(context);
    final String userId = authRepository.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            AppNavigationType.navigate(
              context,
              page: Home(userId: userId),
              type: AppNavigation.pushReplacement,
            );
            cubit.getTasks(userId);
          },
        ),
        title: const Text("Tasks"),
        centerTitle: true,
        elevation: 0,
      ),

      // 🔹 Floating Action Button for Filter
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                    left: 16.w,
                    right: 16.w,
                    top: 16.h,
                  ),
                  child: FilterWidgetWithCubit(userId: userId),
                ),
              );
            },
          );
        },
        child: const Icon(Icons.filter_alt),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔍 Search bar
            TextField(
              onChanged: (value) {
                if (value.isEmpty) {
                  cubit.getTasks(userId);
                } else {
                  cubit.searchTasks(userId, value);
                }
              },
              decoration: InputDecoration(
                hintText: "Search...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // 👇 عرض المهام حسب الحالة أو الفلترة
            Expanded(
              child: BlocBuilder<TasksCubit, TasksState>(
                builder: (context, state) {
                  if (state is GetTasksLoadingState ||
                      state is SearchTasksLoadingState) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  List<TaskModel> tasks = [];

                  if (state is GetTasksSuccessState) {
                    tasks = state.tasks;
                  } else if (state is SearchTasksSuccessState) {
                    tasks = state.tasks;
                  } else if (state is TasksFiltered) {
                    tasks = state.filteredTasks;
                  } else if (state is GetTasksErrorState ||
                      state is SearchTasksErrorState) {
                    return const Center(child: Text("Error loading tasks"));
                  }

                  if (tasks.isEmpty) {
                    return const Center(child: Text("No tasks found"));
                  }

                  return ListView.builder(
                    padding: EdgeInsets.all(12.w),
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      final status = TasksCubit.get(context)
                          .repository
                          .getTaskStatus(task);
                      return CustomCardTile(
                        status: status,
                        subtitle: task.description,
                        height: 100.h,
                        title: task.title,
                        imageUrl: AppImages.plastine,
                        icon: SvgPicture.asset(getCategoryIcon(task.group)),
                        color: AppColors.backgroundcolor,
                        progresscolor: AppColors.buttoncolor,
                        textColor: Colors.black,
                        onTap: () {
                          AppNavigationType.navigate(
                            context,
                            page: AddTaskScreen(task: task),
                            type: AppNavigation.push,
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:flutter_application_api_bloc/core/helper/category.dart';
// import 'package:flutter_application_api_bloc/core/helper/navigation.dart';
// import 'package:flutter_application_api_bloc/core/services/firebase_auth_service.dart';
// import 'package:flutter_application_api_bloc/core/utils/colors.dart';
// import 'package:flutter_application_api_bloc/core/utils/icons.dart';
// import 'package:flutter_application_api_bloc/core/utils/pictures.dart';
// import 'package:flutter_application_api_bloc/core/widgets/custom_cardtile.dart';
// import 'package:flutter_application_api_bloc/features/add_task/cubit/tasks_cubit.dart';
// import 'package:flutter_application_api_bloc/features/add_task/cubit/tasks_state.dart';
// import 'package:flutter_application_api_bloc/features/add_task/data/model/task_model.dart';
// import 'package:flutter_application_api_bloc/features/add_task/views/addtask.dart';
// import 'package:flutter_application_api_bloc/features/home/views/home.dart';
// import 'package:flutter_application_api_bloc/features/widgets/filterwidget.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';

// class TasksScreen extends StatelessWidget {
//   const TasksScreen({
//     super.key,
//   });
//   @override
//   Widget build(BuildContext context) {
//     FirebaseAuthService authRepository = FirebaseAuthService();

//     final cubit = TasksCubit.get(context);
//     final String userId =
//         authRepository.currentUser!.uid; // ⚠️ غيّرها بمعرّف المستخدم الحقيقي

//     return Scaffold(
//       appBar: AppBar(
//         leading: BackButton(
//           onPressed: () {
//             AppNavigationType.navigate(context,
//                 page: Home(userId: userId),
//                 type: AppNavigation.pushReplacement);
//             cubit.getTasks(userId);
//           },
//         ),
//         title: const Text("Tasks"),
//         centerTitle: true,
//         elevation: 0,
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           showModalBottomSheet(
//             context: context,
//             isScrollControlled: true,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
//             ),
//             builder: (context) => Padding(
//               padding: EdgeInsets.only(
//                 bottom: MediaQuery.of(context).viewInsets.bottom,
//                 left: 16.w,
//                 right: 16.w,
//                 top: 16.h,
//               ),
//               child: const SingleChildScrollView(
//                 child: FilterWidget(),
//               ),
//             ),
//           );
//         },
//         child: const Icon(Icons.list),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // 🔍 Search bar
//             TextField(
//               onChanged: (value) {
//                 if (value.isEmpty) {
//                   cubit.getTasks(userId);
//                 } else {
//                   cubit.searchTasks(userId, value);
//                 }
//               },
//               decoration: InputDecoration(
//                 hintText: "Search...",
//                 prefixIcon: const Icon(Icons.search),
//                 filled: true,
//                 fillColor: Colors.white,
//                 contentPadding:
//                     const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide(color: Colors.grey.shade300),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 12),

//             // 👇 عرض النتائج حسب الحالة
//             Expanded(
//               child: BlocBuilder<TasksCubit, TasksState>(
//                 builder: (context, state) {
//                   if (state is GetTasksLoadingState ||
//                       state is SearchTasksLoadingState) {
//                     return const Center(child: CircularProgressIndicator());
//                   }

//                   List<TaskModel> tasks = [];

//                   if (state is GetTasksSuccessState) {
//                     tasks = state.tasks;
//                   } else if (state is SearchTasksSuccessState) {
//                     tasks = state.tasks;
//                   } else if (state is GetTasksErrorState ||
//                       state is SearchTasksErrorState) {
//                     return const Center(child: Text("Error loading tasks"));
//                   }

//                   if (tasks.isEmpty) {
//                     return const Center(child: Text("No tasks found"));
//                   }

//                   return ListView.builder(
//                     padding: EdgeInsets.all(12.w),
//                     itemCount: tasks.length,
//                     itemBuilder: (context, index) {
//                       final task = tasks[index];
//                       final status = TasksCubit.get(context)
//                           .repository
//                           .getTaskStatus(task);
//                       return CustomCardTile(
//                           status: status,
//                           subtitle: task.description,
//                           height: 100.h,
//                           title: task.title,
//                           imageUrl: AppImages.plastine,
//                           icon: SvgPicture.asset(getCategoryIcon(task.group)),
//                           color: AppColors.backgroundcolor,
//                           progresscolor: AppColors.buttoncolor,
//                           textColor: Colors.black,
//                           onTap: () {
//                             AppNavigationType.navigate(
//                               context,
//                               page: AddTaskScreen(task: task),
//                               type: AppNavigation.push,
//                             );
//                           });
//                     },
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
