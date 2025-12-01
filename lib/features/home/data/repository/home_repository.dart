import 'package:flutter_application_api_bloc/core/models/user_model.dart';

abstract class HomeRepository {
  Future<UserModel> getUserData(String userId);
}
