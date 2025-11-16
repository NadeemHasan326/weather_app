abstract class SignUpState {}

class InitSignUpState extends SignUpState {}

class SignUpLoadingState extends SignUpState {}

class SignUpSuccessState extends SignUpState {}

class SignUpFailureState extends SignUpState {
  String message;
  SignUpFailureState({required this.message});
}
