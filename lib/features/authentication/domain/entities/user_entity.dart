import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  const UserEntity({
    required this.uid,
    required this.email,
    required this.nickname,
    this.photoUrl,
    this.bio,
    required this.createdAt,
  });

  final String uid;
  final String email;
  final String nickname;
  final String? photoUrl;
  final String? bio;
  final DateTime createdAt;

  @override
  List<Object?> get props => [uid, email, nickname, photoUrl, bio, createdAt];
}
