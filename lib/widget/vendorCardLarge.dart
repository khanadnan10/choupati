import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../providers/vendors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VendorLarge extends StatelessWidget {
  String id;
  VendorLarge(this.id);

  @override
  Widget build(BuildContext context) {
    Vendor vendorData = Provider.of<Vendors>(context, listen: true)
        .findById(Provider.of<Vendors>(context).vendors, id);
    var vendorsFunction = Provider.of<Vendors>(context, listen: false);
    var specialityItems = Provider.of<Vendors>(context, listen: false)
        .convertToMenuItemsSpeciality(vendorData.speciality)[0];
    var parking = vendorData.parking;
    var seating = vendorData.seating;
    return Container(
      decoration: BoxDecoration(
          border: Border.all(width: 0.2),
          borderRadius: BorderRadius.circular(16)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            fit: StackFit.loose,
            children: [
              SizedBox(
                // Setting the width to full screen.
                width: double.infinity,
                height: 175,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  child: GestureDetector(
                    onTap: (() {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: ((context) => DetailScreen(vendorData.image)),
                      ));
                    }),
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
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                ),
              ),
              //? Veg & Non Veg
              Positioned(
                top: 15,
                left: 20,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: vendorsFunction.getColorForOptions(
                        vendorData.veg,
                        vendorData.nonVeg,
                      ),
                    ),
                  ),
                  child: Icon(
                    Icons.circle,
                    size: 24,
                    color: vendorsFunction.getColorForOptions(
                      vendorData.veg,
                      vendorData.nonVeg,
                    ),
                  ),
                ),
              ),

              Positioned(
                top: 15,
                right: 20,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    border: Border.all(
                      width: 1,
                      color: Colors.red,
                    ),
                  ),
                  child: parking == "availableNearby"
                      ? const Icon(
                          Icons.local_parking,
                          size: 24,
                          color: Colors.white,
                        )
                      : const Icon(
                          Icons.not_interested,
                          size: 24,
                          color: Colors.white,
                        ),
                ),
              ),

              Positioned(
                bottom: 12,
                right: 20,
                child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      border: Border.all(
                        width: 1,
                        color: Colors.red,
                      ),
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.chair,
                          size: 24,
                          color: Colors.white,
                        ),
                        Text(
                          "$seating",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    )),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            alignment: Alignment.centerLeft,
            height: 32,
            width: double.infinity,
            decoration: BoxDecoration(
                color: vendorsFunction.isShopOpen(vendorData)
                    ? Colors.green
                    : Colors.red),
            child: Text(
                vendorsFunction.isShopOpen(vendorData) ? "Open" : "Closed"),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // This is the container containing the text elements.
              Container(
                padding: const EdgeInsets.all(4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 2, horizontal: 6),
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        width: 230,
                        child: FittedBox(
                          alignment: Alignment.centerLeft,
                          fit: BoxFit.scaleDown,
                          child: Text(
                            vendorData.nameVendor,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 240,
                      padding: const EdgeInsets.symmetric(
                          vertical: 2, horizontal: 6),
                      alignment: Alignment.centerLeft,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          "Speciality: ${specialityItems.menuItemName}",
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    //! Might not release in this version.
                    // TODO: Hashtags for vendor cards
                    // Container(
                    //   padding: const EdgeInsets.symmetric(
                    //       vertical: 2, horizontal: 6),
                    //   alignment: Alignment.centerLeft,
                    //   child: const Text(
                    //     "#Street Food  #InformedChoices",
                    //     style: TextStyle(fontSize: 12),
                    //   ),
                    // ),
                    // TODO : Integrate with backend here.
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 6),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '📌 ${vendorData.roadName}, ${vendorData.landmarkName}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
              //parking seating

              //? Container contains the rating.
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(width: 0.2),
                ),
                alignment: Alignment.topCenter,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  children: [
                    // Row containing the rating and the star.
                    Container(
                      decoration: BoxDecoration(
                        color: vendorsFunction
                            .getColorForRating(vendorData.ratingVendor),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                        ),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "${vendorData.ratingVendor}",
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          const Icon(
                            Icons.star,
                            size: 16,
                            color: Colors.black,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    //? Here you will have the total reviews.
                    const Text(
                      "5",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Container(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: const Text(
                        "Reviews",
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  String link;
  DetailScreen(this.link);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Image Preview"),
            elevation: 0,
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          body: GestureDetector(
            child: Container(
              padding: const EdgeInsets.all(4),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Hero(
                tag: 'imageHero',
                child: InteractiveViewer(
                  child: CachedNetworkImage(
                    imageUrl: link,
                    fit: BoxFit.contain,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) => Transform.scale(
                      scale: 1,
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
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }
}
