import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../common/models/result.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../data/sources/firestore_profile_source.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../../authentication/presentation/providers/auth_provider.dart';

// ─── Repository ───────────────────────────────────────────────────────────────

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepositoryImpl(ref.read(firestoreProfileSourceProvider));
});

// ─── Current user's profile stream ────────────────────────────────────────────

final currentProfileProvider = StreamProvider<ProfileEntity?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.when(
    data: (user) {
      if (user == null) return const Stream.empty();
      return ref.read(profileRepositoryProvider).watchProfile(user.uid);
    },
    loading: () => const Stream.empty(),
    error: (_, __) => const Stream.empty(),
  );
});

// ─── Profile notifier ─────────────────────────────────────────────────────────

class ProfileNotifier extends StateNotifier<AsyncValue<void>> {
  ProfileNotifier(this._repository) : super(const AsyncValue.data(null));

  final ProfileRepository _repository;

  Future<Result<void>> updateProfile({
    required String uid,
    String? nickname,
    String? bio,
  }) async {
    state = const AsyncValue.loading();
    final result = await _repository.updateProfile(
      uid: uid,
      nickname: nickname,
      bio: bio,
    );
    state = const AsyncValue.data(null);
    return result;
  }

  Future<Result<String>> uploadProfilePhoto({
    required String uid,
    required File imageFile,
  }) async {
    state = const AsyncValue.loading();
    final result = await _repository.uploadProfilePhoto(
      uid: uid,
      imageFile: imageFile,
    );
    state = const AsyncValue.data(null);
    return result;
  }

  Future<Result<void>> deleteProfilePhoto(String uid) async {
    state = const AsyncValue.loading();
    final result = await _repository.deleteProfilePhoto(uid);
    state = const AsyncValue.data(null);
    return result;
  }
}

final profileNotifierProvider =
    StateNotifierProvider<ProfileNotifier, AsyncValue<void>>((ref) {
  return ProfileNotifier(ref.read(profileRepositoryProvider));
});
