class ApiConstants {
  ApiConstants._();

  static const String baseUrl =
      'https://task-manager-api.ostad.live/api/v1';

  static const String login = '/login';
  static const String register = '/Registration';
  static const String profileDetails = '/ProfileDetails';
  static const String profileUpdate = '/ProfileUpdate';

  static const String createTask = '/createTask';
  static const String taskStatusCount = '/taskStatusCount';

  static const String recoverResetPassword = '/RecoverResetPassword';

  static String recoverVerifyEmail(String email) {
    return '/RecoverVerifyEmail/${Uri.encodeComponent(email)}';
  }

  static String recoverVerifyOtp(String email, String otp) {
    return '/RecoverVerifyOtp/'
        '${Uri.encodeComponent(email)}/'
        '${Uri.encodeComponent(otp)}';
  }

  static String listTaskByStatus(String status) {
    return '/listTaskByStatus/${Uri.encodeComponent(status)}';
  }

  static String updateTaskStatus(String taskId, String status) {
    return '/updateTaskStatus/'
        '${Uri.encodeComponent(taskId)}/'
        '${Uri.encodeComponent(status)}';
  }

  static String deleteTask(String taskId) {
    return '/deleteTask/${Uri.encodeComponent(taskId)}';
  }
}
