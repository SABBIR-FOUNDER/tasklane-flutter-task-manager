import 'user_model.dart';

class LoginResponseModel {
  final String status;
  final UserModel user;
  final String token;

  LoginResponseModel({
    required this.status,
    required this.user,
    required this.token,
  });

  factory LoginResponseModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return LoginResponseModel(
      status: json['status'],

      user: UserModel.fromJson(
        json['data'],
      ),

      token: json['token'],
    );
  }
}