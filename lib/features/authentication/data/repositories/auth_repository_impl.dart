import 'package:firebase_auth/firebase_auth.dart';
import '../../../../common/models/result.dart';
import '../../../profile/data/sources/firestore_profile_source.dart';
import '../../domain/repositories/auth_repository.dart';
import '../sources/firebase_auth_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._source, this._profileSource);

  final FirebaseAuthSource _source;
  final FirestoreProfileSource _profileSource;

  @override
  Stream<User?> get authStateChanges => _source.authStateChanges;

  @override
  User? get currentUser => _source.currentUser;

  @override
  Future<Result<User>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _source.signInWithEmail(
        email: email,
        password: password,
      );
      return Success(credential.user!);
    } on FirebaseAuthException catch (e) {
      return Failure(_mapAuthError(e), e);
    } catch (e) {
      return Failure('로그인 중 오류가 발생했습니다.', e);
    }
  }

  @override
  Future<Result<User>> createUserWithEmail({
    required String email,
    required String password,
    required String nickname,
  }) async {
    try {
      final credential = await _source.createUserWithEmail(
        email: email,
        password: password,
      );
      final user = credential.user!;
      await user.updateDisplayName(nickname);
      await _profileSource.createProfile(
        uid: user.uid,
        email: email,
        nickname: nickname,
      );
      return Success(user);
    } on FirebaseAuthException catch (e) {
      return Failure(_mapAuthError(e), e);
    } catch (e) {
      return Failure('회원가입 중 오류가 발생했습니다.', e);
    }
  }

  @override
  Future<Result<User>> signInWithGoogle() async {
    try {
      final credential = await _source.signInWithGoogle();
      final user = credential.user!;
      if (credential.additionalUserInfo?.isNewUser == true) {
        await _profileSource.createProfile(
          uid: user.uid,
          email: user.email ?? '',
          nickname: user.displayName ??
              user.email?.split('@').first ??
              'User',
          photoUrl: user.photoURL,
        );
      }
      return Success(user);
    } on FirebaseAuthException catch (e) {
      return Failure(_mapAuthError(e), e);
    } catch (e) {
      return Failure('Google 로그인 중 오류가 발생했습니다.', e);
    }
  }

  @override
  Future<Result<void>> signOut() async {
    try {
      await _source.signOut();
      return const Success(null);
    } catch (e) {
      return Failure('로그아웃 중 오류가 발생했습니다.', e);
    }
  }

  @override
  Future<Result<void>> sendPasswordResetEmail(String email) async {
    try {
      await _source.sendPasswordResetEmail(email);
      return const Success(null);
    } on FirebaseAuthException catch (e) {
      return Failure(_mapAuthError(e), e);
    } catch (e) {
      return Failure('비밀번호 재설정 이메일 전송 중 오류가 발생했습니다.', e);
    }
  }

  @override
  Future<Result<void>> deleteAccount() async {
    try {
      await _source.deleteAccount();
      return const Success(null);
    } on FirebaseAuthException catch (e) {
      return Failure(_mapAuthError(e), e);
    } catch (e) {
      return Failure('계정 삭제 중 오류가 발생했습니다.', e);
    }
  }

  String _mapAuthError(FirebaseAuthException e) => switch (e.code) {
        'user-not-found' => '등록되지 않은 이메일입니다.',
        'wrong-password' => '비밀번호가 올바르지 않습니다.',
        'invalid-credential' => '이메일 또는 비밀번호가 올바르지 않습니다.',
        'email-already-in-use' => '이미 사용 중인 이메일입니다.',
        'invalid-email' => '올바르지 않은 이메일 형식입니다.',
        'weak-password' => '비밀번호가 너무 간단합니다.',
        'user-disabled' => '비활성화된 계정입니다.',
        'too-many-requests' => '잠시 후 다시 시도해주세요.',
        'requires-recent-login' => '보안을 위해 재로그인 후 다시 시도해주세요.',
        'google-sign-in-cancelled' => 'Google 로그인이 취소되었습니다.',
        _ => e.message ?? '인증 오류가 발생했습니다.',
      };
}
