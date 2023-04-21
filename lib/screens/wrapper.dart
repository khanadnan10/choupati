import 'package:flutter/material.dart';
import 'package:kaza_app/providers/areaName.dart';
import 'package:kaza_app/providers/landmarkName.dart';
import 'package:provider/provider.dart';
import '../providers/auth/auth_provider.dart';
import '../providers/auth/auth_state.dart';
import '../providers/categories.dart';
import '../providers/location.dart';
import '../providers/roadName.dart';
import '../providers/vendors.dart';
import 'homeScreen.dart';
import 'signInPage.dart';
import 'locationScreen.dart';
import 'package:permission_handler/permission_handler.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  static const routeName = "//Wrapper-screen";

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  PermissionStatus _locationPermission = PermissionStatus.denied;

  @override
  void initState() {
    super.initState();
    getLocationPermission();
  }

  Future<void> getLocationPermission() async {
    final permission = await Permission.location.request();
    setState(() {
      _locationPermission = permission;
    });
  }

  Future<void> _startupManager(
    LocationDataProvider locationData,
    Vendors vendorData,
    RoadNames roadData,
    Categories categoryData,
    AreaNames areaData,
    LandmarkNames landmarkData,
  ) async {
    try {
      final listRoadNames = await roadData.getRoadData();
      roadData.setValues(listRoadNames);

      final listAreaNames = await areaData.getAreaData();
      areaData.setValues(listAreaNames);

      final landmarkValues = await landmarkData.getLandmarkData();
      landmarkData.setValues(landmarkValues);

      final categoryDataList = await categoryData.getCategoryData();
      categoryData.setCategoryValues(categoryDataList);

      vendorData.getVendorList();

      await locationData.getLocationPermission();
      print("LOCATION PERMISSION GRANTED");
      print("USER LOCATION SET");
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthProvider>().state;
    if (_locationPermission == PermissionStatus.denied ||
        _locationPermission == PermissionStatus.permanentlyDenied) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushNamed(context, LocationScreen.routeName);
      });
      return const SizedBox.shrink();
    } else if (_locationPermission == PermissionStatus.granted) {
      if (authState.authStatus == AuthStatus.authenticated) {
        _startupManager(
          Provider.of<LocationDataProvider>(context, listen: false),
          Provider.of<Vendors>(context, listen: false),
          Provider.of<RoadNames>(context, listen: false),
          Provider.of<Categories>(context, listen: false),
          Provider.of<AreaNames>(context, listen: false),
          Provider.of<LandmarkNames>(context, listen: false),
        );
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacementNamed(context, HomeScreen.routeName);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Location required to find street food nearby"),
              duration: Duration(seconds: 1, milliseconds: 30),
            ),
          );
        });
        return const SizedBox.shrink();
      } else if (authState.authStatus == AuthStatus.unauthenticated) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushNamed(context, SigninPage.routeName);
          print("SIGN");
        });
        return const SizedBox.shrink();
      }
    }
    return const CircularProgressIndicator();
  }
}
