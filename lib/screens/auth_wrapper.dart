import 'package:flutter/material.dart';
import 'package:wheather_app/screens/home_screen.dart';
import 'package:wheather_app/screens/sign_in_screen.dart';
import 'package:wheather_app/services/auth_service.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  final AuthService _authService = AuthService();
  bool _isLoading = true;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final isLoggedIn = await _authService.isLoggedIn();
    if (mounted) {
      setState(() {
        _isLoggedIn = isLoggedIn;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show loading while checking auth state
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // If user is logged in, show home screen
    if (_isLoggedIn) {
      return const HomeScreen();
    }

    // If user is not logged in, show sign in screen
    return const SignInScreen();
  }
}
