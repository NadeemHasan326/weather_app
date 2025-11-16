abstract class SignInState {}

class InitSignInState extends SignInState {}

class SignInLoadingState extends SignInState {}

class SignInSuccessState extends SignInState {}

class SignInFailureState extends SignInState {
  String message;
  SignInFailureState({required this.message});
}
