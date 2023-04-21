import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kaza_app/utils/constant.dart';

class LandmarkName {
  final String name;
  final double latitude;
  final double longitude;
  final String roadName;

  LandmarkName(this.name, this.latitude, this.longitude, this.roadName);
}

class LandmarkNames with ChangeNotifier {
  List<LandmarkName> _landmarkData = [];

  List<LandmarkName> get landmarkData => [..._landmarkData];

  String findNearestLandmark(
      List<LandmarkName> landmarks, double userLatitude, double userLongitude) {
    double nearestDistance = double.infinity;
    LandmarkName nearestLandmark = LandmarkName("", 0.0, 0.0, "");

    for (var landmark in landmarks) {
      double distance = calculateDistance(
          landmark.latitude, landmark.longitude, userLatitude, userLongitude);
      if (distance < nearestDistance) {
        nearestDistance = distance;
        nearestLandmark = landmark;
      }
    }
    return nearestLandmark.name;
  }

// This function calculates the distance between two sets of coordinates using the Haversine formula
  double calculateDistance(double landmarkLatitude, double landmarkLongitude,
      double userLatitude, double userLongitude) {
    var earthRadius = 6371; // radius of Earth in kilometers
    var lat1 = landmarkLatitude;
    var lon1 = landmarkLongitude;
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

  Future<List<LandmarkName>> getLandmarkData() async {
    try {
      List<LandmarkName> landmarkInsideObjects = [];
      final urlLandmarkName = Uri.parse(landMarkApi);
      var getData = await http.get(urlLandmarkName);
      Map<String, dynamic> extractedData = json.decode(getData.body);
      extractedData.forEach((key, landmarkObject) {
        landmarkInsideObjects.add(
          LandmarkName(
            landmarkObject["landmarkName"],
            landmarkObject["landmarkLatitude"],
            landmarkObject["landmarkLongitude"],
            landmarkObject["roadName"],
          ),
        );
      });
      return landmarkInsideObjects;
    } catch (e) {
      print(e.toString());
    }
    throw 'Landmark Name Exception';
  }

  void setValues(List<LandmarkName> listLandmarkName) {
    _landmarkData = listLandmarkName;
    notifyListeners();
  }
}
