import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kaza_app/utils/constant.dart';

class RoadName {
  final String name;
  final double latitude;
  final double longitude;

  RoadName(this.name, this.latitude, this.longitude);
}

class RoadNames with ChangeNotifier {
  List<RoadName> _roadData = [];

  List<RoadName> get roadData => [..._roadData];

  String findNearestRoad(
      List<RoadName> roads, double userLatitude, double userLongitude) {
    double nearestDistance = double.infinity;
    RoadName nearestRoad = RoadName("", 0.0, 0.0);

    for (var road in roads) {
      double distance = calculateDistance(
          road.latitude, road.longitude, userLatitude, userLongitude);
      if (distance < nearestDistance) {
        nearestDistance = distance;
        nearestRoad = road;
      }
    }
    return nearestRoad.name;
  }

// This function calculates the distance between two sets of coordinates using the Haversine formula
  double calculateDistance(double roadLatitude, double roadLongitude,
      double userLatitude, double userLongitude) {
    var earthRadius = 6371; // radius of Earth in kilometers
    var lat1 = roadLatitude;
    var lon1 = roadLongitude;
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

  // Getting the road list.
  // Posting data for roads.

  Future<List<RoadName>> getRoadData() async {
    try {
      List<RoadName> roadInsideObjects = [];
      final urlRoadName = Uri.parse(roadNameApi);
      var getData = await http.get(urlRoadName);
      if (getData.statusCode == 200) {
        print('API CALL SUCCESSFULL: ROADNAME PROVIDER');
        Map<String, dynamic> extractedData = json.decode(getData.body);
        extractedData.forEach((key, roadObject) {
          roadInsideObjects.add(
            RoadName(
              roadObject["roadName"],
              roadObject["roadLatitude"],
              roadObject["roadLongitude"],
            ),
          );
        });
      } else {
        print('API CALL ERROR: ROADNAME PROVIDER');
      }
      return roadInsideObjects;
    } catch (e) {
      print(e.toString());
    }
    throw 'Road Name Exception';
  }

  void setValues(List<RoadName> listRoadname) {
    _roadData = listRoadname;
    notifyListeners();
  }
}
