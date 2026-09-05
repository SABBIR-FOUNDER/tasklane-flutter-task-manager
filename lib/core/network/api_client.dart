import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../services/storage_service.dart';
import '../constants/api_constants.dart';
import 'app_exception.dart';

class ApiClient {
  static const Duration _timeout = Duration(seconds: 20);

  Future<dynamic> get(
    String endpoint, {
    bool requiresAuth = true,
  }) async {
    try {
      final response = await http
          .get(
            Uri.parse('${ApiConstants.baseUrl}$endpoint'),
            headers: await _buildHeaders(requiresAuth),
          )
          .timeout(_timeout);

      return _handleResponse(response);
    } on AppException {
      rethrow;
    } on SocketException {
      throw AppException('No internet connection');
    } on TimeoutException {
      throw AppException('Request timed out. Please try again.');
    } on http.ClientException catch (e) {
      throw AppException(e.message);
    } catch (e) {
      throw AppException('Network request failed: $e');
    }
  }

  Future<dynamic> post(
    String endpoint,
    Map<String, dynamic> body, {
    bool requiresAuth = false,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('${ApiConstants.baseUrl}$endpoint'),
            headers: await _buildHeaders(requiresAuth),
            body: jsonEncode(body),
          )
          .timeout(_timeout);

      return _handleResponse(response);
    } on AppException {
      rethrow;
    } on SocketException {
      throw AppException('No internet connection');
    } on TimeoutException {
      throw AppException('Request timed out. Please try again.');
    } on http.ClientException catch (e) {
      throw AppException(e.message);
    } catch (e) {
      throw AppException('Network request failed: $e');
    }
  }

  Future<Map<String, String>> _buildHeaders(bool requiresAuth) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (requiresAuth) {
      final token = await StorageService.getToken();

      if (token == null || token.trim().isEmpty) {
        throw AppException(
          'Authentication token not found. Please login again.',
        );
      }

      headers['token'] = token.trim();
    }

    return headers;
  }

  dynamic _handleResponse(http.Response response) {
    dynamic body;

    try {
      body = response.body.trim().isEmpty
          ? <String, dynamic>{}
          : jsonDecode(response.body);
    } catch (_) {
      debugPrint(
        'API ERROR ${response.statusCode}: ${response.body}',
      );
      throw AppException(
        'Server returned an invalid response (${response.statusCode}).',
      );
    }

    final bool failedHttp =
        response.statusCode < 200 || response.statusCode >= 300;

    final String apiStatus = body is Map
        ? body['status']?.toString().toLowerCase() ?? ''
        : '';

    final bool failedApi = const [
      'fail',
      'failed',
      'error',
      'unauthorized',
    ].contains(apiStatus);

    if (failedHttp || failedApi) {
      debugPrint(
        'API ERROR ${response.statusCode}: ${response.body}',
      );

      if (response.statusCode == 401 || apiStatus == 'unauthorized') {
        throw AppException(
          'Your session is no longer valid. Please login again.',
        );
      }

      throw AppException(
        _extractErrorMessage(body, response.statusCode),
      );
    }

    return body;
  }

  String _extractErrorMessage(dynamic body, int statusCode) {
    if (body is Map) {
      for (final key in ['data', 'message', 'error']) {
        final value = body[key];

        if (value is String && value.trim().isNotEmpty) {
          return value.trim();
        }
      }
    }

    return 'Request failed with status $statusCode';
  }
}
