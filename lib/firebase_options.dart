// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyD60wWIPrcopumMzq82SVwhg1GlMDLFX_w',
    appId: '1:799208073244:web:85c26a0c644edf9bf997d9',
    messagingSenderId: '799208073244',
    projectId: 'online-college-da0ab',
    authDomain: 'online-college-da0ab.firebaseapp.com',
    storageBucket: 'online-college-da0ab.appspot.com',
    measurementId: 'G-7RPLWZ3K1G',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCh_O4QOPiRXRjbBvx3LFZ--27eeCxaQr8',
    appId: '1:799208073244:android:9cde2dfcc237dd42f997d9',
    messagingSenderId: '799208073244',
    projectId: 'online-college-da0ab',
    storageBucket: 'online-college-da0ab.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDrmotm2kGLNNizI97nxGTWewNE6GbgRKw',
    appId: '1:799208073244:ios:9d683ea2c7dcaeacf997d9',
    messagingSenderId: '799208073244',
    projectId: 'online-college-da0ab',
    storageBucket: 'online-college-da0ab.appspot.com',
    iosBundleId: 'com.example.onlineCollege',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDrmotm2kGLNNizI97nxGTWewNE6GbgRKw',
    appId: '1:799208073244:ios:f1625c1e58d35540f997d9',
    messagingSenderId: '799208073244',
    projectId: 'online-college-da0ab',
    storageBucket: 'online-college-da0ab.appspot.com',
    iosBundleId: 'com.example.onlineCollege.RunnerTests',
  );
}
