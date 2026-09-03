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


    return ProfileModel.fromJson(
      response['data'],
    );
  }
}