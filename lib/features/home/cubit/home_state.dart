import 'package:flutter_application_api_bloc/core/models/user_model.dart';

abstract class HomeState {}

class HomeInitialState extends HomeState {}

class HomeLoadingState extends HomeState {}

class HomeLoadedState extends HomeState {
  final UserModel user;
  HomeLoadedState(this.user);
}

class HomeErrorState extends HomeState {
  final String message;
  HomeErrorState(this.message);
}
