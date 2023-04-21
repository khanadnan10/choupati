import 'package:flutter/material.dart';
import 'package:kaza_app/widget/filterChips.dart';
import 'package:kaza_app/widget/navigationBar.dart';
import 'package:kaza_app/widget/vendorCardLarge.dart';
import 'package:share_plus/share_plus.dart';
import '../providers/vendors.dart';
import 'package:provider/provider.dart';
import '../providers/googleMaps.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widget/menuItems.dart';

class VendorScreenMain extends StatelessWidget {
  static const routeName = '/Vendor-Screen';
  String id;
  VendorScreenMain(this.id);

  @override
  Widget build(BuildContext context) {
    Vendor vendorData = Provider.of<Vendors>(context, listen: false)
        .findById(Provider.of<Vendors>(context).vendors, id);
    var vendorsDataMenu = Provider.of<Vendors>(context, listen: false)
        .convertToMenuItems(vendorData.menu);
    var googlemapsFunctions = Provider.of<MapUtils>(context);
    return Scaffold(
      bottomNavigationBar: NavigationBarBottom(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        // title: const Text(""),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            VendorLarge(id),
            const SizedBox(
              height: 8,
            ),

            Container(
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
              height: 48,
              // width: double.infinity,
              child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                // mainAxisSize: MainAxisSize.max,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //? The Direction Button.
                  GestureDetector(
                    onTap: () {
                      googlemapsFunctions.openMap(
                        vendorData.latitude,
                        vendorData.longitude,
                      );
                    },
                    child: FilterChips(
                      filterIcon: Icons.directions,
                      filterName: "Directions",
                      filterColor: Colors.black,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      launch("tel://${vendorData.phoneNumber}");
                    },
                    child: FilterChips(
                      filterIcon: Icons.phone_android,
                      filterName: "Contact",
                      filterColor: Colors.black,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Share.share(
                          "Vendor Name : ${vendorData.nameVendor}\nAverage Price : ${vendorData.avgPrice}\nLocation : https://www.google.com/maps/search/?api=1&query=${vendorData.latitude},${vendorData.longitude}");
                    },
                    child: FilterChips(
                      filterIcon: Icons.share,
                      filterName: "Share",
                      filterColor: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              thickness: 2,
            ),
            const Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Menu',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),

            const SizedBox(
              height: 10.0,
            ),
            //? This is for the menu
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: MenuItems(
                    vendorsDataMenu[index].menuItemName,
                    vendorsDataMenu[index].price,
                  ),
                ),
                itemCount: vendorsDataMenu.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
