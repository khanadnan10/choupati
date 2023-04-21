import 'package:flutter/material.dart';

class NavBarChildren extends StatelessWidget {
  IconData iconData;
  String label;
  NavBarChildren(this.iconData, this.label);

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(iconData),
          const SizedBox(
            height: 2,
          ),
          Text(label),
        ],
      ),
    );
  }
}
