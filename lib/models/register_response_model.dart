import 'user_model.dart';

class RegisterResponseModel {
  final String status;
  final UserModel user;

  RegisterResponseModel({
    required this.status,
    required this.user,
  });

  factory RegisterResponseModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return RegisterResponseModel(
      status: json['status'],
      user: UserModel.fromJson(
        json['data'],
      ),
    );
  }
}