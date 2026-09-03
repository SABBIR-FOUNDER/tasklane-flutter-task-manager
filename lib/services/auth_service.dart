import '../core/network/api_client.dart';
import '../models/login_response_model.dart';
import '../models/register_response_model.dart';

class AuthService {
  final ApiClient _apiClient = ApiClient();

  Future<LoginResponseModel> login(
      String email,
      String password,
      ) async {
    final response = await _apiClient.post(
      '/login',
      {
        'email': email,
        'password': password,
      },
    );

    return LoginResponseModel.fromJson(response);
  }


  Future<RegisterResponseModel> register(
      Map<String, dynamic> data,
      ) async {
    final response = await _apiClient.post(
      '/Registration',
      data,
    );

    return RegisterResponseModel.fromJson(response);
  }
}