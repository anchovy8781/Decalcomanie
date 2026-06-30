// Placeholder used by CI when real Firebase credentials are not available.
// Do NOT use this file in any real build or deployment.

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) throw UnsupportedError('Web not supported.');
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        throw UnsupportedError('Android only.');
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'CI-PLACEHOLDER',
    appId: '1:000000000000:android:0000000000000000000000',
    messagingSenderId: '000000000000',
    projectId: 'mirrortube-placeholder',
    storageBucket: 'mirrortube-placeholder.appspot.com',
  );
}
