import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/user.dart';

class ApiService {
  final String baseUrl = "http://localhost:3001/api";
  final _storage = const FlutterSecureStorage();
  String? _currentUserId;

  Future<String?> get currentUserId async {
    _currentUserId ??= await _storage.read(key: 'userId');
    return _currentUserId;
  }

  Future<List<User>> fetchUsers() async {
    final token = await _storage.read(key: 'token');
    final uri = Uri.parse('$baseUrl/users');
    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      List<dynamic> userListJson = json.decode(response.body);
      return userListJson.map<User>((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users. Status code: ${response.statusCode}');
    }
  }


  Future<dynamic> fetchUserById(String userId) async {
    final uri = Uri.parse('$baseUrl/users/$userId');
    final response = await http.get(uri, headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print('Failed to fetch user by ID: ${response.body}');
      throw Exception('Failed to load user. Status code: ${response.statusCode}');
    }
  }

  Future<dynamic> createUser(Map<String, dynamic> userData) async {
    final uri = Uri.parse('$baseUrl/users');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(userData),
    );
    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      print('Failed to create user: ${response.body}');
      throw Exception('Failed to create user. Status code: ${response.statusCode}');
    }
  }

  Future<dynamic> updateUser(String userId, Map<String, dynamic> userData) async {
    final uri = Uri.parse('$baseUrl/users/$userId');
    final response = await http.put(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(userData),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print('Failed to update user: ${response.body}');
      throw Exception('Failed to update user. Status code: ${response.statusCode}');
    }
  }

  Future<void> deleteUser(String userId) async {
    final uri = Uri.parse('$baseUrl/users/$userId');
    final response = await http.delete(uri, headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      print('User deleted successfully');
    } else {
      print('Failed to delete user: ${response.body}');
      throw Exception('Failed to delete user. Status code: ${response.statusCode}');
    }
  }

  /// Authenticate user and store JWT token if successful.
  /// Authenticate user and store JWT token if successful.
  Future<bool> authenticateUser(String userId, String password) async {
    final uri = Uri.parse('$baseUrl/users/login');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user_id': userId,
        'password': password,
      }),
    );

    print('Login response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data != null && data['token'] != null) {
        await _storage.write(key: 'token', value: data['token']);

        if (data['name'] != null) {
          await _storage.write(key: 'name', value: data['name']);
        } else {
          await _storage.write(key: 'name', value: 'No Name');
        }

        if (data['userId'] != null) {
          await _storage.write(key: 'userId', value: data['userId'].toString());
          _currentUserId = data['userId'].toString(); // Cache the user ID
        } else {
          await _storage.write(key: 'userId', value: 'No UserId');
        }

        print('User details stored successfully');
        return true;
      } else {
        print('Login successful, but no token returned from the server.');
        return false;
      }
    } else {
      if (response.statusCode == 401) {
        print('Invalid credentials provided.');
      } else if (response.statusCode == 500) {
        print('Server error occurred.');
      }
      return false;
    }
  }






  Future<void> requestPasswordReset(String email) async {
    final uri = Uri.parse('$baseUrl/users/request-password-reset');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to request password reset.');
    }
  }


  /// Inside ApiService
  Future<String> generateAvatar(String description) async {
    final uri = Uri.parse('$baseUrl/avatars/generate');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'description': description}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // Assuming your backend sends back a JSON with the avatar URL in an 'avatar_url' field
      return data['avatar_url'];
    } else {
      print('Failed to generate avatar: ${response.body}');
      throw Exception('Failed to generate avatar. Status code: ${response.statusCode}');
    }
  }


  Future<void> saveAvatarForUser(String userId, String avatarUrl) async {
    final uri = Uri.parse('$baseUrl/users/$userId');
    final response = await http.patch(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'avatar_url': avatarUrl}),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update user avatar.');
    }
  }

  // Method to logout user
  Future<void> logoutUser() async {
    await _storage.delete(key: 'token');
  }


  // New method to add a model URL to a user's profile
  Future<void> addModelUrl(String userId, String modelUrl) async {
    final token = await _storage.read(key: 'token');
    final uri = Uri.parse('$baseUrl/users/$userId/models');
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'modelUrl': modelUrl}),
    );
    if (response.statusCode != 200) {
      print('Failed to add model URL: ${response.body}');
      throw Exception('Failed to add model URL. Status code: ${response.statusCode}');
    }
  }

  // New method to fetch all model URLs for a specific user
  Future<List<String>> getUserModels(String userId) async {
    final token = await _storage.read(key: 'token');
    final uri = Uri.parse('$baseUrl/users/$userId/models');
    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      List<dynamic> modelUrls = json.decode(response.body)['modelUrls'];
      return modelUrls.cast<String>();
    } else {
      print('Failed to fetch model URLs: ${response.body}');
      throw Exception('Failed to fetch model URLs. Status code: ${response.statusCode}');
    }
  }




}









