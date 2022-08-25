import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testecommerce/providers/category_provider.dart';
import 'package:testecommerce/providers/product_provider.dart';
import 'package:testecommerce/screen/cartscreen.dart';
import 'package:testecommerce/screen/detailscreen.dart';
import 'package:testecommerce/screen/homepage.dart';
import 'package:testecommerce/screen/listproduct.dart';
import 'package:testecommerce/screen/login.dart';
import 'package:testecommerce/screen/profile.dart';
import 'package:testecommerce/screen/welcomescreen.dart';
import './screen/signup.dart';
import './providers/category_provider.dart';
import 'models/product.dart';

void main() async {
  Provider.debugCheckInvalidValueType = null;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CategoryProvider>(
          create: (context) => CategoryProvider(),
        ),
        ChangeNotifierProvider<ProductProvider>(
          create: (context) => ProductProvider(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          primaryColor: Color(0xff746bc9),
          iconTheme: IconThemeData(color: Colors.black),
        ),
        debugShowCheckedModeBanner: false,
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            // if (snapshot.hasData) {
            //   print("HomePage() is called first");
            //   return HomePage();
            // } else {
            //   print("Login() is called first");
            //   return Login();
            // }
            return ProfileScreen();
          },
        ),
      ),
    );
  }
}

//       home: CartScreen(name:"body suit",price: 19.0,img: "i1.png",));

// Future<void> demo(BuildContext context) async {
//   CategoryProvider categoryProvider = Provider.of<CategoryProvider>(context);
//   await categoryProvider.getAsiaDish();
//   List<Product> list = categoryProvider.getListAsia();
//   print(list.length);
// }
