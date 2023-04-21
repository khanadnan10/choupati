import 'dart:convert';
import 'dart:core';
import "package:geolocator/geolocator.dart";
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kaza_app/utils/constant.dart';
import '../providers/menu.dart';

class Vendor {
  //Field containing the IDs
  final String id;
  final String categoryID;

  // The Boolean Properties aka Filter
  final bool veg;
  final bool nonVeg; // To implement like button
  // To see whether the shop is open or not.
  // bool license; // Have license or not.

  // The Vendor Properties of name etc.
  final String nameVendor;
  final double avgPrice;
  final int phoneNumber;
  final double yearsInBusiness; // Can be months too so double.

  // Rating side - Figure out later the system
  // Int totalRating;
  //
  final double ratingVendor;
  final double ratingSpice;

  // Distance properties
  final double latitude;
  final double longitude;
  final String roadName;
  final String areaName;
  final String landmarkName;
  // Need to look for the road names

  //Preparing Stuff & Closing opening
  final int preparationTime;
  final int servingTime;
  final TimeOfDay openingTime;
  final TimeOfDay closingTime;

  //Setting the menu
  final menu;
  final speciality;

  //Images
  final String image;

  // parking and seating capacity
  final parking;
  final seating;
  final hygieneRating;
  //

  Vendor({
    required this.id,
    required this.categoryID,
    required this.nameVendor,
    required this.avgPrice,
    required this.phoneNumber,
    required this.yearsInBusiness,
    required this.ratingSpice,
    required this.ratingVendor,
    required this.latitude,
    required this.longitude,
    required this.preparationTime,
    required this.servingTime,
    required this.menu,
    required this.speciality,
    required this.openingTime,
    required this.closingTime,
    required this.veg,
    required this.nonVeg,
    required this.image,
    required this.roadName,
    required this.areaName,
    required this.landmarkName,
    this.parking,
    this.seating,
    this.hygieneRating,
  });
}

class Vendors with ChangeNotifier {
  final urlVendor = Uri.parse(urlVendorApi);

// This list will hold my vendors data, menu data and
  List<Vendor> _vendors = [];

  List<Vendor> get vendors => [..._vendors];

//Getting my vendors List.
  Future<void> getVendorList() async {
    List<Vendor> vendorData = [];
    try {
      final vendorListURL = Uri.parse(urlVendorlistApi);
      var responseVendorList = await http.get(vendorListURL);
      if (responseVendorList.statusCode == 200) {
        print('API CALL SUCCESSFULL: VENDOR PROVIDER');

        var decodedList =
            json.decode(responseVendorList.body) as Map<String, dynamic>;
        decodedList.forEach(
          (key, value) {
            vendorData.add(
              Vendor(
                id: value["vendorID"],
                categoryID: value["categoryID"],
                nameVendor: value["nameVendor"],
                avgPrice: value["avgPrice"],
                phoneNumber: value["phoneNumber"],
                yearsInBusiness: value["yearsInBusiness"],
                ratingSpice: value["ratingSpice"],
                ratingVendor: value["ratingVendor"],
                latitude: value["latitude"],
                longitude: value["longitude"],
                preparationTime: value["preparationTimeMinutes"],
                servingTime: value["servingTimeMinutes"],
                menu: value["menuItems"],
                speciality: value["specialityItems"],
                openingTime: TimeOfDay(
                    hour: value["openingTimeHour"],
                    minute: value["openingTimeMinutes"]),
                closingTime: TimeOfDay(
                    hour: value["closingTimeHour"],
                    minute: value["closingTimeMinutes"]),
                veg: value["veg"] == 0 ? false : true,
                nonVeg: value["nonVeg"] == 0 ? false : true,
                image: value["imageURL"],
                roadName: value["roadName"],
                areaName: value["areaName"],
                landmarkName: value["landmarkName"],
                seating: value["seatingCapacity"],
                parking: value["parking"],
                hygieneRating: value["hygieneRating"],
              ),
            );
          },
        );
      } else {
        print('API CALL ERROR: VENDOR PROVIDER');
      }

      setVendorsList(vendorData);
    } catch (e) {
      print(e.toString());
      throw 1;
    }
  }

  List<MenuItems> convertToMenuItems(List<dynamic> data) {
    return data
        .map((item) => MenuItems(
              vendorID: item['vendorID'],
              menuItemName: item['menuItemsName']?? "menuItem" ,

              price: double.tryParse(item['menuItemsPrice']) ?? 0.0,
            ))
        .toList();
    // }
  }

  List<MenuItems> convertToMenuItemsSpeciality(List<dynamic> data) {
    return data
        .map((item) => MenuItems(
              vendorID: item['vendorID'] ?? "",
              menuItemName: item['specialityItemName'] ?? "",
              price: double.tryParse(item['specialityItemPrice']) ?? 0.0,
            ))
        .toList();
    // }
  }

  double calculateDistance(double startLatitude, double startLongitude,
      double endLatitude, double endLongitude) {
    return Geolocator.distanceBetween(
        startLatitude, startLongitude, endLatitude, endLongitude);
  }

// Function to sort the vendor list by the closest location to user
  List<Vendor> sortByLocation(
      List<Vendor> vendors, double userLatitude, double userLongitude) {
    vendors.sort((a, b) {
      double distanceA = calculateDistance(
          userLatitude, userLongitude, a.latitude, a.longitude);
      double distanceB = calculateDistance(
          userLatitude, userLongitude, b.latitude, b.longitude);
      return distanceA.compareTo(distanceB);
    });
    return vendors;
  }

// sorting vendors by review.

  // return the list of vendors where vendors are only veg.
  List<Vendor> vegIsVeg(List<Vendor> listVendors) {
    List<Vendor> vegetarianVendors =
        listVendors.where((vendor) => vendor.veg).toList();
    return vegetarianVendors;
  }

  // return the list of vendors which are open or not.
  List<Vendor> openOrNot(List<Vendor> listVendors) {
    var now = DateTime.now();
    TimeOfDay currentTime = TimeOfDay(hour: now.hour, minute: now.minute);

    // Get the open vendors
    List<Vendor> openVendors = listVendors
        .where((vendor) =>
            vendor.openingTime.hour < currentTime.hour ||
            (vendor.openingTime.hour == currentTime.hour &&
                vendor.openingTime.minute <= currentTime.minute))
        .where((vendor) =>
            vendor.closingTime.hour > currentTime.hour ||
            (vendor.closingTime.hour == currentTime.hour &&
                vendor.closingTime.minute >= currentTime.minute))
        .toList();

    return openVendors;
  }

  // Sorting by price.
  List<Vendor> priceVendors(List<Vendors> listVendors) {
    List<Vendor> sortedVendors = List.from(listVendors);

    // Sort the vendors by their average price
    sortedVendors.sort((a, b) => a.avgPrice.compareTo(b.avgPrice));

    // Return the sorted list of vendors
    return sortedVendors;
  }

  // Getting the setters

  void setVendorsList(List<Vendor> listVendors) {
    _vendors = listVendors;
    notifyListeners();
  }

  Vendor findById(List<Vendor> listVendors, String vendorID) {
    Vendor vegetarianVendors =
        listVendors.where((vendor) => vendor.id == vendorID).first;
    return vegetarianVendors;
  }

  // Get the nearest road location.
  bool isShopOpen(Vendor vendor) {
    DateTime now = DateTime.now();
    DateTime date = DateTime.now();

    DateTime vendorOpeningTime = DateTime(
      date.year,
      date.month,
      date.day,
      vendor.openingTime.hour,
      vendor.openingTime.minute,
    );
    DateTime vendorClosingTime = DateTime(
      date.year,
      date.month,
      date.day,
      vendor.closingTime.hour,
      vendor.closingTime.minute,
    );
    return now.isAfter(vendorOpeningTime) && now.isBefore(vendorClosingTime);
  }

  Color getColorForRating(double rating) {
    if (rating > 3.5) {
      return Colors.green;
    } else if (rating > 2.5) {
      return Colors.yellow.shade700;
    } else {
      return Colors.red;
    }
  }

  Color getColorForOptions(bool isVeg, bool isNonVeg) {
    if (isVeg && isNonVeg) {
      return Colors.brown;
    } else if (isVeg) {
      return Colors.green;
    } else if (isNonVeg) {
      return Colors.red;
    } else {
      return Colors.grey;
    }
  }

  List<Vendor> findByRoadName(List<Vendor> listVendors, String roadName) {
    List<Vendor> roadNameVendors =
        listVendors.where((vendor) => vendor.roadName == roadName).toList();
    return roadNameVendors;
  }

  List<Vendor> findByAreaName(List<Vendor> listVendors, String areaName) {
    List<Vendor> areaNameVendors =
        listVendors.where((vendor) => vendor.areaName == areaName).toList();
    return areaNameVendors;
  }

  List<Vendor> findByLandmarkName(
      List<Vendor> listVendors, String landmarkName) {
    List<Vendor> areaNameVendors = listVendors
        .where((vendor) => vendor.landmarkName == landmarkName)
        .toList();
    return areaNameVendors;
  }

  List<Vendor> reviewsSorting(List<Vendor> listVendors) {
    List<Vendor> sortedVendors = List.from(listVendors);

    // Sort the vendors by their average price in descending order
    sortedVendors.sort((a, b) => b.ratingVendor.compareTo(a.ratingVendor));

    // Return the sorted list of vendors
    return sortedVendors;
  }

  String priceIndicator(double averagePrice) {
    if (averagePrice <= 50) {
      return "💰";
    } else if (averagePrice <= 100) {
      return "💰💰";
    } else if (averagePrice > 100) {
      return "💰💰💰";
    } else {
      return "Data Error";
    }
  }
}
