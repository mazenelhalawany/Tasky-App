import 'package:flutter/material.dart';
import 'package:flutter_application_api_bloc/core/utils/colors.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notification Screen "),
        backgroundColor: AppColors.buttoncolor,
      ),
      body: const Center(child: Text("test"),),
    );
  }
}
