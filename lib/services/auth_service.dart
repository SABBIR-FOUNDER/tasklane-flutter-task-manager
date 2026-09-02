import 'package:flutter/foundation.dart';

import '../core/network/api_client.dart';
import '../models/login_response_model.dart';

class AuthService {
  final ApiClient _apiClient = ApiClient();

  Future<LoginResponseModel> login(
      String email,
      String password,
      ) async {
    final response = await _apiClient.post(
      '/login',
      {
        'email': email,
        'password': password,
      },
    );

    debugPrint(response.toString());

    return LoginResponseModel.fromJson(
      response,
    );
  }
}