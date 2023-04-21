import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kaza_app/utils/constant.dart';

class AreaName {
  final String name;
  final double latitude;
  final double longitude;

  AreaName(this.name, this.latitude, this.longitude);
}

class AreaNames with ChangeNotifier {
  List<AreaName> _areaData = [];

  List<AreaName> get areaData => [..._areaData];

  String findNearestArea(
      List<AreaName> areas, double userLatitude, double userLongitude) {
    double nearestDistance = double.infinity;
    AreaName nearestArea = AreaName("", 0.0, 0.0);

    for (var area in areas) {
      double distance = calculateDistance(
          area.latitude, area.longitude, userLatitude, userLongitude);
      if (distance < nearestDistance) {
        nearestDistance = distance;
        nearestArea = area;
      }
    }
    return nearestArea.name;
  }

// This function calculates the distance between two sets of coordinates using the Haversine formula
  double calculateDistance(double AreaLatitude, double AreaLongitude,
      double userLatitude, double userLongitude) {
    var earthRadius = 6371; // radius of Earth in kilometers
    var lat1 = AreaLatitude;
    var lon1 = AreaLongitude;
    var lat2 = userLatitude;
    var lon2 = userLongitude;
    var latDiff = (lat2 - lat1) * pi / 180;
    var lonDiff = (lon2 - lon1) * pi / 180;
    var a = sin(latDiff / 2) * sin(latDiff / 2) +
        cos(lat1 * pi / 180) *
            cos(lat2 * pi / 180) *
            sin(lonDiff / 2) *
            sin(lonDiff / 2);
    var c = 2 * atan2(sqrt(a), sqrt(1 - a));
    var distance = earthRadius * c;
    return distance.toDouble();
  }

  // Getting the area list.
  // Posting data for areas.

  Future<List<AreaName>> getAreaData() async {
    try {
      List<AreaName> AreaInsideObjects = [];
      final urlAreaName = Uri.parse(areaNameApi);
      var getData = await http.get(urlAreaName);
      Map<String, dynamic> extractedData = json.decode(getData.body);
      extractedData.forEach((key, AreaObject) {
        AreaInsideObjects.add(
          AreaName(
            AreaObject["areaName"],
            AreaObject["areaLatitude"],
            AreaObject["areaLongitude"],
          ),
        );
      });
      return AreaInsideObjects;
    } catch (e) {
      throw "Area Name Exception";
    }
  }

  void setValues(List<AreaName> listAreaName) {
    _areaData = listAreaName;
    notifyListeners();
  }
}
