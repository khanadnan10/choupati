import 'package:flutter/material.dart';

class FilterChips extends StatelessWidget {
  IconData filterIcon;
  String filterName;
  Color filterColor;

  FilterChips({
    required this.filterIcon,
    required this.filterName,
    required this.filterColor,
  });

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        // height: 48,
        decoration: BoxDecoration(
          border: Border.all(
            width: 0.5,
            color: Colors.black87,
          ),
          borderRadius: BorderRadius.circular(30.0),
        ),
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            // Now we have to make this dynamic
            Icon(
              filterIcon,
              size: 20,
              color: filterColor,
            ),
            const SizedBox(
              width: 8,
            ),
            Text(
              filterName,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
