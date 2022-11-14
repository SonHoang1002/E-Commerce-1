import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:provider/provider.dart';
import 'package:simple_autocomplete_formfield/simple_autocomplete_formfield.dart';
import 'package:talkjs_flutter/talkjs_flutter.dart';
import 'package:testecommerce/gradient/gradient.dart';
import 'package:testecommerce/models/cartmodels.dart';
import 'package:testecommerce/models/chart.dart';
import 'package:testecommerce/providers/general_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import "package:syncfusion_flutter_charts/charts.dart";

import '../addition/pageRoute.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

List<CartModel> list = [
  CartModel(
      name: "a11",
      price: 23.4,
      img: "https://upload.jpg",
      quantity: 65,
      repo: 98),
  CartModel(name: "a111", price: 23.4, img: "abc.jpg", quantity: 6, repo: 98)
];

late GeneralProvider generalProvider;

class _TestScreenState extends State<TestScreen> {
  bool chatBoxVisible = false;
  String zero = "";
  int seconds = 590;
  late Timer timer;
  bool isExpired = false;
  @override
  void initState() {
    super.initState();
    // generalProvider = Provider.of<GeneralProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    generalProvider = Provider.of<GeneralProvider>(context, listen: false);

    return MaterialApp(
      title: 'TalkJS Demo',
      home: Scaffold(
          appBar: AppBar(
            title: const Text('TalkJS Demo'),
          ),
          body: Column(children: [
            Text(
              "${seconds}",
              style: TextStyle(fontSize: 25),
            ),
            Center(
              child: ElevatedButton(
                child: Text("Click"),
                onPressed: () {
                  // setCustomerAndTotalRevenue();
                  // updateRepo(list);
                  buildTimeOutForResetPassword();
                },
              ),
            ),
            Center(
              child: ElevatedButton(
                child: Text("Click"),
                onPressed: () {
                  // setCustomerAndTotalRevenue();
                  // updateRepo(list);
                  setState(() {
                    seconds = 600;
                  });
                },
              ),
            ),
            Center(
              child: ElevatedButton(
                child: Text("get TR"),
                onPressed: () {
                  generalProvider.setTotalRenenue();
                },
              ),
            ),
          ])),
    );
  }

  void buildTimeOutForResetPassword() {
    const perSecond = Duration(seconds: 1);
    timer = Timer.periodic(perSecond, (timer) {
      print("12323234");
      if (seconds == 0) {
        setState(() {
          timer.cancel();
        });
      } else {
        if (seconds == 0) {
          setState(() {
            seconds = 560;
          });
        } else {
          setState(() {
            seconds--;
          });
        }
      }
    });
  }

  Future<void> setCustomerAndTotalRevenue() async {
    await FirebaseFirestore.instance
        .collection("TotalRevenue")
        .doc("9EC0nIWg6Da6RaYG5cm8")
        .collection("bill")
        .add({
      "idUser": "123",
      "productList": ["a", "b", "c"],
      "money": "123"
    });
    print("add user to totalRevenue ok");
    String money = (double.parse("23.6") + 45.76).toString();

    await FirebaseFirestore.instance
        .collection("TotalRevenue")
        .doc("9EC0nIWg6Da6RaYG5cm8")
        .collection("tr")
        .doc("W5hd5BaRmYrhNAySeeq3")
        .update({"totalMoney": money});
    print("add bill to totalRevenue ok");
  }

  Future<void> updateRepo(List<CartModel> cartModelListToUpdateRepo) async {
    for (int i = 0; i < cartModelListToUpdateRepo.length; i++) {
      _ConnectAndUpdateCategoryCollection(
          "Drink", cartModelListToUpdateRepo[i]);
      _ConnectAndUpdateCategoryCollection(
          "AsiaDish", cartModelListToUpdateRepo[i]);
      _ConnectAndUpdateCategoryCollection(
          "Snack", cartModelListToUpdateRepo[i]);
      _ConnectAndUpdateCategoryCollection(
          "EastDish", cartModelListToUpdateRepo[i]);
      _ConnectAndUpdateCategoryCollection(
          "WaterDish", cartModelListToUpdateRepo[i]);
      _ConnectAndUpdateProductsCollection(
          "newachives", cartModelListToUpdateRepo[i]);
      _ConnectAndUpdateProductsCollection(
          "featuredproduct", cartModelListToUpdateRepo[i]);
    }
  }

  Future<void> _ConnectAndUpdateCategoryCollection(
      String collectionCategory, CartModel cartModel) async {
    QuerySnapshot<Object?> snapshot = await FirebaseFirestore.instance
        .collection("category")
        .doc("2n0DMzp0z2in1eLYBXHG")
        .collection(collectionCategory)
        .get();
    snapshot.docs.forEach((element) {
      if (element["category"] == cartModel.name) {
        FirebaseFirestore.instance
            .collection("category")
            .doc("2n0DMzp0z2in1eLYBXHG")
            .collection(collectionCategory)
            .doc(element.id)
            .update({
          "category": "${cartModel.name}",
          "image": "${cartModel.img}",
          "price": "${cartModel.price}",
          "repo": "${cartModel.repo - cartModel.quantity}"
        });
        print("${collectionCategory} update ${cartModel.name}");
      }
    });
  }

  Future<void> _ConnectAndUpdateProductsCollection(
      String collectionProducts, CartModel cartModel) async {
    QuerySnapshot<Object?> snapshot = await FirebaseFirestore.instance
        .collection("products")
        .doc("Yr4cg3K870i11VWoxx5q")
        .collection(collectionProducts)
        .get();
    snapshot.docs.forEach((element) {
      if (element["category"] == cartModel.name) {
        FirebaseFirestore.instance
            .collection("products")
            .doc("Yr4cg3K870i11VWoxx5q")
            .collection(collectionProducts)
            .doc(element.id)
            .update({
          "category": "${cartModel.name}",
          "image": "${cartModel.img}",
          "price": "${cartModel.price}",
          "repo": "${cartModel.repo - cartModel.quantity}"
        });
        print("${collectionProducts} update ${cartModel.name}");
      }
    });
  }
}

class ChartApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      home: _MyHomePage(),
    );
  }
}

class _MyHomePage extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  _MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<_MyHomePage> {
  late List<ChartData> data;
  late TooltipBehavior _tooltip;

  @override
  void initState() {
    data = [
      ChartData('CHN', 12),
      ChartData('GER', 15),
      ChartData('RUS', 30),
      ChartData('BRZ', 10),
      ChartData('IND', 14)
    ];
    _tooltip = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Syncfusion Flutter chart'),
        ),
        body: SfCartesianChart(
            primaryXAxis: CategoryAxis(),
            primaryYAxis: NumericAxis(minimum: 0, maximum: 40, interval: 10),
            tooltipBehavior: _tooltip,
            series: <ChartSeries<ChartData, String>>[
              ColumnSeries<ChartData, String>(
                  dataSource: data,
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y,
                  name: 'Gold',
                  color: Color.fromRGBO(8, 142, 255, 1)),
              LineSeries(
                  dataSource: data,
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y,
                  name: "Abc",
                  color: Color.fromRGBO(10, 100, 240, 1))
            ]));
  }
}


