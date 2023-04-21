import 'package:flutter/material.dart';

class Filter {
  String filterName;
  IconData filterIcon;
  Color filterColor;

  Filter(
      {required this.filterName,
      required this.filterIcon,
      this.filterColor = Colors.black87});
}

// Remember this class will hold the Provider and the filter data.
class Filters with ChangeNotifier {
  var priceFilter = false;
  var openCloseFilter = false;
  var vegNonVegFilter = false;
  final List<Filter> _filters = [
    Filter(
      filterIcon: Icons.arrow_upward,
      filterName: "Price Sort",
    ),
    Filter(filterIcon: Icons.lock_open, filterName: "Open"),
    Filter(filterIcon: Icons.star, filterName: "Ratings Sort"),
    Filter(
      filterIcon: Icons.circle,
      filterName: "Veg",
      filterColor: Colors.green[900] as Color,
    ),
  ];

  List<Filter> get filters => [..._filters];

  void changeboolvalue(bool filtervalues) {
    filtervalues = !filtervalues;
    notifyListeners();
  }
}
