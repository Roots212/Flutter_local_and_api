import 'dart:convert';

import 'package:electrum_task/Modal/api_userModal.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class UserRepository {
  final baseUrl = 'reqres.in';
  final client = http.Client();

  Future<ApiUser?> getUsers(int index) async {
    final queryParameters = {'page': index.toString()};

    final uri = Uri.https(baseUrl, '/api/users', queryParameters);

    try {
      final resposne = await client.get(uri);
      print(resposne.body);
      final json = jsonDecode(resposne.body);
      return ApiUser.fromJson(json);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }

  Future<bool> addUser(String email, String firstName, String lastName) async {
    final uri = Uri.https(baseUrl, '/api/users');

    try {
      final resposne = await client.post(uri, body: {
        'first_name': firstName,
        'last_name': lastName,
        'email': email
      });
      print(resposne.statusCode);
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  Future<bool> updateUser(
      String email, String firstName, String lastName, String id) async {
    final uri = Uri.https(baseUrl, '/api/users/$id');

    try {
      final resposne = await client.patch(uri, body: {
        'first_name': firstName,
        'last_name': lastName,
        'email': email
      });
      print(resposne.statusCode);
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }
    Future<bool> deleteUser(
     String id) async {
    final uri = Uri.https(baseUrl, '/api/users/$id');

    try {
      final resposne = await client.delete(uri);
      print(resposne.statusCode);
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }
}
