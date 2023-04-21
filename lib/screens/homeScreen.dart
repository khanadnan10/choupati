import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaza_app/providers/areaName.dart';
import 'package:kaza_app/providers/categories.dart';
import 'package:kaza_app/providers/location.dart';
import 'package:kaza_app/widget/category.dart';
import 'package:kaza_app/widget/circularLoading.dart';
import 'package:kaza_app/widget/navigationBar.dart';
import 'package:kaza_app/widget/searchBar.dart';
import 'package:kaza_app/widget/topBar.dart';
import 'package:kaza_app/widget/vendorCardSmall.dart';
import 'package:provider/provider.dart';
import 'package:upgrader/upgrader.dart';
import '../providers/likeModelProvider.dart';
import '../providers/roadName.dart';
import '../providers/vendors.dart';
import '../utils/constant.dart';

// Home Screen
class HomeScreen extends StatefulWidget {
  static const routeName = '/home-Screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Size screenSize = Size.zero;
  late double? lat = 0.0;
  late double? long = 0.0;
  late String nearestRoad = '';
  late String nearestArea = '';
  late List<Vendor> sortedByLocation = [];
  late List<Vendor> vendorsRoadList = [];
  late List<Vendor> vendorsAreaList = [];
  late List<dynamic> likedList = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getLikedVendors();
    getLocationData();
  }

  void getLocationData() {
    final locationData =
        Provider.of<LocationDataProvider>(context, listen: true).userLocation;

    // var filters = Provider.of<Filters>(context, listen: false).filters;
    // var filtersFunction = Provider.of<Filters>(context);
    var categories = Provider.of<Categories>(context, listen: true).categories;
    var lat = 0.0;
    var long = 0.0;

    if (locationData != null) {
      lat = locationData.latitude;
      long = locationData.longitude;
    }

    final roadName = Provider.of<RoadNames>(context, listen: true);
    nearestRoad = roadName.findNearestRoad(roadName.roadData, lat, long);

    final areaName = Provider.of<AreaNames>(context, listen: true);
    nearestArea = areaName.findNearestArea(areaName.areaData, lat, long);

    final vendorsFunctionData = Provider.of<Vendors>(context, listen: true);
    sortedByLocation = vendorsFunctionData.sortByLocation(
      vendorsFunctionData.vendors,
      lat,
      long,
    );
    vendorsRoadList = vendorsFunctionData.reviewsSorting(
      vendorsFunctionData.findByRoadName(
          vendorsFunctionData.vendors, nearestRoad),
    );
    vendorsAreaList = vendorsFunctionData.reviewsSorting(
      vendorsFunctionData.findByAreaName(
          vendorsFunctionData.vendors, nearestArea),
    );
  }

  void getLikedVendors() {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    context.watch<LikesModel>().getLikedVendor(uid);
    likedList = context.watch<LikesModel>().listOfLikedVendor;
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    var categories = Provider.of<Categories>(context, listen: false).categories;
    return Container(
      // wrapping my safe area into a container, to change its color.
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 2),
      child: UpgradeAlert(
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.orange.shade500,
            bottomNavigationBar: NavigationBarBottom(),
            // Making the body scrollable.
            // Missed to expand the scroll view as container.
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Text(
                      //Todo : Need to integrate with the backend .
                      "Currrent Location",
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                  TopBar(),
                  const SearchBar(),
                  const SizedBox(
                    height: 20.0,
                  ),
                  // Text for fonts wrapping with a container to align properly
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange,
                          offset: Offset(0, -8.0),
                          blurRadius: 15.0,
                          spreadRadius: -8.0,
                        ),
                        BoxShadow(
                          color: Colors.red,
                          offset: Offset(0, -1.0),
                          blurRadius: 15.0,
                          spreadRadius: -8.0,
                        ),
                      ],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25.0),
                        topRight: Radius.circular(25.0),
                      ),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20.0,
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          alignment: Alignment.centerLeft,
                          width: double.infinity,
                          // Adding const, might delete later.
                          child: const Text(
                            "Speciality",
                            style: kFoodTitleText,
                            textAlign: TextAlign.start,
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        // Cuisines Gridview
                        SizedBox(
                          height: screenSize.height * .5 > 336.49
                              ? 336.49
                              : screenSize.height * .5,
                          child: GridView.builder(
                              scrollDirection: Axis.horizontal,
                              //physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisExtent: 120,
                                mainAxisSpacing: 0.1,
                              ),
                              itemCount: categories.length,
                              itemBuilder: (_, idx) {
                                final item = categories[idx];
                                return CategoryItem(
                                  item.imageUrl,
                                  item.label,
                                  item.id,
                                );
                              }),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          alignment: Alignment.centerLeft,
                          width: double.infinity,
                          // Adding const, might delete later.
                          child: const Text(
                            "Popular Nearby",
                            style: kFoodTitleText,
                            textAlign: TextAlign.start,
                          ),
                        ),
                        // ListView For Street food vendor card small.
                        // VendorCardSmall("/", "Krish", 4, "Krrish"),
                        //? This container contains the ListView builder for the Road List
                        const SizedBox(
                          height: 25.0,
                        ),
                        sortedByLocation.isEmpty
                            //* Show loading indicator
                            ? const CircularLoading()
                            : Container(
                                padding: const EdgeInsets.all(4),
                                width: double.infinity,
                                height: 260,
                                // Will change it into builder once, have data.
                                child: ListView.builder(
                                  itemBuilder: (context, index) {
                                    return Consumer<LikesModel>(
                                      builder: (context, likesModel, child) {
                                        final isLiked = likedList.any(
                                            (element) =>
                                                element ==
                                                sortedByLocation[index].id);
                                        // print("isliked");
                                        // print(isLiked);
                                        return VendorCardSmall(
                                            index.toString(),
                                            sortedByLocation[index]
                                                .id
                                                .toString(),
                                            isLiked,
                                            likesModel);
                                      },
                                    );
                                  },
                                  //todo : Work on the itemCount
                                  itemCount: 10,
                                  scrollDirection: Axis.horizontal,
                                ),
                              ),
                        const SizedBox(
                          height: 25.0,
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          alignment: Alignment.centerLeft,
                          width: double.infinity,
                          // Adding const, might delete later.
                          child: Text(
                            "Popular $nearestRoad",
                            style: kFoodTitleText,
                            textAlign: TextAlign.start,
                          ),
                        ),
                        const SizedBox(
                          height: 25.0,
                        ),
                        //? This container contains the Best of Road section
                        vendorsRoadList.isEmpty
                            ? const CircularLoading()
                            : Container(
                                padding: const EdgeInsets.all(4),
                                width: double.infinity,
                                height: 260,
                                // Will change it into builder once, have data.
                                child: ListView.builder(
                                  itemBuilder: (context, index) {
                                    return Consumer<LikesModel>(
                                      builder: (context, likesModel, child) {
                                        final isLiked = likedList.any(
                                            (element) =>
                                                element ==
                                                vendorsRoadList[index].id);
                                        // likesModel.likedVendor(
                                        //     sortedByLocation[index].id);
                                        return VendorCardSmall(
                                            index.toString(),
                                            vendorsRoadList[index]
                                                .id
                                                .toString(),
                                            isLiked,
                                            likesModel);
                                      },
                                    );
                                  },
                                  //todo : Work on the itemCount
                                  itemCount: 10,
                                  scrollDirection: Axis.horizontal,
                                ),
                              ),
                        const SizedBox(
                          height: 25.0,
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          alignment: Alignment.centerLeft,
                          width: double.infinity,
                          // Adding const, might delete later.
                          child: Text(
                            "Popular $nearestArea",
                            style: kFoodTitleText,
                            textAlign: TextAlign.start,
                          ),
                        ),
                        //? This container contains the popular in area section.
                        const SizedBox(
                          height: 25.0,
                        ),
                        vendorsAreaList.isEmpty
                            ? const CircularLoading()
                            : Container(
                                padding: const EdgeInsets.all(4),
                                width: double.infinity,
                                height: 260,
                                // Will change it into builder once, have data.
                                child: ListView.builder(
                                  itemBuilder: (context, index) {
                                    return Consumer<LikesModel>(
                                      builder: (context, likesModel, child) {
                                        final isLiked = likedList.any(
                                            (element) =>
                                                element ==
                                                vendorsAreaList[index].id);
                                        return VendorCardSmall(
                                            index.toString(),
                                            vendorsAreaList[index]
                                                .id
                                                .toString(),
                                            isLiked,
                                            likesModel);
                                      },
                                    );
                                  },
                                  //todo : Work on the itemCount
                                  itemCount: 10,
                                  scrollDirection: Axis.horizontal,
                                ),
                              ),
                        const SizedBox(
                          height: 25.0,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
