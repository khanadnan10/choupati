import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kaza_app/screens/categoryScreen.dart';
import 'package:shimmer/shimmer.dart';

class CategoryItem extends StatelessWidget {
  // Data we need for this.
  String imageUrl;
  String label;
  String id;

  // Initializer
  CategoryItem(this.imageUrl, this.label, this.id, {super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // Will be using the logic here.
      onTap: () {
        Navigator.of(context)
            .pushNamed(CategoryScreen.routeName, arguments: id);
      },
      child: Column(
        children: [
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100.0),
              color: Colors.white,
            ),
            padding: const EdgeInsets.all(5.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100.0),
              child: FittedBox(
                fit: BoxFit.cover,
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: Colors.grey,
                    highlightColor: Colors.grey.shade300,
                    child: const Image(
                      color: Colors.white,
                      image: AssetImage(
                        'lib/assets/images/kaza-logo.png',
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => const Icon(
                    Icons.restaurant,
                    size: 5.0,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 6,
          ),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
