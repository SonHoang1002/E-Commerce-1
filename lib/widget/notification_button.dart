import 'package:flutter/material.dart';
import 'package:badges/badges.dart';
import 'package:provider/provider.dart';
import 'package:testecommerce/providers/general_provider.dart';
import 'package:testecommerce/providers/product_provider.dart';
import 'package:testecommerce/screen/notification.dart';

class NotificationButton extends StatefulWidget {
  const NotificationButton({Key? key}) : super(key: key);

  @override
  State<NotificationButton> createState() => _NotificationButtonState();
}

//late ProductProvider productProvider;
late GeneralProvider generalProvider;

class _NotificationButtonState extends State<NotificationButton> {
  @override
  Widget build(BuildContext context) {
    generalProvider = Provider.of<GeneralProvider>(context);

    return Badge(
        position: BadgePosition(top: 8, start: 25),
        badgeContent: Text(generalProvider.getNotiListlength.toString()),
        child: IconButton(
          icon: Icon(
            Icons.notifications,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => NotificationMessage()));
          },
        ));
  }
}
