import 'package:flutter/material.dart';
import 'package:kaza_app/screens/searchScreen.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    // Search Bar will be Textfield.
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(SearchScreen.routeName);
      },
      child: Container(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              offset: Offset(2, 6),
              blurRadius: 30,
              color: Colors.black12,
            ),
          ],
        ),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: TextField(
          enabled: false,
          textCapitalization: TextCapitalization.words,
          keyboardType: TextInputType.text,
          // On changed & other have to implement the logic part here.
          // Logic part here.
          onChanged: (value) {},
          // See the ram consumption of Input Decoration
          decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 3, color: Colors.greenAccent),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                25.0,
              ),
              borderSide: const BorderSide(
                color: Colors.white,
              ),
            ),
            prefixIcon: Icon(
              Icons.search,
              color: Theme.of(context).primaryColor,
              size: 28,
            ),
            hintText: "Search Street Food",
          ),
        ),
      ),
    );
  }
}
