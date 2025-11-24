// ignore_for_file: constant_identifier_names, lines_longer_than_80_chars

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        return linux;
      case TargetPlatform.fuchsia:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for TargetPlatform.fuchsia.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDuNC1AX1TjRgO-N04bFkppITouOVdP7JY',
    appId: '1:35395465388:web:1818b4d95c38f318c5ef09',
    messagingSenderId: '35395465388',
    projectId: 'mytome-e29ec',
    authDomain: 'mytome-e29ec.firebaseapp.com',
    storageBucket: 'mytome-e29ec.firebasestorage.app',
    measurementId: 'G-VPGXZ651LP',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'YOUR_ANDROID_API_KEY',
    appId: '1:1234567890:android:abcdef123456',
    messagingSenderId: '1234567890',
    projectId: 'my-tome-project',
    storageBucket: 'my-tome-project.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDacIyu74Q1MdZ9XhOCfDsYyY1PoLlcDkk',
    appId: '1:35395465388:ios:6f2773f3716d8f70c5ef09',
    messagingSenderId: '35395465388',
    projectId: 'mytome-e29ec',
    storageBucket: 'mytome-e29ec.firebasestorage.app',
    iosBundleId: 'com.mytome',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDacIyu74Q1MdZ9XhOCfDsYyY1PoLlcDkk',
    appId: '1:35395465388:ios:6f2773f3716d8f70c5ef09',
    messagingSenderId: '35395465388',
    projectId: 'mytome-e29ec',
    storageBucket: 'mytome-e29ec.firebasestorage.app',
    iosBundleId: 'com.mytome',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDuNC1AX1TjRgO-N04bFkppITouOVdP7JY',
    appId: '1:35395465388:web:335658e238e8c8afc5ef09',
    messagingSenderId: '35395465388',
    projectId: 'mytome-e29ec',
    authDomain: 'mytome-e29ec.firebaseapp.com',
    storageBucket: 'mytome-e29ec.firebasestorage.app',
    measurementId: 'G-XL4YL1SSJB',
  );

  static const FirebaseOptions linux = FirebaseOptions(
    apiKey: 'YOUR_LINUX_API_KEY',
    appId: '1:1234567890:web:abcdef123456',
    messagingSenderId: '1234567890',
    projectId: 'my-tome-project',
    storageBucket: 'my-tome-project.appspot.com',
  );
}