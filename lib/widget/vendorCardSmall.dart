import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kaza_app/providers/likeModelProvider.dart';
import 'package:kaza_app/providers/roadName.dart';
import 'package:kaza_app/screens/vendorScreen.dart';
import 'package:provider/provider.dart';
import '../providers/vendors.dart';
import '../providers/location.dart';

class VendorCardSmall extends StatelessWidget {
  final String id;
  final String vendorId;
  bool isLiked;
  LikesModel likesModel;
  VendorCardSmall(this.id, this.vendorId, this.isLiked, this.likesModel,
      {super.key});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    Vendor vendorData = Provider.of<Vendors>(context, listen: false)
        .findById(Provider.of<Vendors>(context).vendors, vendorId);
    var specialityItems = Provider.of<Vendors>(context, listen: false)
        .convertToMenuItemsSpeciality(vendorData.speciality)[0];
    var distanceCalculator = Provider.of<RoadNames>(context, listen: false);
    var locationData =
        Provider.of<LocationDataProvider>(context, listen: false).userLocation;
    var vendorsFunction = Provider.of<Vendors>(context, listen: false);
    //? Getting the width of the screen.
    // final widthScreen = MediaQuery.of(context).size.width;

    //? Wrap the thing with gesture detector, will be needed.
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed(VendorScreenMain.routeName, arguments: vendorId);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              offset: Offset(0, 0),
              blurRadius: 5,
              color: Colors.black12,
            ),
          ],

          // border: Border.all(width: 1),
          borderRadius: BorderRadius.circular(16),
        ),
        width: screenSize.width * 0.45,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                Positioned(
                  // To ensure the image fits the box.
                  // Container to fit the image.
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16)),
                    child: SizedBox(
                      width: 175,
                      height: 125,
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: CachedNetworkImage(
                          imageUrl: vendorData.image,
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) =>
                                  Transform.scale(
                            scale: 0.5,
                            child: CircularProgressIndicator(
                              value: downloadProgress.progress,
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                    ),
                  ),
                ),
                // For the positioning of the veg icon.
                Positioned(
                  top: 15,
                  left: 15,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 2,
                        color: vendorsFunction.getColorForOptions(
                            vendorData.veg, vendorData.nonVeg),
                      ),
                      color: Colors.white,
                    ),
                    // Will insert the backend later to change color from green to red to brown.
                    child: Icon(
                      Icons.circle,
                      color: vendorsFunction.getColorForOptions(
                          vendorData.veg, vendorData.nonVeg),
                      size: 18,
                    ),
                  ),
                  // Won't be building the fav icon as of now.
                ),

                Positioned(
                  top: 5,
                  right: 15,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      color: Colors.white,
                      child: IconButton(
                        iconSize: 35,
                        icon: Icon(
                            isLiked ? Icons.favorite : Icons.favorite_border,
                            color: isLiked ? Colors.red : Colors.grey),
                        onPressed: () {
                          String user = FirebaseAuth.instance.currentUser!.uid;
                          if (isLiked) {
                            likesModel.removeLike(id.toString());
                            likesModel.dislikedvendor(user, vendorId);
                          } else {
                            likesModel.addLike(vendorId, id.toString());
                            likesModel.likedVendor(user);
                          }
                        },
                      ),
                    ),
                  ),
                ),
                // Won't be building the fav icon as of now.
              ],
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                decoration: BoxDecoration(
                  // Color will change depending on the logic.
                  color: vendorsFunction.isShopOpen(vendorData)
                      ? Colors.green.shade100
                      : Colors.red.shade100,
                ),
                alignment: Alignment.centerLeft,
                // Text & color will change depending on the logic.
                //? No need to make this responsive.
                child: Text(
                  vendorsFunction.isShopOpen(vendorData) ? "Open" : "Closed",
                  style: vendorsFunction.isShopOpen(vendorData)
                      ? const TextStyle(
                          fontSize: 18,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        )
                      : const TextStyle(
                          fontSize: 18,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                ),
              ),
            ),
            // Container Containing the vendor name and rating.
            Container(
              // decoration: BoxDecoration(border: Border.all(width: 1)),
              padding: const EdgeInsets.all(2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Vendor Name will change with backend. //! Need to make this responsive. or even increase the box height.
                  SizedBox(
                    width: 120,
                    child: FittedBox(
                      alignment: Alignment.centerLeft,
                      fit: BoxFit.scaleDown,
                      child: Text(
                        vendorData.nameVendor,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                  // Container Containing the rating and the star.
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                    // width: 42,
                    // height: 20,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey.shade200,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      // This is the rating text and star //? No need to make this responsive.
                      children: [
                        Icon(
                          Icons.star,
                          color: vendorsFunction
                              .getColorForRating(vendorData.ratingVendor),
                          size: 14,
                        ),
                        Text(
                          vendorData.ratingVendor.toStringAsFixed(1),
                          textAlign: TextAlign.center,
                          softWrap: true,
                          style: TextStyle(
                            fontSize: 14,
                            color: vendorsFunction
                                .getColorForRating(vendorData.ratingVendor),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Container Containing the speciality.
            Container(
              width: screenSize.width,
              padding: const EdgeInsets.only(left: 2, right: 2, bottom: 2),
              // decoration: BoxDecoration(border: Border.all(width: 1)),
              alignment: Alignment.centerLeft,
              child: FittedBox(
                // fit: BoxFit.fitWidth,
                child: Row(
                  children: [
                    const Icon(
                      Icons.auto_graph_outlined,
                      color: Colors.redAccent,
                      size: 16.0,
                    ),
                    const SizedBox(
                      width: 5.0,
                    ),
                    Text(
                      // Will change according to the backend.
                      " ${specialityItems.menuItemName}",
                      style: const TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontStyle: FontStyle.italic,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //? To indicate the price or expensiveness.
            Container(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
              // decoration: BoxDecoration(border: Border.all(width: 1)),
              alignment: Alignment.centerLeft,
              //
              child: Text(
                "Price Indicator : ${vendorsFunction.priceIndicator(vendorData.avgPrice)}",
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),

            // Container Containing the distance
            Container(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
              margin: const EdgeInsets.only(bottom: 4),
              // decoration: BoxDecoration(border: Border.all(width: 1)),
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  const Icon(
                    Icons.social_distance_rounded,
                    size: 16.0,
                  ),
                  const SizedBox(
                    width: 5.0,
                  ),
                  Text(
                    // Distance and walking time ? : Cooking time?
                    "Distance : ${distanceCalculator.calculateDistance(vendorData.latitude, vendorData.longitude, locationData?.latitude ?? 0.0, locationData?.longitude ?? 0.0).toStringAsFixed(2)} km",
                    style: const TextStyle(fontSize: 10),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


/*

 */

/*
Container(
        margin: const EdgeInsets.only(right: 10.0, left: 6.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
            width: 1,
            color: Colors.grey.shade300,
          ),
          // boxShadow: const [
          //   BoxShadow(
          //     offset: Offset(0, 0),
          //     blurRadius: 5,
          //     color: Colors.black12,
          //   ),
          // ],
        ),
        // height: 100,
        width: screenSize.width * 0.45,
        child: Column(
          // mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.grey.shade300,
              ),
              height: screenSize.height * 0.2,
              child: SizedBox(
                height: 100,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Positioned(
                      // To ensure the image fits the box.
                      // Container to fit the image.
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: CachedNetworkImage(
                          imageUrl: vendorData.image,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Shimmer.fromColors(
                            baseColor: Colors.grey,
                            highlightColor: Colors.grey.shade300,
                            child: const Image(
                              color: Colors.white,
                              image: AssetImage(
                                'lib/assets/images/kaza-logo.png',
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => const Icon(
                            Icons.restaurant,
                            size: 5.0,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      left: 5,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(
                            width: 1.5,
                            color: vendorsFunction.getColorForOptions(
                              vendorData.veg,
                              vendorData.nonVeg,
                            ),
                          ),
                          color: Colors.white,
                        ),
                        // Will insert the backend later to change color from green to red to brown.
                        child: Icon(
                          Icons.circle,
                          color: vendorsFunction.getColorForOptions(
                              vendorData.veg, vendorData.nonVeg),
                          size: 12,
                        ),
                      ),
                      // Won't be building the fav icon as of now.
                    ),
                    Positioned(
                      bottom: 8.0,
                      left: 5.0,
                      child: Container(
                        padding: const EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50.0),
                          color: vendorsFunction.isShopOpen(vendorData)
                              ? Colors.green.shade100
                              : Colors.red.shade100,
                        ),
                        child: Text(
                          vendorsFunction.isShopOpen(vendorData)
                              ? " Open "
                              : " Closed ",
                          style: vendorsFunction.isShopOpen(vendorData)
                              ? const TextStyle(
                                  fontSize: 14,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                )
                              : const TextStyle(
                                  fontSize: 14,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // vendor Shop Info in text field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    vendorData.nameVendor,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      // color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Container(
                    padding: const EdgeInsets.all(3.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50.0),
                      color: Colors.grey.shade200,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      // This is the rating text and star //? No need to make this responsive.
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.star,
                          color: vendorsFunction
                              .getColorForRating(vendorData.ratingVendor),
                          size: 10,
                        ),
                        Text(
                          vendorData.ratingVendor.toStringAsFixed(1),
                          textAlign: TextAlign.center,
                          softWrap: true,
                          style: TextStyle(
                            fontSize: 10,
                            color: vendorsFunction
                                .getColorForRating(vendorData.ratingVendor),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  FittedBox(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.auto_graph_outlined,
                          color: Colors.redAccent,
                          size: 16.0,
                        ),
                        const SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          // Will change according to the backend.
                          specialityItems.menuItemName,
                          style: const TextStyle(
                            fontSize: 12,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                    // decoration: BoxDecoration(border: Border.all(width: 1)),
                    alignment: Alignment.centerLeft,
                    //
                    child: Text(
                      "Price Indicator: ${vendorsFunction.priceIndicator(vendorData.avgPrice)}",
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.social_distance_rounded,
                        size: 16.0,
                      ),
                      const SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        // Distance and walking time ? : Cooking time?
                        "${distanceCalculator.calculateDistance(vendorData.latitude, vendorData.longitude, locationData!.latitude, locationData.longitude).toStringAsFixed(2)} km",
                        style: const TextStyle(
                          fontSize: 12,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
 */