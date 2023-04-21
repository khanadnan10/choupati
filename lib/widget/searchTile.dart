import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../providers/vendors.dart';
import 'package:provider/provider.dart';
import 'package:kaza_app/screens/vendorScreen.dart';
import '../providers/location.dart';
import '../providers/roadName.dart';

class SearchTile extends StatelessWidget {
  //? takes the id of the vendor
  String id;
  SearchTile(this.id, {super.key});
  @override
  Widget build(BuildContext context) {
    Vendor vendorData = Provider.of<Vendors>(context, listen: true)
        .findById(Provider.of<Vendors>(context).vendors, id);
    var specialityItems = Provider.of<Vendors>(context, listen: false)
        .convertToMenuItemsSpeciality(vendorData.speciality)[0];
    var locationData =
        Provider.of<LocationDataProvider>(context, listen: true).userLocation;

    var lat = 0.0;
    var long = 0.0;

    if (locationData != null) {
      lat = locationData.latitude as double;
      long = locationData.longitude as double;
    }
    var vendorsFunction = Provider.of<Vendors>(context, listen: false);
    var distancecalculator = Provider.of<RoadNames>(context, listen: false);

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return InkWell(
          onTap: () {
            Navigator.of(context)
                .pushNamed(VendorScreenMain.routeName, arguments: id);
          },
          child: Container(
            height: 80,
            padding: const EdgeInsets.all(10.0),
            decoration: const BoxDecoration(
              // border: Border.all(width: 1),
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(5),
              ),
            ),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  height: 50.0,
                  width: 50.0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100.0),
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
                const SizedBox(
                  width: 10.0,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vendorData.nameVendor,
                      style: const TextStyle(
                        fontSize: 16.0,
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 2,
                    ),
                    Text(
                      specialityItems.menuItemName,
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.star_sharp,
                          color: Colors.amber,
                          size: 15.0,
                        ),
                        const SizedBox(
                          width: 2.0,
                        ),
                        Text(
                          '${vendorData.ratingVendor}',
                          style: const TextStyle(fontSize: 12.0),
                        ),
                        const SizedBox(
                          width: 20.0,
                        ),
                        const Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 15.0,
                        ),
                        const SizedBox(
                          width: 2.0,
                        ),
                        Text(
                          '${distancecalculator.calculateDistance(vendorData.latitude, vendorData.longitude, lat, long).toStringAsFixed(1)} km',
                          style: const TextStyle(fontSize: 12.0),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

/*
ListTile(
              // leading: CircleAvatar(
              //   backgroundImage: NetworkImage(vendorData.image),
              // ),
              title: Text(
                vendorData.nameVendor,
              ),
              subtitle: Text(specialityItems.menuItemName),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                //?Have to add more.
                children: <Widget>[
                  Text('Rating: ${vendorData.ratingVendor}'),
                  Text(
                    "Distance : ${distancecalculator.calculateDistance(vendorData.latitude, vendorData.longitude, locationData!.latitude, locationData.longitude).toStringAsFixed(2)} km",
                  ),
                ],
              ),
            ),
 */