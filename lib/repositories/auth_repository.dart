import '../services/auth_service.dart';

class AuthRepository {
  final AuthService _authService =
  AuthService();

  Future<dynamic> login(
      String email,
      String password,
      ) {

    return _authService.login(
      email,
      password,
    );
  }
}