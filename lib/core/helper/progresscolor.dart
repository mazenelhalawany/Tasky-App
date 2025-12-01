import 'package:flutter/material.dart';

Color? getStatusColor(String? status) {
  if (status == null) return Colors.grey;
  switch (status) {
    case "Done":
      return Colors.green;
    case "In Progress":
      return Colors.blue[400]; // أو Colors.yellow.shade700
    case "Missed":
      return Colors.red;
    default:
      return Colors.white;
  }
}
