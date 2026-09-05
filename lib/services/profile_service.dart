import 'package:flutter/foundation.dart';

import '../core/network/api_client.dart';
import '../models/profile_model.dart';

class ProfileService {
  final ApiClient _apiClient = ApiClient();

  Future<Map<String, dynamic>> _getRawProfile() async {
    final response = await _apiClient.get(
      '/ProfileDetails',
      requiresAuth: true,
    );

    final data = response['data'];

    if (data is! List || data.isEmpty) {
      throw Exception('Profile data not found');
    }

    return Map<String, dynamic>.from(data.first);
  }

  Future<ProfileModel> getProfile() async {
    final profileData = await _getRawProfile();

    return ProfileModel.fromJson(profileData);
  }

  Future<ProfileModel> updateProfile(
    Map<String, dynamic> changes,
  ) async {
    debugPrint('PROFILE UPDATE: preparing current profile');

    final currentProfile = await _getRawProfile();

    final payload = <String, dynamic>{
      'email': changes['email'] ?? currentProfile['email'],
      'firstName':
          changes['firstName'] ?? currentProfile['firstName'],
      'lastName':
          changes['lastName'] ?? currentProfile['lastName'],
      'mobile': changes['mobile'] ?? currentProfile['mobile'],
      'password': currentProfile['password'],
    };

    debugPrint(
      'PROFILE UPDATE: POST /ProfileUpdate '
      '[authenticated, password not logged]',
    );

    final response = await _apiClient.post(
      '/ProfileUpdate',
      payload,
      requiresAuth: true,
    );

    final updateData = response['data'];

    if (updateData is Map) {
      debugPrint(
        'PROFILE UPDATE: matchedCount=${updateData['matchedCount']}, '
        'modifiedCount=${updateData['modifiedCount']}',
      );
    } else {
      debugPrint('PROFILE UPDATE: server accepted update');
    }

    debugPrint('PROFILE UPDATE: refreshing /ProfileDetails');

    final updatedProfile = await getProfile();

    debugPrint('PROFILE UPDATE: refresh complete');

    return updatedProfile;
  }
}
