import 'package:flutter/material.dart';
import 'package:kaza_app/providers/vendors.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kaza_app/utils/constant.dart';

class Category {
  String id; // For the category id, for making database easier.
  String imageUrl; // For the image url
  String label; // for the category label

  Category({required this.id, required this.imageUrl, required this.label});
}

class Categories with ChangeNotifier {
  List<Category> _categories = [];

  // Setting up the categories getter.
  List<Category> get categories => [..._categories];

  // Setting up the filter function for category.
  List<Vendor> categoryFilter(List<Vendor> listVendors, String categoryID) {
    List<Vendor> categoryFilteredList =
        listVendors.where((vendor) => vendor.categoryID == categoryID).toList();
    return categoryFilteredList;
  }

  String getCategoryname(String id, List<Category> categoryList) {
    Category categoryLabelList = categoryList.where((c) => c.id == id).first;
    return categoryLabelList.label;
  }

  Future<List<Category>> getCategoryData() async {
    List<Category> categoryInsideObjects = [];
    await Future<void>.delayed(const Duration(seconds: 1));
    try {
      final urlCategoryName = Uri.parse(categoryNameApi);
      http.Response getData = await http.get(urlCategoryName);
      if (getData.statusCode == 200) {
        print('API CALL SUCCESSFULL: CATEGORIES PROVIDER');

        Map<String, dynamic> extractedData = json.decode(getData.body);
        extractedData.forEach((key, categoryData) {
          categoryInsideObjects.add(
            Category(
              id: categoryData["categoryid"],
              imageUrl: categoryData["categoryImageUrl"],
              label: categoryData["categoryLabel"],
            ),
          );
        });
      } else {
        print('API CALL UNSUCCESSFULL: CATEGORY PROVIDER');
      }
      return categoryInsideObjects;
    } catch (e) {
      throw 'Exception error: categories-getCategoryData';
    }
  }

  void setCategoryValues(List<Category> listCategoryName) {
    _categories = listCategoryName;
    notifyListeners();
  }

  Future<void> refresh() async {
    await getCategoryData();
    notifyListeners();
  }
}
