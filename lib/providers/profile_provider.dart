import 'package:flutter/material.dart';

import '../models/profile_model.dart';
import '../repositories/profile_repository.dart';

class ProfileProvider extends ChangeNotifier {

  final ProfileRepository _repository =
  ProfileRepository();


  ProfileModel? _profile;

  ProfileModel? get profile =>
      _profile;


  bool _isLoading = false;

  bool get isLoading =>
      _isLoading;


  Future<void> loadProfile() async {

    _isLoading = true;

    notifyListeners();


    try {

      _profile =
      await _repository.getProfile();


    } finally {

      _isLoading = false;

      notifyListeners();

    }
  }
}