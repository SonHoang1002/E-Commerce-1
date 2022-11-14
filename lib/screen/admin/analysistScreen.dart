import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:count_number/count_number.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:testecommerce/models/chart.dart';
import 'package:testecommerce/providers/general_provider.dart';

class Analysist extends StatefulWidget {
  const Analysist({super.key});

  @override
  State<Analysist> createState() => _AnalysistState();
}

late GeneralProvider _generalProvider;

class _AnalysistState extends State<Analysist> {
  late int _number = 0;
  late CountNumber _countNumber;
  late String totalRevenue = "120";

  late TooltipBehavior _tooltip;
  late List<ChartData> listData;
  late double maxHeight;

  @override
  void initState() {
    // Future<int> a = getTotalRevenueFromDB();
    // _countNumber = CountNumber(
    //   // springDescription: SpringDescription(),
    //   velocity: 40,
    //   endValue: int.parse(totalRevenue),
    //   onUpdate: (value) => setState(() => _number = value as int),
    // );
    listData = [
      ChartData('CHN', 12),
      ChartData('GER', 15),
      ChartData('RUS', 30),
      // ChartData('BRZ', 10),
      // ChartData('IND', 14)
    ];
    maxHeight = 40;

    _tooltip = TooltipBehavior(enable: true, duration: 6000);

    super.initState();
  }

  // @override
  // void dispose() {
  //   _countNumber.stop();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    _generalProvider = Provider.of<GeneralProvider>(context, listen: false);
    Future<int> x = _buildListData();

    /// generate listData
    Future<int> a = getTotalRevenueFromDB();
    // print("totalRevenue: ${totalRevenue}");
    // _countNumber = CountNumber(
    //   // springDescription: SpringDescription(),
    //   velocity: 40,
    //   endValue: int.parse(totalRevenue),
    //   onUpdate: (value) => setState(() => _number = value as int),
    //   // onDone: () => _number==200 ?
    // );
    // if (_number != 200) {
    //   _countNumber.start();
    // }
    // if (_number == 200) {
    //   _countNumber.stop();
    // }

    return Scaffold(
      appBar: AppBar(title: Text("Analysist")),
      body: Container(
        height: 700,
        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: ListView(
          children: [
            SizedBox(
              height: 20,
            ),
            Center(
              child: Text(
                "Total Revenue",
                style: TextStyle(fontSize: 30,color: Colors.green),
              ),
            ),
            Center(
                child: Text(
              // _number.toString(),
              totalRevenue,
              style: Theme.of(context).textTheme.headline1,
            )),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 400,
              width: double.infinity,
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                primaryYAxis:
                    NumericAxis(minimum: 0, maximum: maxHeight, interval: 10),
                tooltipBehavior: _tooltip,
                series: <ChartSeries<ChartData, String>>[
                  ColumnSeries(
                    dataSource: listData,
                    xValueMapper: (ChartData data, _) => data.x,
                    yValueMapper: (ChartData data, _) => data.y,
                    name: "abc",
                    color: Color.fromRGBO(100, 100, 100, 1),
                    dataLabelSettings: DataLabelSettings(
                        isVisible: true,
                        labelAlignment: ChartDataLabelAlignment.top),
                  ),
                  LineSeries(
                    dataSource: listData,
                    xValueMapper: (ChartData data, _) => data.x,
                    yValueMapper: (ChartData data, _) => data.y,
                    name: "Abc",
                    enableTooltip: true,
                    color: Colors.red,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<int> getTotalRevenueFromDB() async {
    QuerySnapshot<Object?> snapshot = await FirebaseFirestore.instance
        .collection("TotalRevenue")
        .doc("9EC0nIWg6Da6RaYG5cm8")
        .collection("tr")
        .get();
    snapshot.docs.forEach((element) {
      setState(() {
        totalRevenue = element["totalMoney"];
      });
    });
    return 1;
  }

  Future<int> _buildListData() async {
    // List<ChartData> list = [];
    QuerySnapshot<Object?> snapshot = await FirebaseFirestore.instance
        .collection("TotalRevenue")
        .doc("9EC0nIWg6Da6RaYG5cm8")
        .collection("analystProduct")
        // .doc("bMgdLeyriRz8LtdoWVOL")
        .get();
    late ChartData water, news, asia, featured, snack, drink, east;
    snapshot.docs.forEach((element) {
      water = ChartData("Water ", int.parse(element["Water"]));
      news = ChartData("News ", int.parse(element["New"]));
      asia = ChartData("Asia ", int.parse(element["Asia"]));
      featured = ChartData("Main ", int.parse(element["Featured"]));
      snack = ChartData("Snack ", int.parse(element["Snack"]));
      drink = ChartData("Drink ", int.parse(element["Drink"]));
      east = ChartData("Eastern ", int.parse(element["East"]));
    });

    setState(() {
      listData = [];
      listData.add(water);
      listData.add(news);
      listData.add(asia);
      listData.add(featured);
      listData.add(snack);
      listData.add(drink);
      listData.add(east);
    });
    int max = 0;
    for (int i = 0; i < listData.length; i++) {
      if (listData[i].y > max) {
        max = listData[i].y;
      }
    }
    setState(() {
      maxHeight = double.parse((max + 10).toString());
    });
    return 1;
  }
}
