import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

/// Handles FCM token management and foreground message display.
class NotificationService {
  NotificationService(this._messaging);

  final FirebaseMessaging _messaging;

  Future<void> initialize() async {
    // Request permission (required on iOS; no-op on Android >= 13 handled by manifest)
    final settings = await _messaging.requestPermission();

    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      debugPrint('NotificationService: Permission denied.');
      return;
    }

    // Refresh token
    _messaging.onTokenRefresh.listen(_onTokenRefresh);

    // Foreground messages
    FirebaseMessaging.onMessage.listen(_onForegroundMessage);
  }

  Future<String?> getToken() async {
    try {
      return await _messaging.getToken();
    } catch (e) {
      debugPrint('NotificationService: Failed to get FCM token: $e');
      return null;
    }
  }

  void _onTokenRefresh(String token) {
    // In a real implementation, save the new token to Firestore
    debugPrint('NotificationService: Token refreshed.');
  }

  void _onForegroundMessage(RemoteMessage message) {
    // In a real implementation, show an in-app notification banner
    debugPrint('NotificationService: Foreground message received: ${message.messageId}');
  }
}
