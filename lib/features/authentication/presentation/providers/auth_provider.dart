import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../common/models/result.dart';
import '../../../../common/services/analytics_service.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/sources/firebase_auth_source.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../profile/data/sources/firestore_profile_source.dart';

// ─── Infrastructure providers ─────────────────────────────────────────────────

final _firebaseAuthProvider = Provider<FirebaseAuth>(
  (_) => FirebaseAuth.instance,
);

final _googleSignInProvider = Provider<GoogleSignIn>(
  (_) => GoogleSignIn(),
);

final _analyticsServiceProvider = Provider<AnalyticsService>(
  (_) => AnalyticsService(FirebaseAnalytics.instance),
);

final _firebaseAuthSourceProvider = Provider<FirebaseAuthSource>((ref) {
  return FirebaseAuthSource(
    ref.read(_firebaseAuthProvider),
    ref.read(_googleSignInProvider),
  );
});

// ─── Repository ───────────────────────────────────────────────────────────────

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    ref.read(_firebaseAuthSourceProvider),
    ref.read(firestoreProfileSourceProvider),
  );
});

// ─── Auth state stream ────────────────────────────────────────────────────────

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});

// ─── Auth notifier ────────────────────────────────────────────────────────────

class AuthNotifier extends StateNotifier<AsyncValue<void>> {
  AuthNotifier(this._repository, this._analytics)
      : super(const AsyncValue.data(null));

  final AuthRepository _repository;
  final AnalyticsService _analytics;

  Future<Result<User>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    final result = await _repository.signInWithEmail(
      email: email,
      password: password,
    );
    if (result.isSuccess) {
      await _analytics.logLogin('email');
    }
    state = const AsyncValue.data(null);
    return result;
  }

  Future<Result<User>> createUserWithEmail({
    required String email,
    required String password,
    required String nickname,
  }) async {
    state = const AsyncValue.loading();
    final result = await _repository.createUserWithEmail(
      email: email,
      password: password,
      nickname: nickname,
    );
    if (result.isSuccess) {
      await _analytics.logSignUp('email');
    }
    state = const AsyncValue.data(null);
    return result;
  }

  Future<Result<User>> signInWithGoogle() async {
    state = const AsyncValue.loading();
    final result = await _repository.signInWithGoogle();
    if (result.isSuccess) {
      await _analytics.logLogin('google');
    }
    state = const AsyncValue.data(null);
    return result;
  }

  Future<Result<void>> signOut() async {
    state = const AsyncValue.loading();
    final result = await _repository.signOut();
    state = const AsyncValue.data(null);
    return result;
  }

  Future<Result<void>> sendPasswordResetEmail(String email) async {
    state = const AsyncValue.loading();
    final result = await _repository.sendPasswordResetEmail(email);
    state = const AsyncValue.data(null);
    return result;
  }

  Future<Result<void>> deleteAccount() async {
    state = const AsyncValue.loading();
    final result = await _repository.deleteAccount();
    state = const AsyncValue.data(null);
    return result;
  }
}

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<void>>((ref) {
  return AuthNotifier(
    ref.read(authRepositoryProvider),
    ref.read(_analyticsServiceProvider),
  );
});
