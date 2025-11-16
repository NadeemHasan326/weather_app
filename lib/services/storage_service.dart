import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wheather_app/models/user_model.dart';

class StorageService {
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyCurrentUser = 'current_user';
  static const String _keyUsers = 'users';

  // Get SharedPreferences instance
  Future<SharedPreferences> get _prefs async =>
      await SharedPreferences.getInstance();

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final prefs = await _prefs;
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  // Set login status
  Future<void> setLoggedIn(bool value) async {
    final prefs = await _prefs;
    await prefs.setBool(_keyIsLoggedIn, value);
  }

  // Get current user
  Future<UserModel?> getCurrentUser() async {
    final prefs = await _prefs;
    final userJson = prefs.getString(_keyCurrentUser);
    if (userJson == null) return null;
    try {
      final userMap = json.decode(userJson) as Map<String, dynamic>;
      return UserModel.fromJson(userMap);
    } catch (e) {
      return null;
    }
  }

  // Set current user
  Future<void> setCurrentUser(UserModel? user) async {
    final prefs = await _prefs;
    if (user == null) {
      await prefs.remove(_keyCurrentUser);
    } else {
      await prefs.setString(_keyCurrentUser, json.encode(user.toJson()));
    }
  }

  // Get all users (for checking if email exists)
  Future<List<UserModel>> getAllUsers() async {
    final prefs = await _prefs;
    final usersJson = prefs.getString(_keyUsers);
    if (usersJson == null) return [];
    try {
      final List<dynamic> usersList = json.decode(usersJson) as List<dynamic>;
      return usersList
          .map((userMap) => UserModel.fromJson(userMap as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Save a user to the users list
  Future<void> saveUser(UserModel user) async {
    final users = await getAllUsers();

    // Check if user with this email already exists
    final existingUserIndex = users.indexWhere((u) => u.email == user.email);

    if (existingUserIndex != -1) {
      // Update existing user
      users[existingUserIndex] = user;
    } else {
      // Add new user
      users.add(user);
    }

    final prefs = await _prefs;
    final usersJson = json.encode(users.map((u) => u.toJson()).toList());
    await prefs.setString(_keyUsers, usersJson);
  }

  // Find user by email
  Future<UserModel?> getUserByEmail(String email) async {
    final users = await getAllUsers();
    try {
      return users.firstWhere(
        (user) => user.email.toLowerCase() == email.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }

  // Clear all data (logout)
  Future<void> clearAll() async {
    final prefs = await _prefs;
    await prefs.remove(_keyCurrentUser);
    await prefs.setBool(_keyIsLoggedIn, false);
  }
}
