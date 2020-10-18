import 'package:contest_notifier/long.dart';
import 'package:contest_notifier/running.dart';
import 'package:contest_notifier/upcomming.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List allList;
  List upcommingList = new List();
  List runningList = new List();
  List longList = new List();

  Future getData() async {
    String url = "https://www.kontests.net/api/v1/all";
    var rensponse = await http.get(url);
    setState(() {
      allList = json.decode(rensponse.body.toString());
      for (int i = 0; i < allList.length; i++) {
        if (allList[i]["site"].toString().toLowerCase() != "kick start") {
          if (allList[i]["status"].toString().toLowerCase() == "coding") {
            runningList.add(allList[i]);
          } else if (double.parse(allList[i]["duration"]).toInt() > 86400) {
            longList.add(allList[i]);
          } else {
            upcommingList.add(allList[i]);
          }
        }
      }

      // sorted long contest according to duration.
      for (int i = 0; i < longList.length - 1; i++) {
        for (int j = i + 1; j < longList.length; j++) {
          if (double.parse(longList[i]["duration"]).toInt() >
              double.parse(longList[j]["duration"]).toInt()) {
            var temp = longList[i];
            longList[i] = longList[j];
            longList[j] = temp;
          }
        }
      }

      // sorting running contest according to duration.
      for (int i = 0; i < runningList.length; i++) {
        for (int j = i + 1; j < runningList.length; j++) {
          if (double.parse(runningList[i]["duration"]).toInt() >
              double.parse(runningList[j]["duration"]).toInt()) {
            var temp = runningList[i];
            runningList[i] = runningList[j];
            runningList[j] = temp;
          }
        }
      }

      // sorting upcomming contest according to start time.
      for (int i = 0; i < upcommingList.length - 1; i++) {
        for (int j = i + 1; j < upcommingList.length; j++) {
          if (upcommingList[i]["start_time"]
                  .compareTo(upcommingList[j]["start_time"]) ==
              1) {
            var temp = upcommingList[i];
            upcommingList[i] = upcommingList[j];
            upcommingList[j] = temp;
          }
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    this.getData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.deepPurple,
            toolbarHeight: 70,
            bottom: TabBar(
              tabs: [
                Tab(
                  text: "Upcoming",
                ),
                Tab(
                  text: "Running",
                ),
                Tab(
                  text: "Long Contest",
                )
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Upcomming(upcommingList),
              Running(runningList),
              LongContest(longList),
            ],
          ),
        ),
      ),
    );
  }
}
