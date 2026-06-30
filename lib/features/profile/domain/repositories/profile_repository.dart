import 'dart:io';
import '../../../../common/models/result.dart';
import '../entities/profile_entity.dart';

abstract interface class ProfileRepository {
  Future<Result<ProfileEntity>> getProfile(String uid);

  Stream<ProfileEntity?> watchProfile(String uid);

  Future<Result<void>> updateProfile({
    required String uid,
    String? nickname,
    String? bio,
  });

  Future<Result<String>> uploadProfilePhoto({
    required String uid,
    required File imageFile,
  });

  Future<Result<void>> deleteProfilePhoto(String uid);
}
