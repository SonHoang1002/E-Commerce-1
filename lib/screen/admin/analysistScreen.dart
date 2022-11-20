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
  Analysist({super.key, required this.cost});
  late double cost;
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
                style: TextStyle(fontSize: 30, color: Colors.grey[400]),
              ),
            ),
            Center(
                child: Tooltip(
              message: "Total Revenue",
              child: Text(
                // _number.toString(),
                totalRevenue,
                // style: Theme.of(context).textTheme.bodyMedium,
                style: TextStyle(fontSize: 40, color: Colors.green),
              ),
            )),
            // Container(child: Center(child: Text("Total Cost"),),),
            Center(
              child: Tooltip(
                message: "Total Cost",
                child: Text(
                  "${widget.cost}",
                  style: TextStyle(color: Colors.red, fontSize: 25),
                ),
              ),
            ),
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
                    name: "Column_Chart",
                    color: Color.fromRGBO(100, 100, 100, 1),
                    dataLabelSettings: DataLabelSettings(
                        isVisible: true,
                        labelAlignment: ChartDataLabelAlignment.top),
                  ),
                  LineSeries(
                    dataSource: listData,
                    xValueMapper: (ChartData data, _) => data.x,
                    yValueMapper: (ChartData data, _) => data.y,
                    name: "Line_Chart",
                    enableTooltip: true,
                    color: Colors.red,
                  )
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15.0),
              margin: EdgeInsets.fromLTRB(30, 30, 160, 30),
              decoration: BoxDecoration(
                  border: Border.all(
                color: Colors.blue,
              )),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildNotes("W", "Water Food"),
                  _buildNotes("N", "New Food"),
                  _buildNotes("A", "Asia Food"),
                  _buildNotes("M", "Main Food"),
                  _buildNotes("S", "Snack Food"),
                  _buildNotes("D", "Drink Food"),
                  _buildNotes("E", "Eastern Food"),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildNotes(String label, String word) {
    return Row(
      children: [
        Text(
          "$label : ",
          style: TextStyle(color: Colors.red),
        ),
        Text(
          word,
          style: TextStyle(color: Colors.green),
        )
      ],
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
      water = ChartData("W", int.parse(element["Water"]));
      news = ChartData("N", int.parse(element["New"]));
      asia = ChartData("A", int.parse(element["Asia"]));
      featured = ChartData("M", int.parse(element["Featured"]));
      snack = ChartData("S", int.parse(element["Snack"]));
      drink = ChartData("D", int.parse(element["Drink"]));
      east = ChartData("E", int.parse(element["East"]));
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
