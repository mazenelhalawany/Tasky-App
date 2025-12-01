import 'package:flutter_application_api_bloc/core/utils/icons.dart';

String getCategoryIcon(String category) {
  switch (category) {
    case 'Home':
      return AppIcons.home;
    case 'Work':
      return AppIcons.work;
    case 'Personal':
      return AppIcons.personal;
    default:
      return AppIcons.home;
  }
}
