import 'package:flutter/material.dart';
import 'package:flutter_application_api_bloc/features/add_task/cubit/tasks_cubit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FilterWidgetWithCubit extends StatefulWidget {
  final String userId;
  const FilterWidgetWithCubit({super.key, required this.userId});

  @override
  State<FilterWidgetWithCubit> createState() => _FilterWidgetWithCubitState();
}

class _FilterWidgetWithCubitState extends State<FilterWidgetWithCubit> {
  final List<String> categories = ["All", "Work", "Home", "Personal"];
  final List<String> statuses = ["All", "In Progress", "Missed", "Done"];
  String selectedCategory = "All";
  String selectedStatus = "All";

  @override
  Widget build(BuildContext context) {
    final cubit = TasksCubit.get(context);

    return Column(
        mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 🔹 Category filter
        Wrap(
          spacing: 10.w,
          runSpacing: 10.h,
          children: categories.map((category) {
            final isSelected = selectedCategory == category;
            return ChoiceChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (_) {
                setState(() => selectedCategory = category);
              },
              selectedColor: Colors.green,
              backgroundColor: Colors.white,
              labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Colors.black),
            );
          }).toList(),
        ),
        const SizedBox(height: 15),

        // 🔹 Status filter
        Wrap(
          spacing: 10.w,
          runSpacing: 10.h,
          children: statuses.map((status) {
            final isSelected = selectedStatus == status;
            return ChoiceChip(
              label: Text(status),
              selected: isSelected,
              onSelected: (_) {
                setState(() => selectedStatus = status);
              },
              selectedColor: Colors.green,
              backgroundColor: Colors.white,
              labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Colors.black),
            );
          }).toList(),
        ),
        const SizedBox(height: 15),

        

        // 🔹 Apply filter button
        SizedBox(
          width: double.infinity,
          height: 50.h,
          child: ElevatedButton(
            onPressed: () {
              cubit.filterTasks(
                userId: widget.userId,
                category: selectedCategory,
                status: selectedStatus,
              );
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.r),
              ),
            ),
            child: const Text(
              "Apply Filter",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),

          ),

        ),
        SizedBox(height: 15.h), 
      ],
    );
  }
}