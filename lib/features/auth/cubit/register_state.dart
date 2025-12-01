abstract class RegisterState {}

class RegisterInitialState extends RegisterState {}

class RegisterLoadingState extends RegisterState {}

class RegisterChangePasswordVisibilityState extends RegisterState {}

class RegisterConfirmChangePasswordVisibilityState extends RegisterState {}

class RegisterSuccessState extends RegisterState {
   final String successMessage;
  RegisterSuccessState(this.successMessage);
}

class RegisterErrorState extends RegisterState {
  final String errorMessage;
  RegisterErrorState(this.errorMessage);
}
