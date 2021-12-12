import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class CovidReport extends StatefulWidget {
  const CovidReport({Key? key}) : super(key: key);

  @override
  _CovidReportState createState() => _CovidReportState();
}

class _CovidReportState extends State<CovidReport> {
  late int new_case,
      total_case,
      new_death,
      total_death,
      new_recovered,
      total_recovered;
  late String txn_date;

  bool isLoading = true;

  _assignValue(Map<String, dynamic> json) async {
    new_case = await json['new_case'];
    total_case = await json['total_case'];
    new_death = await json['new_death'];
    total_death = await json['total_death'];
    new_recovered = await json['new_recovered'];
    total_recovered = await json['total_recovered'];
    txn_date = await json['txn_date'];
  }

  _getCovidData() async {
    final response = await http.get(
        Uri.parse("https://covid19.ddc.moph.go.th/api/Cases/today-cases-all"));

    if (response.body.isNotEmpty || response.statusCode == 200) {
      for (var datas in json.decode(response.body) as List) {
        _assignValue(datas);
      }
    } else {
      print("data is Empty or error");
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  late List<_SalesData> covidPlot = [
    _SalesData('ติดเชื้อทั้งหมด', total_case),
    _SalesData('เสียชีวิตทั้งหมด', total_death),
    _SalesData('รายใหม่วันนี้', new_case),
    _SalesData('เสียชีวิตวันนี้', new_death),
    _SalesData('รักษาแล้วทั้งหมด', new_recovered),
    _SalesData('รักษาแล้ววันนี้', total_recovered)
  ];

  Widget PrimaryTitle(String title, double l, double t, double r, double b) {
    return Container(
      margin: EdgeInsets.fromLTRB(l, t, r, b),
      decoration: const BoxDecoration(
          border: Border(
        left: BorderSide(width: 5, color: Color(0xffabd8ed)),
      )),
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Text(title,
              style: TextStyle(color: Color(0xffabd8ed), fontSize: 20)),
        ),
      ),
    );
  }

  Widget PrimaryRecordBoxes(
    String title,
    Color color,
    double titleSize,
    double contentHeight,
    double numberSize,
    dynamic data,
    double top,
    double bottom
  ) {
    return Expanded(
      flex: 20,
      child: Container(
        margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(10)),
        width: double.infinity,
        height: contentHeight,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        title,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: titleSize,
                            fontWeight: FontWeight.bold),
                      )),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, top, 0, bottom),
                    alignment: Alignment.center,
                    child: Text(data.toString(),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: numberSize,
                            fontWeight: FontWeight.bold)),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    child: const Text("ราย",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    _getCovidData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: isLoading
          ? CircularProgressIndicator()
          : RefreshIndicator(
              onRefresh: () => _getCovidData(),
              color: const Color(0xffabd8ed),
              backgroundColor: const Color(0xff181818),
              child: ListView(
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 5, 15, 15),
                        child: Column(
                          children: [
                            /*Container(
                              alignment: Alignment.bottomRight,
                              child:myCountry(),
                            ),*/
                            PrimaryTitle(
                                "สถานการณ์ผู้ติดเชื้อ COVID-19 อัพเดทรายวัน "+txn_date,
                                0,
                                0,
                                0,
                                10),
                            Row(
                              children: [
                                PrimaryRecordBoxes(
                                    "รายใหม่วันนี้",
                                    Colors.purple.shade300,
                                    14,
                                    100,
                                    20,
                                    new_case,13,8),
                                Spacer(),
                                PrimaryRecordBoxes("เสียชีวิตแล้ววันนี้",
                                    Colors.grey, 12, 100, 20, new_death,13,8),
                                Spacer(),
                                PrimaryRecordBoxes("รักษาแล้ววันนี้",
                                    Colors.blue, 12, 100, 20, new_recovered,13,8)
                              ],
                            ),
                            Row(
                              children: [
                                PrimaryRecordBoxes("ติดเชื้อทั้งหมด",
                                    Colors.orange, 17, 130, 30, total_case,17,17),
                                Spacer(),
                                PrimaryRecordBoxes("เสียชีวิตแล้วทั้งหมด",
                                    Colors.red, 14, 130, 30, total_death,17,17)
                              ],
                            ),
                            Row(
                              children: [
                                PrimaryRecordBoxes("รักษาแล้วทั้งหมด",
                                    Colors.green, 14, 100, 25, total_recovered,11,0)
                              ],
                            ),
                          ],
                        ),
                      ),
                      PrimaryTitle("ข้อมูลกราฟ", 16, 5, 16, 5),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 15, 0, 35),
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20.0),
                            topLeft: Radius.circular(20.0),
                            bottomRight: Radius.circular(20.0),
                            bottomLeft: Radius.circular(20.0),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.topLeft,
                                child: const Text("Records",
                                    style: TextStyle(
                                        fontSize: 17,
                                        color: Color(0xff181818),
                                        fontWeight: FontWeight.bold)),
                              ),
                              SfCartesianChart(
                                  primaryXAxis: CategoryAxis(),
                                  // Chart title
                                  title: ChartTitle(
                                      text: 'Covid 19 Thailand analysis'),
                                  tooltipBehavior:
                                      TooltipBehavior(enable: true),
                                  series: <ChartSeries<_SalesData, String>>[
                                    LineSeries<_SalesData, String>(
                                        dataSource: covidPlot,
                                        xValueMapper: (_SalesData sales, _) =>
                                            sales.year,
                                        yValueMapper: (_SalesData sales, _) =>
                                            sales.sales,
                                        name: 'People',
                                        // Enable data label
                                        dataLabelSettings:
                                            DataLabelSettings(isVisible: true))
                                  ]),
                              Container(
                                height: 10,
                              )
                            ],
                          ),
                        ),
                      ),
                      
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}

class _SalesData {
  _SalesData(this.year, this.sales);

  final String year;
  final int sales;
}
