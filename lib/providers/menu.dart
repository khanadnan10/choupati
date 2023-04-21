import 'package:flutter/material.dart';

class MenuItems {
  // This id should be matching to the vendor one.
  String vendorID;
  String menuItemName;
  double price;

  //Things not a priority now
  String? imageUrl;
  String? menuCategory;
  double? ratingItem;
  String? description;
  String? categoryid;

// Setting up the initializers
  MenuItems({
    required this.vendorID,
    required this.menuItemName,
    required this.price,
  });
}

class Menu with ChangeNotifier {
  final List<MenuItems> _menu = [];

  // Setting up the getter.
  List<MenuItems> get menu => _menu;

  // List<MenuItems> convertList(List<Map<String, dynamic>> value){

}
