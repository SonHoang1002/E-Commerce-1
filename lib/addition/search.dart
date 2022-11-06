import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:testecommerce/models/usermodel.dart';
import 'package:testecommerce/providers/general_provider.dart';
import 'package:testecommerce/providers/product_provider.dart';
import 'package:testecommerce/screen/homepage.dart';
import '../widget/cartsingleproduct.dart';


import '../models/product.dart';
import '../widget/singleproduct.dart';

class Search extends SearchDelegate<void> {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = "";
          },
          icon: Icon(Icons.close))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: Icon(Icons.arrow_back));
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
              SingleProduct(name: e.name, price: e.price, image: e.image))
          .toList(),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    throw UnimplementedError();
  }
}
