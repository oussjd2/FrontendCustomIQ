import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/user.dart';

class UserController with ChangeNotifier {
  final ApiService _apiService;
  List<User> _users = [];
  bool _isLoading = false;

  UserController({required ApiService apiService}) : _apiService = apiService;

  List<User> get users => _users;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /*Future<void> fetchUsers() async {
    isLoading = true;
    try {
      final response = await _apiService.fetchUsers();
      _users = response.map<User>((json) => User.fromJson(json)).toList();
    } catch (e) {
      print(e.toString());
    } finally {
      isLoading = false;
    }
  }*/

  Future<void> fetchUsers() async {
    isLoading = true;
    print('Fetching users from ${_apiService.baseUrl}/users');
    try {
      final response = await _apiService.fetchUsers();
      print('Fetch users successful: ${response}');
      // Ensure you're casting each JSON object to Map<String, dynamic> before passing it to User.fromJson
      _users = response.map<User>((json) => User.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      print('Error fetching users: $e');
      // Handle any specific errors here if necessary
    } finally {
      isLoading = false;
      notifyListeners(); // This ensures listeners are notified in case of error as well
    }
  }



  Future<void> createUser(User user) async {
    isLoading = true;
    try {
      await _apiService.createUser(user.toJson()); // Ensure this method exists and is correct
      fetchUsers(); // Refresh the list after adding a user
    } catch (e) {
      print(e.toString());
    } finally {
      isLoading = false;
    }
  }

  Future<void> updateUser(String id, User user) async {
    isLoading = true;
    try {
      await _apiService.updateUser(id, user.toJson()); // Ensure this method exists and is correct
      fetchUsers(); // Refresh the list after updating a user
    } catch (e) {
      print(e.toString());
    } finally {
      isLoading = false;
    }
  }

  Future<void> deleteUser(String id) async {
    isLoading = true;
    try {
      await _apiService.deleteUser(id); // Ensure this method exists and is correct
      fetchUsers(); // Refresh the list after deleting a user
    } catch (e) {
      print(e.toString());
    } finally {
      isLoading = false;
    }
  }

// Add a model URL to a user's profile
  Future<void> addModelUrl(String userId, String modelUrl) async {
    isLoading = true;
    try {
      await _apiService.addModelUrl(userId, modelUrl);
      await fetchUsers();
    } catch (e) {
      print('Error adding model URL: $e');
    } finally {
      isLoading = false;
    }
  }

  // Fetch all model URLs for a specific user
  Future<List<String>> getUserModels(String userId) async {
    try {
      return await _apiService.getUserModels(userId);
    } catch (e) {
      print('Error fetching user models: $e');
      return [];
    }
  }
}



