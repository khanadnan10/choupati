import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../constants/db_constants.dart';

class LikesModel extends ChangeNotifier {
  Map<String, dynamic> likedItems = {};
  List<dynamic> _listOflikedVendor = [];
  List<dynamic> get listOfLikedVendor => _listOflikedVendor;
  bool isLiked(String itemId) {
    return likedItems.containsValue(itemId);
  }

  // void getLiked() {
  //   _listOflikedVendor.forEach((item) {

  //     //print("item $item");
  //     likedItems[item.toString()] = true;
  //   });
  // }

  void addLike(String itemId, String id) {
    likedItems[id] = itemId;

    notifyListeners();
  }

  void removeLike(String id) {
    likedItems.remove(id);
    notifyListeners();
  }

  void likedVendor(String useruid) async {
    var a = await firestore
        .collection('users')
        .doc(useruid)
        .collection('feature')
        .doc('like')
        .get();

    if (a.exists) {
      var uid = useruid;
      print(likedItems);
      var doc = firestore.collection('users').doc(uid).collection('feature');
      doc.doc('like').update({
        'liked': FieldValue.arrayUnion(likedItems.values.toList()),
      });
    } else {
      var uid = useruid;
      // print(likedItems);
      var doc = firestore.collection('users').doc(uid).collection('feature');
      await doc.doc('like').set({
        'liked': FieldValue.arrayUnion(likedItems.values.toList()),
      });
    }

    notifyListeners();
  }

  void dislikedvendor(String useruid, vendorID) async {
    var uid = useruid;
    print(likedItems);
    var doc = firestore.collection('users').doc(uid).collection('feature');
    await doc.doc('like').update({
      'liked': FieldValue.arrayRemove([vendorID]),
    });
    notifyListeners();
  }

  Future getLikedVendor(String useruid) async {
    var uid = useruid;
    var doc = firestore.collection('users').doc(uid).collection('feature');
    var data = await doc.doc('like').get();
    _listOflikedVendor = data.data()!['liked'] as dynamic;
    notifyListeners();
  }
}
