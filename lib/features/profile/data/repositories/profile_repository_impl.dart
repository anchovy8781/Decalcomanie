import 'dart:io';

import '../../../../common/models/result.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../sources/firestore_profile_source.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl(this._source);

  final FirestoreProfileSource _source;

  @override
  Future<Result<ProfileEntity>> getProfile(String uid) async {
    try {
      final profile = await _source.getProfile(uid);
      if (profile == null) return const Failure('프로필을 찾을 수 없습니다.');
      return Success(profile);
    } catch (e) {
      return Failure('프로필을 불러오는 중 오류가 발생했습니다.', e);
    }
  }

  @override
  Stream<ProfileEntity?> watchProfile(String uid) {
    return _source.watchProfile(uid);
  }

  @override
  Future<Result<void>> updateProfile({
    required String uid,
    String? nickname,
    String? bio,
  }) async {
    try {
      await _source.updateProfile(uid: uid, nickname: nickname, bio: bio);
      return const Success(null);
    } catch (e) {
      return Failure('프로필 수정 중 오류가 발생했습니다.', e);
    }
  }

  @override
  Future<Result<String>> uploadProfilePhoto({
    required String uid,
    required File imageFile,
  }) async {
    try {
      final url = await _source.uploadProfilePhoto(
        uid: uid,
        imageFile: imageFile,
      );
      return Success(url);
    } catch (e) {
      return Failure('사진 업로드 중 오류가 발생했습니다.', e);
    }
  }

  @override
  Future<Result<void>> deleteProfilePhoto(String uid) async {
    try {
      await _source.deleteProfilePhoto(uid);
      return const Success(null);
    } catch (e) {
      return Failure('사진 삭제 중 오류가 발생했습니다.', e);
    }
  }
}
