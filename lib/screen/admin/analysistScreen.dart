import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:count_number/count_number.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:testecommerce/models/chart.dart';

class Analysist extends StatefulWidget {
  const Analysist({super.key});

  @override
  State<Analysist> createState() => _AnalysistState();
}

class _AnalysistState extends State<Analysist> {
  late int _number = 0;
  late CountNumber _countNumber;
  late String totalRevenue = "120";

  late TooltipBehavior _tooltip;
  late List<ChartData> listData;

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
      ChartData('BRZ', 6.4),
      ChartData('IND', 14)
    ];
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
                style: TextStyle(fontSize: 30),
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
                    NumericAxis(minimum: 0, maximum: 40, interval: 10),
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
}
