import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/profile_entity.dart';

/// Raw Firestore/Storage calls for the profile feature.
class FirestoreProfileSource {
  FirestoreProfileSource(this._firestore, this._storage);

  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  CollectionReference<Map<String, dynamic>> get _users =>
      _firestore.collection('users');

  Future<void> createProfile({
    required String uid,
    required String email,
    required String nickname,
    String? photoUrl,
  }) async {
    await _users.doc(uid).set({
      'uid': uid,
      'email': email,
      'nickname': nickname,
      'photoUrl': photoUrl,
      'bio': null,
      'createdAt': FieldValue.serverTimestamp(),
      'subscriberCount': 0,
      'subscriptionCount': 0,
      'videoCount': 0,
    });
  }

  Future<ProfileEntity?> getProfile(String uid) async {
    final doc = await _users.doc(uid).get();
    if (!doc.exists) return null;
    return _fromDoc(doc);
  }

  Stream<ProfileEntity?> watchProfile(String uid) {
    return _users.doc(uid).snapshots().map((snap) {
      if (!snap.exists) return null;
      return _fromDoc(snap);
    });
  }

  Future<void> updateProfile({
    required String uid,
    String? nickname,
    String? bio,
  }) async {
    final data = <String, dynamic>{};
    if (nickname != null) data['nickname'] = nickname;
    if (bio != null) data['bio'] = bio;
    if (data.isEmpty) return;
    await _users.doc(uid).update(data);
  }

  Future<String> uploadProfilePhoto({
    required String uid,
    required File imageFile,
  }) async {
    final ref = _storage.ref('profile_photos/$uid.jpg');
    final task = await ref.putFile(
      imageFile,
      SettableMetadata(contentType: 'image/jpeg'),
    );
    final url = await task.ref.getDownloadURL();
    await _users.doc(uid).update({'photoUrl': url});
    return url;
  }

  Future<void> deleteProfilePhoto(String uid) async {
    await _storage.ref('profile_photos/$uid.jpg').delete();
    await _users.doc(uid).update({'photoUrl': FieldValue.delete()});
  }

  ProfileEntity _fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return ProfileEntity(
      uid: data['uid'] as String,
      email: data['email'] as String,
      nickname: data['nickname'] as String,
      photoUrl: data['photoUrl'] as String?,
      bio: data['bio'] as String?,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      subscriberCount: (data['subscriberCount'] as int?) ?? 0,
      subscriptionCount: (data['subscriptionCount'] as int?) ?? 0,
      videoCount: (data['videoCount'] as int?) ?? 0,
    );
  }
}

// Provider exposed to the auth layer to avoid circular dependency
final firestoreProfileSourceProvider = Provider<FirestoreProfileSource>((ref) {
  return FirestoreProfileSource(
    FirebaseFirestore.instance,
    FirebaseStorage.instance,
  );
});
