// Public placeholder Firebase options.
//
// For local development, replace these values by running FlutterFire CLI against
// your own Firebase project or by editing this file with local-only values.
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show TargetPlatform, defaultTargetPlatform, kIsWeb;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      case TargetPlatform.linux:
        throw UnsupportedError('Firebase options are not configured for this platform.');
      default:
        throw UnsupportedError('Firebase options are not supported for this platform.');
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'replace-me',
    appId: 'replace-me',
    messagingSenderId: 'replace-me',
    projectId: 'replace-me',
    authDomain: 'replace-me.firebaseapp.com',
    storageBucket: 'replace-me.appspot.com',
    measurementId: 'replace-me',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'replace-me',
    appId: 'replace-me',
    messagingSenderId: 'replace-me',
    projectId: 'replace-me',
    storageBucket: 'replace-me.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'replace-me',
    appId: 'replace-me',
    messagingSenderId: 'replace-me',
    projectId: 'replace-me',
    storageBucket: 'replace-me.appspot.com',
    iosClientId: 'replace-me.apps.googleusercontent.com',
    iosBundleId: 'com.example.lumy',
  );
}
