import 'package:flutter/material.dart';

class MenuItems extends StatelessWidget {
  static const routeName = '/Menu-Items';
  String menuItemName;
  double menuItemPrice;

  MenuItems(this.menuItemName, this.menuItemPrice, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          // border: Border.all(
          // color: Colors.orange,
          // ),
          // borderRadius: BorderRadius.circular(5.0),
          ),
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                menuItemName,
                style: const TextStyle(
                  // fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
              Text(
                '₹${menuItemPrice.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          const Divider()
        ],
      ),
    );
  }
}
