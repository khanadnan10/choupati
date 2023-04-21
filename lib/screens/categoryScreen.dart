import 'package:flutter/material.dart';
import 'package:kaza_app/providers/likeModelProvider.dart';
import 'package:kaza_app/widget/topBar.dart';
import 'package:kaza_app/widget/vendorCardSmall.dart';
import 'package:provider/provider.dart';
import '../providers/categories.dart';
import '../providers/vendors.dart';

class CategoryScreen extends StatelessWidget {
  static const routeName = '/category-screen';
  String id;
  CategoryScreen(this.id);

  // The category Screen will have location and category wise lists.
  @override
  Widget build(BuildContext context) {
    var categoriesItemsFunctions =
        Provider.of<Categories>(context, listen: false);
    List<Vendor> vendorDataFunctions =
        Provider.of<Vendors>(context, listen: false).vendors;
    var categoryItemsList =
        categoriesItemsFunctions.categoryFilter(vendorDataFunctions, id);

    // Setting the main category list.
    return Container(
      // Giving the safe area a color of white.
      color: Colors.white,
      // Keeping the things in safe area.
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
              title: Text(
                categoriesItemsFunctions.getCategoryname(
                    id, categoriesItemsFunctions.categories),
              ),
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )),
          body: Container(
            padding: const EdgeInsets.all(2),
            child: Column(
              children: [
                // TopBar(),
                //? This container will contain the grid view builder.
                //

                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      mainAxisExtent: 250,
                    ),
                    itemBuilder: (context, index) {
                      return Consumer<LikesModel>(
                        builder: (context, likesModel, child) {
                          final isLiked = likesModel
                              .isLiked(categoryItemsList[index].id.toString());
                          return VendorCardSmall(
                              index.toString(),
                              categoryItemsList[index].id.toString(),
                              isLiked,
                              likesModel);
                        },
                      );
                    },
                    itemCount: categoryItemsList.length,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
