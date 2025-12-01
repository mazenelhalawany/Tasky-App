import 'package:flutter_application_api_bloc/core/models/user_model.dart';
import 'package:flutter_application_api_bloc/core/services/firebase_firestore_service.dart';

import 'home_repository.dart';

class HomeRepositoryImplement implements HomeRepository {
  final FirebaseHomeService firebaseHomeService;

  HomeRepositoryImplement({required this.firebaseHomeService});

  @override
  Future<UserModel> getUserData(String userId) {
    return firebaseHomeService.getUserData(userId);
  }
}
