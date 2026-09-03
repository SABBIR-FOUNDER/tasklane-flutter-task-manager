import 'package:flutter/material.dart';

import '../models/login_response_model.dart';
import '../repositories/auth_repository.dart';

import '../services/storage_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _repository =
  AuthRepository();

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  LoginResponseModel? _loginResponse;

  LoginResponseModel? get loginResponse =>
      _loginResponse;

  String? _errorMessage;

  String? get errorMessage =>
      _errorMessage;

  Future<bool> register(
      Map<String, dynamic> data,
      ) async {

    _isLoading = true;
    _errorMessage = null;

    notifyListeners();

    try {

      await _repository.register(
        data,
      );

      return true;

    }

    catch (e) {

      _errorMessage =
          e.toString();

      return false;

    } finally {

      _isLoading = false;

      notifyListeners();

    }
  }
  Future<bool> login(
      String email,
      String password,
      ) async {

    _isLoading = true;
    _errorMessage = null;

    notifyListeners();


    try {

      _loginResponse =
      await _repository.login(
        email,
        password,

      );

      await StorageService.saveToken(
        _loginResponse!.token,
      );
      return true;


    } catch (e) {

      _errorMessage =
          e.toString();

      return false;

    } finally {

      _isLoading = false;

      notifyListeners();

    }
  }
}