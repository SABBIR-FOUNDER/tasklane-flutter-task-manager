import '../models/login_response_model.dart';
import '../services/auth_service.dart';
import '../models/register_response_model.dart';


class AuthRepository {
  final AuthService _authService =
  AuthService();

  Future<RegisterResponseModel> register(
      Map<String, dynamic> data,
      ) {
    return _authService.register(
      data,
    );
  }

  Future<LoginResponseModel> login(
      String email,
      String password,
      ) {
    return _authService.login(
      email,
      password,
    );
  }
}