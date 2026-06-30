import 'package:firebase_auth/firebase_auth.dart';
import '../../../../common/models/result.dart';

abstract interface class AuthRepository {
  /// Stream of the currently signed-in Firebase user.
  Stream<User?> get authStateChanges;

  Future<Result<User>> signInWithEmail({
    required String email,
    required String password,
  });

  Future<Result<User>> createUserWithEmail({
    required String email,
    required String password,
    required String nickname,
  });

  Future<Result<User>> signInWithGoogle();

  Future<Result<void>> signOut();

  Future<Result<void>> sendPasswordResetEmail(String email);

  Future<Result<void>> deleteAccount();

  User? get currentUser;
}
