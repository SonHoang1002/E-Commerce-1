import 'package:flutter/material.dart';
import 'package:badges/badges.dart';
import 'package:provider/provider.dart';
import 'package:testecommerce/providers/product_provider.dart';

class NotificationButton extends StatefulWidget {
  const NotificationButton({Key? key}) : super(key: key);

  @override
  State<NotificationButton> createState() => _NotificationButtonState();
}

late ProductProvider productProvider;

class _NotificationButtonState extends State<NotificationButton> {
  @override
  Widget build(BuildContext context) {
    productProvider = Provider.of<ProductProvider>(context);


    return Badge(
        position: BadgePosition(top: 8, start: 25),
        badgeContent: Text(productProvider.getNotiListlength.toString()),
        child: IconButton(
          icon: Icon(
            Icons.notifications,
            color: Colors.black,
          ),
          onPressed: () {},
        ));
  }
}
