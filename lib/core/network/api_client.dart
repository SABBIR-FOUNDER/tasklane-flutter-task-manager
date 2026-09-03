import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants/api_constants.dart';

import '../../services/storage_service.dart';




class ApiClient {
  Future<dynamic> post(
      String endpoint,
      Map<String, dynamic> body,
      ) async {
    final response = await http.post(
      Uri.parse(
        '${ApiConstants.baseUrl}$endpoint',
      ),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    return _handleResponse(response);
  }
  Future<dynamic> get(
      String endpoint,
      ) async {

    final String token =
        await StorageService.getToken() ?? '';

    final response =
    await http.get(
      Uri.parse(
        '${ApiConstants.baseUrl}$endpoint',
      ),
      headers: {
        'Content-Type': 'application/json',
        'token': token,
      },
    );

    return _handleResponse(response);
  }
  dynamic _handleResponse(
      http.Response response,
      ) {
    final data = jsonDecode(response.body);

    if (response.statusCode >= 200 &&
        response.statusCode < 300) {
      return data;
    }

    throw Exception(
      data['message'] ??
          'Something went wrong',
    );
  }
}