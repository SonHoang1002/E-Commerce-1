import 'package:flutter/material.dart';
import 'package:badges/badges.dart';
import 'package:provider/provider.dart';
import 'package:testecommerce/providers/product_provider.dart';
import 'package:testecommerce/screen/notification_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

late ProductProvider productProvider;

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      backgroundColor: Color(0xfff8f8f8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          NotificationButton(),
        ],
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              height: 120,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CircleAvatar(
                    maxRadius: 60,
                    backgroundImage: NetworkImage(
                        "https://scontent.fhan2-4.fna.fbcdn.net/v/t1.6435-9/203063561_108326058170068_6656793944407315036_n.jpg?_nc_cat=104&ccb=1-7&_nc_sid=09cbfe&_nc_ohc=JL4XcaY8Kr8AX_C2foH&_nc_ht=scontent.fhan2-4.fna&oh=00_AT_xEYOqC4RzWAcgtHLMxTD9ata6kzl_qaRxlvQRZcQRog&oe=632E61CE"),
                  ),
                ],
              ),
            ),
            Container(
              height: 300,
              width: double.infinity,
              color: Colors.blue,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: 40,
                    width: double.infinity,decoration: BoxDecoration(
                      color:Colors.red,
                      borderRadius: BorderRadius.circular(20)
                    ),
                  ),
                  Container(
                    height: 40,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  Container(
                    height: 40,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  Container(
                    height: 40,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20)),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
