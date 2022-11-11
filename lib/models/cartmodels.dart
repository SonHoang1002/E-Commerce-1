import 'package:flutter/material.dart';

class CartModel {
  late String name;
  late double price;
  late int quantity;
  late String img;
  late int repo;

  CartModel(
      {required this.name,
      required this.price,
      required this.img,
      required this.quantity,
      required this.repo});
}
