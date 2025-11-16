import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:wheather_app/models/user_model.dart';
import 'package:wheather_app/services/storage_service.dart';

class AuthService {
  final StorageService _storageService = StorageService();

  // Get current user
  Future<UserModel?> get currentUser async {
    return await _storageService.getCurrentUser();
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    return await _storageService.isLoggedIn();
  }

  // Hash password (simple hash - in production use bcrypt or similar)
  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Sign up with email and password
  Future<UserModel> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      // Check if user already exists
      final existingUser = await _storageService.getUserByEmail(email);
      if (existingUser != null) {
        throw Exception('An account already exists for that email.');
      }

      // Create new user
      final userId = DateTime.now().millisecondsSinceEpoch.toString();
      final hashedPassword = _hashPassword(password);

      final user = UserModel(
        id: userId,
        name: name,
        email: email.toLowerCase().trim(),
        password: hashedPassword,
      );

      // Save user to storage
      await _storageService.saveUser(user);

      return user;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // Sign in with email and password
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      // Find user by email
      final user = await _storageService.getUserByEmail(email);
      if (user == null) {
        throw Exception('No user found for that email.');
      }

      // Verify password
      final hashedPassword = _hashPassword(password);
      if (user.password != hashedPassword) {
        throw Exception('Wrong password provided.');
      }

      // Set as current user and logged in
      await _storageService.setCurrentUser(user);
      await _storageService.setLoggedIn(true);

      return user;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _storageService.clearAll();
    } catch (e) {
      throw Exception('Error signing out: ${e.toString()}');
    }
  }

  // Get user info
  Future<UserModel?> getUserInfo() async {
    return await _storageService.getCurrentUser();
  }
}
