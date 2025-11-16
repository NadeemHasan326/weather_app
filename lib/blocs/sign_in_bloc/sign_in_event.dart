import 'package:flutter/material.dart';

abstract class SignInEvent {}

class InitSignInEvent extends SignInEvent {
  BuildContext context;
  InitSignInEvent({required this.context});
}

class SignInSubmitEvent extends SignInEvent {
  BuildContext context;
  String email;
  String password;
  SignInSubmitEvent({
    required this.context,
    required this.email,
    required this.password,
  });
}

class TogglePasswordVisibilityEvent extends SignInEvent {}
