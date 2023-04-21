import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kaza_app/screens/homeScreen.dart';
import 'package:kaza_app/widget/navigationBarChildren.dart';

import '../screens/likesPage.dart';
import '../screens/profilescreen.dart';

class NavigationBarBottom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 64,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 8),
            blurRadius: 10,
            color: Colors.black87,
          ),
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(2),
          topRight: Radius.circular(2),
        ),
        // border: Border.all(width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            //? Add navigation.
            child: NavBarChildren(Icons.home, "Home"),
            onTap: () {
              // TODO : Add a condition for already being on home page.
              Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
            },
          ),
          InkWell(
            child: NavBarChildren(Icons.favorite_border, "Liked"),
            onTap: () {
              Navigator.pushNamed(context, LikesPage.routeName);
            },
          ),
          InkWell(
            child: NavBarChildren(Icons.video_collection_outlined, "Shorty"),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                      title:
                          const Text("Street Food Short Videos - Coming Soon!"),
                      content: const Text(
                          "You will be able to view Interactive & Detailed Street Food Short Videos\n\nHelp us know whether this feature will be of value to you or not?"),
                      actions: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text("Not Valuable")),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("Valuable"),
                            ),
                          ],
                        )
                      ]);
                },
              );
            },
          ),
          InkWell(
            child: NavBarChildren(Icons.person_outline, "Profile"),
            onTap: () {
              Navigator.pushNamed(context, ProfileScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}
