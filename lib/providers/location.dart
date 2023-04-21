import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationDataProvider with ChangeNotifier {
  Position? _userLocation;

  Position? get userLocation => _userLocation;

  Future<void> getLocationPermission() async {
    try {
      var serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw "SERVICE_NOT_ENABLED";
      }

      var permissionGranted = await Geolocator.checkPermission();
      if (permissionGranted == LocationPermission.denied) {
        permissionGranted = await Geolocator.requestPermission();
        if (permissionGranted != LocationPermission.whileInUse &&
            permissionGranted != LocationPermission.always) {
          throw "DENIED";
        }
      } else if (permissionGranted == LocationPermission.deniedForever) {
        throw "DENIED_FOREVER";
      }

      _userLocation = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
      );
      _setUserLocation(_userLocation);
    } catch (error) {
      rethrow;
    }
  }

  void _setUserLocation(Position? value) {
    _userLocation = value;
    notifyListeners();
  }

  LocationPermission _permissionStatus = LocationPermission.denied;

  LocationPermission get permissionStatus => _permissionStatus;

  Future<LocationPermission> checkPermission() async {
    var geolocator = Geolocator();
    var permissionStatus = await Geolocator.checkPermission();
    _permissionStatus = permissionStatus;
    notifyListeners();
    return permissionStatus;
  }
}
