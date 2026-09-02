import '../core/network/api_client.dart';


class AuthService {
  final ApiClient _apiClient =
  ApiClient();

  Future<dynamic> login(
      String email,
      String password,
      ) async {

    return await _apiClient.post(
      '/login',
      {

        'email':email,
        'password':password,
      },
    );
  }
}