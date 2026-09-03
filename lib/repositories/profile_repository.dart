import '../models/profile_model.dart';
import '../services/profile_service.dart';

class ProfileRepository {

  final ProfileService _service =
  ProfileService();


  Future<ProfileModel> getProfile() {

    return _service.getProfile();

  }
}