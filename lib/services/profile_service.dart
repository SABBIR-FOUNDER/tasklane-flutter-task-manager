import '../core/network/api_client.dart';
import '../models/profile_model.dart';
import 'package:flutter/foundation.dart';

class ProfileService {

  final ApiClient _apiClient =
  ApiClient();


  Future<ProfileModel> getProfile() async {

    final response =
    await _apiClient.get(
      '/ProfileDetails',
    );


    debugPrint(
      response.toString(),
    );


    return ProfileModel.fromJson(
      response['data'][0],
    );

  }

}