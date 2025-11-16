import 'package:flutter/material.dart';

abstract class SignUpEvent {}

class InitSignUpEvent extends SignUpEvent {
  BuildContext context;
  InitSignUpEvent({required this.context});
}

class SignUpSubmitEvent extends SignUpEvent {
  BuildContext context;
  String name;
  String email;
  String password;
  String confirmPassword;
  SignUpSubmitEvent({
    required this.context,
    required this.name,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });
}

class TogglePasswordVisibilityEvent extends SignUpEvent {}

class ToggleConfirmPasswordVisibilityEvent extends SignUpEvent {}
