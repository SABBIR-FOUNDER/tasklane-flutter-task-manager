import 'package:flutter/material.dart';

import '../models/profile_model.dart';
import '../repositories/profile_repository.dart';

class ProfileProvider extends ChangeNotifier {
  final ProfileRepository _repository =
      ProfileRepository();

  ProfileModel? _profile;
  ProfileModel? get profile => _profile;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isUpdating = false;
  bool get isUpdating => _isUpdating;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> loadProfile() async {
    _isLoading = true;
    _errorMessage = null;

    notifyListeners();

    try {
      _profile =
          await _repository.getProfile();
    } catch (e) {
      _errorMessage = _cleanError(e);

      debugPrint(
        'LOAD PROFILE ERROR: $e',
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateProfile(
    Map<String, dynamic> data,
  ) async {
    _isUpdating = true;
    _errorMessage = null;

    notifyListeners();

    try {
      _profile =
          await _repository.updateProfile(
        data,
      );

      return true;
    } catch (e) {
      _errorMessage = _cleanError(e);

      debugPrint(
        'UPDATE PROFILE ERROR: $e',
      );

      return false;
    } finally {
      _isUpdating = false;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  String _cleanError(
    Object error,
  ) {
    final message = error.toString();

    if (message.startsWith('Exception: ')) {
      return message.substring(
        'Exception: '.length,
      );
    }

    return message;
  }
}
