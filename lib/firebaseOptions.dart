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
    apiKey: 'AIzaSyByRU0fyKeE2F8CDHeQO0Sd9mfoxkiMHmU',
    appId: '1:971820784676:web:c5ba49cedcd18bfc908cb1',
    messagingSenderId: '971820784676',
    projectId: 'kaza-app-1e3f1',
    authDomain: 'kaza-app-1e3f1.firebaseapp.com',
    databaseURL:
        'https://kaza-app-1e3f1-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'kaza-app-1e3f1.appspot.com',
    measurementId: 'G-1BFQP3KVEE',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCRwhguDWSmS5GWXGq1Z2H9MgAMe0dd4JI',
    appId: '1:971820784676:android:cb7c8df36f0aa50d908cb1',
    messagingSenderId: '971820784676',
    projectId: 'kaza-app-1e3f1',
    databaseURL:
        'https://kaza-app-1e3f1-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'kaza-app-1e3f1.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB__6NOiRnNAaQfQP7_tR_ytoaSltLctBE',
    appId: '1:971820784676:ios:8906dd399e422ea4908cb1',
    messagingSenderId: '971820784676',
    projectId: 'kaza-app-1e3f1',
    databaseURL:
        'https://kaza-app-1e3f1-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'kaza-app-1e3f1.appspot.com',
    iosClientId:
        '971820784676-hb2143late0bqgf0inukiavjcsguk5kv.apps.googleusercontent.com',
    iosBundleId: 'com.example.kazaApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB__6NOiRnNAaQfQP7_tR_ytoaSltLctBE',
    appId: '1:971820784676:ios:8906dd399e422ea4908cb1',
    messagingSenderId: '971820784676',
    projectId: 'kaza-app-1e3f1',
    databaseURL:
        'https://kaza-app-1e3f1-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'kaza-app-1e3f1.appspot.com',
    iosClientId:
        '971820784676-hb2143late0bqgf0inukiavjcsguk5kv.apps.googleusercontent.com',
    iosBundleId: 'com.example.kazaApp',
  );
}