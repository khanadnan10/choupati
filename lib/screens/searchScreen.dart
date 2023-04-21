import 'package:flutter/material.dart';
import 'package:kaza_app/widget/searchTile.dart';
import 'package:provider/provider.dart';
import '../providers/vendors.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = '/Search-Screen';
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String? _searchQuery;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.arrow_back,
              ),
            ),
            elevation: 0,
            backgroundColor: Colors.white,
            title: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(
                    color: Colors.grey,
                  ),
                ),
                contentPadding: const EdgeInsets.all(10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(55.0),
                ),
                hintText: 'Search by name, menu items, speciality and more...',
                hintStyle: const TextStyle(color: Colors.grey),
              ),
            ),
          ),
          body: Consumer<Vendors>(
            builder: (ctx, vendorsData, _) {
              final filteredVendors = vendorsData.vendors.where((vendor) {
                final menuItems = vendorsData.convertToMenuItems(vendor.menu);
                final specialityItems =
                    vendorsData.convertToMenuItemsSpeciality(vendor.speciality);
                return _searchQuery == null ||
                    _searchQuery!.isEmpty ||
                    vendor.nameVendor
                        .toLowerCase()
                        .contains(_searchQuery!.toLowerCase()) ||
                    vendor.categoryID
                        .toLowerCase()
                        .contains(_searchQuery!.toLowerCase()) ||
                    menuItems.any((menu) => menu.menuItemName
                        .toLowerCase()
                        .contains(_searchQuery!.toLowerCase())) ||
                    specialityItems.any((item) => item.menuItemName
                        .toLowerCase()
                        .contains(_searchQuery!.toLowerCase())) ||
                    vendor.areaName
                        .toLowerCase()
                        .contains(_searchQuery!.toLowerCase()) ||
                    vendor.roadName
                        .toLowerCase()
                        .contains(_searchQuery!.toLowerCase()) ||
                    vendor.landmarkName
                        .toLowerCase()
                        .contains(_searchQuery!.toLowerCase()) ||
                    vendor.categoryID
                        .toLowerCase()
                        .contains(_searchQuery!.toLowerCase());
              }).toList();
              return ListView.builder(
                itemCount: filteredVendors.length,
                itemBuilder: (ctx, i) => SearchTile(filteredVendors[i].id),
              );
            },
          ),
        ),
      ),
    );
  }
}
