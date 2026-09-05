import 'package:flutter/foundation.dart';

import '../core/network/api_client.dart';
import '../models/profile_model.dart';


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



  Future<ProfileModel> updateProfile(
      Map<String, dynamic> data,
      ) async {


    final response =
    await _apiClient.post(
      '/ProfileUpdate',
      data,
    );


    return ProfileModel.fromJson(
      response['data'],
    );

  }

}