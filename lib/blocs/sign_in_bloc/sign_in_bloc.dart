import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wheather_app/blocs/sign_in_bloc/sign_in_event.dart';
import 'package:wheather_app/blocs/sign_in_bloc/sign_in_state.dart';
import 'package:wheather_app/services/auth_service.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final AuthService _authService = AuthService();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool obscurePassword = true;

  SignInBloc() : super(InitSignInState()) {
    on<InitSignInEvent>((event, emit) async {
      emit(InitSignInState());
    });

    on<TogglePasswordVisibilityEvent>((event, emit) {
      obscurePassword = !obscurePassword;
      emit(InitSignInState());
    });

    on<SignInSubmitEvent>((event, emit) async {
      emit(SignInLoadingState());
      try {
        // Validate email
        if (event.email.isEmpty) {
          emit(SignInFailureState(message: "Please enter your email"));
          return;
        }
        if (!event.email.contains('@')) {
          emit(SignInFailureState(message: "Please enter a valid email"));
          return;
        }

        // Validate password
        if (event.password.isEmpty) {
          emit(SignInFailureState(message: "Please enter your password"));
          return;
        }
        if (event.password.length < 6) {
          emit(
            SignInFailureState(
              message: "Password must be at least 6 characters",
            ),
          );
          return;
        }

        // Sign in with shared preferences
        await _authService.signIn(email: event.email, password: event.password);

        emit(SignInSuccessState());
      } catch (e) {
        log("Sign In Error: ${e.toString()}");
        emit(
          SignInFailureState(
            message: e.toString().replaceFirst('Exception: ', ''),
          ),
        );
      }
    });
  }

  @override
  Future<void> close() {
    emailController.dispose();
    passwordController.dispose();
    return super.close();
  }
}
