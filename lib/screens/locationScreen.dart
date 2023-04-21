import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:kaza_app/screens/wrapper.dart';
import 'package:location/location.dart';
import '../providers/location.dart';
import 'package:provider/provider.dart';

class LocationScreen extends StatelessWidget {
  const LocationScreen({Key? key}) : super(key: key);
  static const routeName = "//Location-Screen";

  Future<void> _showLocationError(BuildContext context, String message) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Location Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Open Settings'),
              onPressed: () {
                AppSettings.openLocationSettings();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleLocationError(BuildContext context, dynamic error) {
    String message;
    if (error == 'DENIED') {
      message =
          'Location permission was denied. Please enable location permissions in your device settings to continue.';
    } else if (error == 'DENIED_FOREVER') {
      message =
          'Location permission was permanently denied. Please enable location permissions in your device settings to continue.';
    } else if (error == 'MOCK_LOCATION') {
      message =
          'Your device is reporting mock location data. Please disable mock locations in your device settings to continue.';
    } else if (error == 'SERVICE_NOT_ENABLED') {
      message =
          'Location services are not enabled. Please enable location services in your device settings to continue.';
    } else {
      message =
          'An error occurred while getting your location. Please try again later or check your device settings.';
    }
    return _showLocationError(context, message);
  }

  @override
  Widget build(BuildContext context) {
    var location = Provider.of<LocationDataProvider>(context, listen: false);
    return Scaffold(
      body: Center(
        child: Consumer<LocationDataProvider>(builder: (BuildContext context,
            LocationDataProvider location, Widget? child) {
          if (location.permissionStatus == PermissionStatus.granted) {
            Navigator.of(context).pushNamed(Wrapper.routeName);
            return Container();
          } else {
            return OutlinedButton(
              child: const Text("Location Permission"),
              onPressed: () {
                location.getLocationPermission().then((_) {
                  Navigator.of(context).pushReplacementNamed(Wrapper.routeName);
                }).catchError((e) async {
                  await _handleLocationError(context, e);
                });
              },
            );
          }
        }),
      ),
    );
  }
}
