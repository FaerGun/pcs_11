// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyCLcGTQCJ1xyw7KKF7GtWGYZceYnqtfCOM',
    appId: '1:874419053562:web:d252cd86671fd2ad007a43',
    messagingSenderId: '874419053562',
    projectId: 'product-e3d5d',
    authDomain: 'product-e3d5d.firebaseapp.com',
    databaseURL: 'https://product-e3d5d-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'product-e3d5d.firebasestorage.app',
    measurementId: 'G-J3W7NZN691',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCLcGTQCJ1xyw7KKF7GtWGYZceYnqtfCOM',
    appId: '1:874419053562:web:febf8a125f0fa9d1007a43',
    messagingSenderId: '874419053562',
    projectId: 'product-e3d5d',
    authDomain: 'product-e3d5d.firebaseapp.com',
    databaseURL: 'https://product-e3d5d-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'product-e3d5d.firebasestorage.app',
    measurementId: 'G-KX7KRWM9XG',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBROdaviUyzSm8XK1FSpV2XsKjqGT74mY8',
    appId: '1:874419053562:android:31ca736439d56abe007a43',
    messagingSenderId: '874419053562',
    projectId: 'product-e3d5d',
    databaseURL: 'https://product-e3d5d-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'product-e3d5d.firebasestorage.app',
  );

}