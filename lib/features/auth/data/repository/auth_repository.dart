
import 'package:flutter_application_api_bloc/core/models/user_model.dart';

abstract class AuthRepository {
  Future<void> login({required UserModel user});
  Future<void> register({required UserModel user});
}
