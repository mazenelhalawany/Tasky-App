import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_api_bloc/core/services/firebase_auth_service.dart';
import 'package:flutter_application_api_bloc/core/services/local_notification.dart';
import 'package:flutter_application_api_bloc/core/utils/colors.dart';
import 'package:flutter_application_api_bloc/core/utils/fonts.dart';
import 'package:flutter_application_api_bloc/core/utils/pictures.dart';
import 'package:flutter_application_api_bloc/core/widgets/custom_button.dart';
import 'package:flutter_application_api_bloc/core/widgets/custom_textfeild.dart';
import 'package:flutter_application_api_bloc/features/add_task/cubit/tasks_cubit.dart';
import 'package:flutter_application_api_bloc/features/add_task/cubit/tasks_state.dart';
import 'package:flutter_application_api_bloc/features/add_task/data/model/task_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class AddTaskScreen extends StatelessWidget {
  final TaskModel? task; // ✅ لو فيه مهمة معناها تعديل، لو null معناها إضافة

  AddTaskScreen({super.key, this.task});

  final FirebaseAuthService authRepository = FirebaseAuthService();

  @override
  Widget build(BuildContext context) {
    final cubit = TasksCubit.get(context);

    // ✅ لو الصفحة مفتوحة في وضع تعديل
    if (task != null) {
      cubit.titleController.text = task!.title;
      cubit.descriptionController.text = task!.description;
      cubit.selectedGroup = task!.group;
      cubit.selectedDateTime = task!.deadLine;
    }

    return BlocConsumer<TasksCubit, TasksState>(
      listener: (context, state) {
        if (state is AddTaskSuccessState || state is EditTaskSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(task == null
                  ? 'Task added successfully!'
                  : 'Task updated successfully!'),
            ),
          );
          Navigator.pop(context);
        }

        if (state is AddTaskErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
        if (state is DeleteTaskSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Task deleted successfully ✅")),
          );
          Navigator.pop(context);
        }

        if (state is DeleteTaskErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error: ${state.message}")),
          );
        }

        if (state is EditTaskErrorState) {
          log(state.editmessage);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.editmessage)),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            actions: task == null
                ? []
                : [
                    BlocBuilder<TasksCubit, TasksState>(
                        builder: (context, state) {
                      final cubit = TasksCubit.get(context);

                      // لو الحالة loading نعرض مؤشر التحميل
                      if (state is DeleteTaskLoadingState) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Colors.red,
                            strokeWidth: 4,
                            backgroundColor: Colors.white,
                            strokeCap: StrokeCap.round,
                          ),
                        );
                      }

                      // غير كده نعرض القائمة عادي
                      return InkWell(
                        onTap: () async {
                          await cubit.deleteTask(
                              authRepository.currentUser!.uid, task!.taskid);
                        },
                        child: Container(
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            width: 70,
                            height: 18,
                            child: const Center(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                  size: 15,
                                ),
                                Text(
                                  "Delete",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: AppFonts.semiBold,
                                      fontSize: 10),
                                ),
                              ],
                            ))),
                      );
                    }),
                  ],
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              task == null ? "Add Task" : "Edit Task", // ✅ تغيير العنوان
              style: TextStyle(
                color: Colors.black,
                fontWeight: AppFonts.light,
                fontSize: 19.sp,
              ),
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// 🖼️ صورة
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    AppImages.plastine,
                    height: 207.w,
                    width: 259.w,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 20),

                /// 📝 Title
                CustomTextField(
                  controller: cubit.titleController,
                  hintText: 'Title',
                  prefixIcon: null,
                  suffixIcon: null,
                  obscureText: false,
                ),
                const SizedBox(height: 15),

                /// 📝 Description
                CustomTextField(
                  controller: cubit.descriptionController,
                  hintText: 'Description',
                  obscureText: false,
                  prefixIcon: null,
                  suffixIcon: null,
                ),
                const SizedBox(height: 15),

                /// 📂 Group Dropdown
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 22.w),
                  child: DropdownButtonFormField<String>(
                    value: cubit.selectedGroup,
                    items: ["Work", "Personal", "Home"]
                        .map((group) => DropdownMenuItem(
                              value: group,
                              child: Text(group),
                            ))
                        .toList(),
                    onChanged: (value) => cubit.selectGroup(value),
                    decoration: InputDecoration(
                      hintText: "Group",
                      hintStyle: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.lighttextcolor,
                        fontWeight: AppFonts.light,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.r),
                        borderSide:
                            const BorderSide(color: AppColors.textfieldcolor),
                      ),
                      focusedBorder:
                          customBorder(customcolor: AppColors.textfieldcolor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.r),
                        borderSide:
                            const BorderSide(color: AppColors.textfieldcolor),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                /// 📅 Date & Time Picker
                CustomTextField(
                  ontap: () => cubit.pickDateTime(context),
                  readonly: true,
                  hintText: cubit.selectedDateTime == null
                      ? "Select Date & Time"
                      : DateFormat('dd/MM/yyyy hh:mm a')
                          .format(cubit.selectedDateTime!),
                  controller: null,
                  prefixIcon: const Icon(Icons.access_time),
                  suffixIcon: null,
                  obscureText: false,
                ),
                const SizedBox(height: 25),

                /// 📝 Title
                task != null
                    ? CustomButton(
                        text: "Mark as Done",
                        onPressed: () async {
                          await cubit.editTask(
                            authRepository.currentUser!.uid,
                            task!.copyWith(isDone: true),
                          );
                        },
                      )
                    : const SizedBox(),

                /// 🟩 Add or Edit Button
                CustomButton(
                  onPressed: () async {
                    if (authRepository.currentUser == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('You must be logged in')),
                      );
                      return;
                    }

                    if (cubit.selectedDateTime == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please choose a date')),
                      );
                      return;
                    }

                    final userId = authRepository.currentUser!.uid;

                    if (task == null) {
                      /// ➕ إضافة جديدة
                      await cubit.addTask(userId,context);
                      LocalNotificationService.showSchduledNotification();

                    } else {
                      /// ✏️ تعديل المهمة
                      final updatedTask = TaskModel(
                        id: task!.id,
                        taskid: task!
                            .taskid, // ⚡ مهم جدًا، دا الـ doc.id اللي موجود في Firestore
                        title: cubit.titleController.text,
                        description: cubit.descriptionController.text,
                        group: cubit.selectedGroup!,
                        deadLine: cubit.selectedDateTime!,
                      );

                      await cubit.editTask(userId, updatedTask);
                    }
                  },
                  text: task == null ? "Add Task" : "Edit Task", // ✅ اسم الزر
                  textcolor: task == null
                      ? AppColors.backgroundcolor
                      : AppColors.buttoncolor,
                  buttoncolor: task == null
                      ? AppColors.buttoncolor
                      : AppColors.backgroundcolor,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}








// import 'package:flutter/material.dart';
// import 'package:flutter_application_api_bloc/core/services/firebase_auth_service.dart';
// import 'package:flutter_application_api_bloc/core/utils/colors.dart';
// import 'package:flutter_application_api_bloc/core/utils/fonts.dart';
// import 'package:flutter_application_api_bloc/core/utils/pictures.dart';
// import 'package:flutter_application_api_bloc/core/widgets/custom_button.dart';
// import 'package:flutter_application_api_bloc/core/widgets/custom_textfeild.dart';
// import 'package:flutter_application_api_bloc/features/add_task/cubit/tasks_cubit.dart';
// import 'package:flutter_application_api_bloc/features/add_task/cubit/tasks_state.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:intl/intl.dart';

// class AddTaskScreen extends StatelessWidget {
//    AddTaskScreen({super.key});

//   DateTime? selectedDate;

//   FirebaseAuthService authRepository = FirebaseAuthService();

//   @override
//   Widget build(BuildContext context) {
//     final cubit = TasksCubit.get(context);

//     return BlocConsumer<TasksCubit, TasksState>(listener: (context, state) {
//       if (state is AddTaskSuccessState) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Task added successfully!')),
//         );
//          Navigator.pop(context); // يرجع للشاشة السابقة بعد الإضافة
//       }

//       if (state is AddTaskErrorState) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(state.message)),
//         );
//       }
//     }, builder: (context, state) {
//       DateTime? selectedDate;
//       if (state is TaskDatePickedState) {
//         selectedDate = state.date;
//       }
//       if (state is TaskGroupSelectedState) {
//         cubit.selectedGroup = state.group;
//       }

//       return Scaffold(
//         // backgroundColor: const Color(0xFFF5F5F5),
//         appBar: AppBar(
//           elevation: 0,
//           backgroundColor: Colors.transparent,
//           leading: IconButton(
//             icon: const Icon(Icons.arrow_back, color: Colors.black),
//             onPressed: () => Navigator.pop(context),
//           ),
//           title: Text(
//             "Add Task",
//             style: TextStyle(
//               color: Colors.black,
//               fontWeight: AppFonts.light,
//               fontSize: 19.sp,
//             ),
//           ),
//           centerTitle: true,
//         ),
//         body: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(vertical: 10),
//           child:
//               Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
//             /// 🖼️ Image
//             ClipRRect(
//               borderRadius: BorderRadius.circular(15),
//               child: Image.asset(
//                 AppImages.plastine, // ضع مسار الصورة هنا
//                 height: 207.w,
//                 width: 259.w,
//                 fit: BoxFit.cover,
//               ),
//             ),
//             const SizedBox(height: 20),

//             /// 📝 Title Field
//             CustomTextField(
//               controller: cubit.titleController,
//               hintText: 'title',
//               prefixIcon: null,
//               suffixIcon: null,
//               obscureText: false,
//             ),

//             const SizedBox(height: 15),

//             /// 📝 Description Field
//             CustomTextField(
//               controller: cubit.descriptionController,
//               hintText: 'Description',
//               obscureText: false,
//               prefixIcon: null,
//               suffixIcon: null,
//             ),
//             const SizedBox(height: 15),

//             /// 📂 Group Dropdown
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 22.w),
//               child: DropdownButtonFormField<String>(
//                 value: cubit.selectedGroup,
//                 items: ["Work", "Personal", "Study"]
//                     .map((group) => DropdownMenuItem(
//                           value: group,
//                           child: Text(group),
//                         ))
//                     .toList(),
//                 onChanged: (value) => cubit.selectGroup(value),
//                 decoration: InputDecoration(
//                   hintText: "Group",
//                   hintStyle: TextStyle(
//                       fontSize: 14.sp,
//                       color: AppColors.lighttextcolor,
//                       fontWeight: AppFonts.light),
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(15.r),
//                     borderSide:
//                         const BorderSide(color: AppColors.textfieldcolor),
//                   ),
//                   focusedBorder:
//                       customBorder(customcolor: AppColors.textfieldcolor),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(15.r),
//                     borderSide:
//                         const BorderSide(color: AppColors.textfieldcolor),
//                   ),
//                   filled: true,
//                   fillColor: Colors.white,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 15),

//             /// 📅 End Time Picker

//             CustomTextField(
//               ontap: () => cubit.pickDateTime(context),
//               readonly: true,
//               hintText: cubit.selectedDateTime == null
//                   ? "Select Date & Time"
//                   : DateFormat('dd/MM/yyyy hh:mm a')
//                       .format(cubit.selectedDateTime!),
//               controller: null,
//               prefixIcon: const Icon(Icons.access_time),
//               suffixIcon: null,
//               obscureText: false,
//             ),
//             const SizedBox(height: 25),

//             /// 🟩 Add Task Button
//             CustomButton(
//               onPressed: () async {
//                 if (authRepository.currentUser == null) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text('You must be logged in')),
//                   );
//                   return;
//                 }

//                 if (cubit.selectedDateTime == null) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text('Please choose a date')),
//                   );
//                   return;
//                 }

//                 await cubit.addTask(authRepository.currentUser!.uid);
//                 // if (context.mounted) {
//                   // Navigator.pop(context);
//                 // }
//               },
//               text: "Add Task",
//             ),
//           ]),
//         ),
//       );
//     });
//   }
// }
