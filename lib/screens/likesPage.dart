import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kaza_app/providers/likeModelProvider.dart';
import 'package:kaza_app/providers/vendors.dart';
import 'package:kaza_app/screens/vendorScreen.dart';
import 'package:kaza_app/widget/circularLoading.dart';
import 'package:provider/provider.dart';

class LikesPage extends StatelessWidget {
  LikesPage({super.key});
  static const routeName = '/likesPage';

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    context.watch<LikesModel>().getLikedVendor(uid).catchError((e) {
      print(e);
    });
    List<Vendor> vendorData = context.read<Vendors>().vendors;
    final likedList = context.watch<LikesModel>().listOfLikedVendor;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text('Liked'),
        ),
        body: likedList.isNotEmpty
            ? Consumer<LikesModel>(
                builder: (context, value, child) => ListView.builder(
                  itemCount: value.listOfLikedVendor.length,
                  itemBuilder: (context, index) {
                    var data = (value.listOfLikedVendor.toList());
                    for (int i = 0; i < vendorData.length; i++) {
                      if (data[index] == vendorData[i].id) {
                        Vendor items = vendorData[i];
                        return Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 5),
                          padding: const EdgeInsets.all(5.0),
                          // width: 50.0,
                          // height: 50.0,

                          //  ---------------- for later designing purposes

                          // decoration: BoxDecoration(color: Colors.white, boxShadow: [
                          //   BoxShadow(
                          //     color: Colors.grey.withOpacity(0.5),
                          //     spreadRadius: 1,
                          //     blurRadius: 1,
                          //     offset: const Offset(0, 1), // changes position of shadow
                          //   ),
                          // ]),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                  VendorScreenMain.routeName,
                                  arguments: vendorData[i].id);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    CachedNetworkImage(
                                      imageUrl: items.image,
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        width: 50.0,
                                        height: 50.0,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          shape: BoxShape.rectangle,
                                          image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover),
                                        ),
                                      ),
                                      placeholder: (context, url) =>
                                          const CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                                    const SizedBox(
                                      width: 10.0,
                                    ),
                                    Text(items.nameVendor),
                                  ],
                                ),
                                IconButton(
                                    onPressed: () => value.dislikedvendor(
                                        FirebaseAuth.instance.currentUser!.uid,
                                        items.id),
                                    icon: const Icon(
                                      Icons.heart_broken,
                                      color: Colors.red,
                                    ))
                              ],
                            ),
                          ),
                        );
                      }
                    }
                    return const CircularLoading();
                  },
                ),
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      color: Colors.grey.shade400,
                      Icons.heart_broken,
                      size: 100,
                    ),
                    Text(
                      "You Haven't Liked Anything Yet!",
                      style:
                          TextStyle(fontSize: 20, color: Colors.grey.shade900),
                    )
                  ],
                ),
              ));
  }
}
