import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class ProfileProvider with ChangeNotifier {
  Map<String, dynamic> _user = {};

  Map<String, dynamic> get user => _user;

  Future<void> getUserData() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      // Handle null user appropriately (e.g., redirect to login screen)
      return;
    }

    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();
      final userData = userDoc.data() as Map<String, dynamic>?;

      if (userData == null) {
        // Handle null userData appropriately (e.g., log error)
        return;
      }

      final name = userData['name'] as String?;
      final email = userData['email'] as String?;

      if (name == null || email == null) {
        // Handle null name or email appropriately (e.g., log error)
        return;
      }

      _user = {
        'name': name,
        'email': email,
      };
      notifyListeners();
    } catch (error) {
      // Handle the error appropriately (e.g., log error, show error message)
      print('Error fetching user data: $error');
    }
  }
}
