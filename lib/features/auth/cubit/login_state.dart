abstract class LoginState {}

class LoginInitialState extends LoginState {}

class LoginLoadingState extends LoginState {}

class LoginChangePasswordVisibilityState extends LoginState {}
class LoginSuccessState extends LoginState {
  final String successMessage;
  LoginSuccessState(this.successMessage);         
}

class LoginErrorState extends LoginState {
  final String errorMessage;
  LoginErrorState(this.errorMessage);
}
