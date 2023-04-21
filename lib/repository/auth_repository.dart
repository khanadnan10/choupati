import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fbAuth;
import 'package:kaza_app/models/user_model.dart';

import '../constants/db_constants.dart';
import '../models/custom_error.dart';

class AuthRepository {
  late final FirebaseFirestore firebaseFirestore;
  late final fbAuth.FirebaseAuth firebaseAuth;
  AuthRepository({
    required this.firebaseFirestore,
    required this.firebaseAuth,
  });

  Stream<fbAuth.User?> get user => firebaseAuth.userChanges();

  Future<void> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final fbAuth.UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Uploading User information to firestore

      User user = User(uid: userCredential.user!.uid, name: name, email: email);

      await firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(user.toJson());
    } on fbAuth.FirebaseAuthException catch (e) {
      throw CustomError(code: e.code, message: e.message!, plugin: e.plugin);
    } catch (e) {
      throw CustomError(
        code: 'Exception',
        message: e.toString(),
        plugin: 'flutter_error/servor_error',
      );
    }
  }

  Future<void> signin({
    required String email,
    required String password,
  }) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } on fbAuth.FirebaseAuthException catch (e) {
      throw CustomError(code: e.code, message: e.message!, plugin: e.plugin);
    } catch (e) {
      throw CustomError(
        code: 'Exception',
        message: e.toString(),
        plugin: 'flutter_error/servor_error',
      );
    }
  }

  Future<void> signout() async {
    await firebaseAuth.signOut();
  }
}
