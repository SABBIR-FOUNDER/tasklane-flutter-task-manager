import '../models/login_response_model.dart';
import '../services/auth_service.dart';

class AuthRepository {
  final AuthService _authService =
  AuthService();

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