import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  const ProfileEntity({
    required this.uid,
    required this.email,
    required this.nickname,
    this.photoUrl,
    this.bio,
    required this.createdAt,
    this.subscriberCount = 0,
    this.subscriptionCount = 0,
    this.videoCount = 0,
  });

  final String uid;
  final String email;
  final String nickname;
  final String? photoUrl;
  final String? bio;
  final DateTime createdAt;
  final int subscriberCount;
  final int subscriptionCount;
  final int videoCount;

  ProfileEntity copyWith({
    String? nickname,
    String? photoUrl,
    String? bio,
    int? subscriberCount,
    int? subscriptionCount,
    int? videoCount,
  }) {
    return ProfileEntity(
      uid: uid,
      email: email,
      nickname: nickname ?? this.nickname,
      photoUrl: photoUrl ?? this.photoUrl,
      bio: bio ?? this.bio,
      createdAt: createdAt,
      subscriberCount: subscriberCount ?? this.subscriberCount,
      subscriptionCount: subscriptionCount ?? this.subscriptionCount,
      videoCount: videoCount ?? this.videoCount,
    );
  }

  @override
  List<Object?> get props => [
        uid,
        email,
        nickname,
        photoUrl,
        bio,
        createdAt,
        subscriberCount,
        subscriptionCount,
        videoCount,
      ];
}
