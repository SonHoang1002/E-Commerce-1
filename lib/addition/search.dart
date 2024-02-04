
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testecommerce/providers/general_provider.dart';
import '../models/product.dart';
import '../widget/single_product.dart';

class Search extends SearchDelegate<void> {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = "";
          },
          icon: const Icon(Icons.close))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    GeneralProvider generalProvider = Provider.of<GeneralProvider>(context);
    List<Product> searchFeatureList = generalProvider.searchProductList(query);
    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: 0.8,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      children: searchFeatureList
          .map((e) =>
              SingleProduct(name: e.name, price: e.price, image: e.image,repo:e.repo))
          .toList(),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    throw UnimplementedError();
  }
}
