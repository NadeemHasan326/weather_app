import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wheather_app/blocs/sign_up_bloc/sign_up_event.dart';
import 'package:wheather_app/blocs/sign_up_bloc/sign_up_state.dart';
import 'package:wheather_app/services/auth_service.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final AuthService _authService = AuthService();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  SignUpBloc() : super(InitSignUpState()) {
    on<InitSignUpEvent>((event, emit) async {
      emit(InitSignUpState());
    });

    on<TogglePasswordVisibilityEvent>((event, emit) {
      obscurePassword = !obscurePassword;
      emit(InitSignUpState());
    });

    on<ToggleConfirmPasswordVisibilityEvent>((event, emit) {
      obscureConfirmPassword = !obscureConfirmPassword;
      emit(InitSignUpState());
    });

    on<SignUpSubmitEvent>((event, emit) async {
      emit(SignUpLoadingState());
      try {
        // Validate name
        if (event.name.isEmpty) {
          emit(SignUpFailureState(message: "Please enter your name"));
          return;
        }
        if (event.name.length < 3) {
          emit(
            SignUpFailureState(message: "Name must be at least 3 characters"),
          );
          return;
        }

        // Validate email
        if (event.email.isEmpty) {
          emit(SignUpFailureState(message: "Please enter your email"));
          return;
        }
        if (!event.email.contains('@')) {
          emit(SignUpFailureState(message: "Please enter a valid email"));
          return;
        }

        // Validate password
        if (event.password.isEmpty) {
          emit(SignUpFailureState(message: "Please enter your password"));
          return;
        }
        if (event.password.length < 6) {
          emit(
            SignUpFailureState(
              message: "Password must be at least 6 characters",
            ),
          );
          return;
        }

        // Validate confirm password
        if (event.confirmPassword.isEmpty) {
          emit(SignUpFailureState(message: "Please confirm your password"));
          return;
        }
        if (event.password != event.confirmPassword) {
          emit(SignUpFailureState(message: "Passwords do not match"));
          return;
        }

        // Sign up with shared preferences
        await _authService.signUp(
          email: event.email,
          password: event.password,
          name: event.name,
        );

        emit(SignUpSuccessState());
      } catch (e) {
        log("Sign Up Error: ${e.toString()}");
        emit(
          SignUpFailureState(
            message: e.toString().replaceFirst('Exception: ', ''),
          ),
        );
      }
    });
  }

  @override
  Future<void> close() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    return super.close();
  }
}
