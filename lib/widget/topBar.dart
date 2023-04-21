import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaza_app/providers/likeModelProvider.dart';
import 'package:kaza_app/providers/roadName.dart';
import 'package:provider/provider.dart';
import '../providers/location.dart';

// Top bar
// Consists of a row containing the location icon & name of the location
// Profile

// Have to be stateless because, locally we are not changing any state. .

class TopBar extends StatelessWidget {
  TopBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    //Setting up the providers.
    var profileProvider =
        Provider.of<LikesModel>(context, listen: true).likedItems;
    var locationData =
        Provider.of<LocationDataProvider>(context, listen: true).userLocation;
    var roadName = Provider.of<RoadNames>(context, listen: true);
    var lat = 0.0;
    var long = 0.0;

    if (locationData != null) {
      lat = locationData.latitude as double;
      long = locationData.longitude as double;
    }

    // Container to take more control of spacing
    return Container(
      decoration: BoxDecoration(
          // border: Border.all(width: 2),
          borderRadius: BorderRadius.circular(16)),
      // padding: const EdgeInsets.all(2),
      // Take all the available width
      width: screenSize.width,
      // First row containing the Row of Location & Profile also to shift it to the end.
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // The location Text and Icon - Location
              Row(
                // mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // The location icon
                  IconButton(
                    // On pressed will return a drop down or page to select the location
                    onPressed: () {},
                    icon: const Icon(
                      Icons.location_pin,
                      color: Colors.white,
                    ),
                  ),
                  // The text will indicate the users location.
                  Text(
                    roadName.findNearestRoad(roadName.roadData, lat, long),
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              //
              // Profile Creation
              GestureDetector(
                // On tap it will take us to the profile page of the user.
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("List Feature Coming Soon"),
                        content: const Text(
                            "You will be able to modify your profile, get rewarded to complete tasks, view your past visits and many more things\n\nHelp us know whether this feature will be of value to you or not?"),
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
                        ],
                      );
                    },
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: ClipOval(
                      child: Icon(
                        Icons.account_circle,
                        // Alter the size to change the size of the icon.
                        size: 40,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<dynamic> newMethod(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Set Location - Coming Soon"),
          content: const Text(
              "You will be able to set location to desired Khaogalis\n\nHelp us know whether this feature will be of value to you or not?"),
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
            ),
          ],
        );
      },
    );
  }
}
