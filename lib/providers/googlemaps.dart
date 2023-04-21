import 'package:flutter/material.dart';
import 'package:maps_launcher/maps_launcher.dart';

class MapUtils with ChangeNotifier {
  Future<void> openMap(double latitude, double longitude) async {
    MapsLauncher.launchCoordinates(latitude, longitude);
  }
}
