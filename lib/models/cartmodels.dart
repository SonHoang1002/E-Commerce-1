import 'package:flutter/material.dart';


class CartModel {
  late String name;
  late double price;
  late int quantity;
  late String img;

   CartModel(
      {required this.name,
      required this.price,
      required this.img,
      required this.quantity});

}