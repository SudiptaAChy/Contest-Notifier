import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Running extends StatefulWidget {
  List myList;
  Running(this.myList);
  @override
  _RunningState createState() => _RunningState(myList);
}

class _RunningState extends State<Running> {
  List myList;
  _RunningState(this.myList);
  String getImageURL(String site) {
    String url = "images/";
    if (site.toLowerCase() == "codeforces")
      url += "cf.png";
    else if (site.toLowerCase() == "topcoder")
      url += "topcoder.png";
    else if (site.toLowerCase() == "atcoder")
      url += "atcoder_logo.png";
    else if (site.toLowerCase() == "cs academy")
      url += "cs.png";
    else if (site.toLowerCase() == "codechef")
      url += "cc.png";
    else if (site.toLowerCase() == "hackerrank")
      url += "hackerrank.png";
    else if (site.toLowerCase() == "hackerearth")
      url += "hackerearth.png";
    else if (site.toLowerCase() == "leetcode") url += "leetcode.png";
    return url;
  }

  String getTime(String utcTime) {
    String day = utcTime.substring(8, 10);
    String month = utcTime.substring(5, 7);
    String year = utcTime.substring(0, 4);
    int hour = int.parse(utcTime.substring(11, 13)) + 6;
    int miniute = int.parse(utcTime.substring(14, 16));
    String minitues = miniute.toString();
    if (minitues.length == 1) minitues = "0" + minitues;
    String midday = "AM";
    if (hour >= 24) {
      midday = "AM";
      hour -= 24;
    } else if (hour >= 12) {
      midday = "PM";
      hour -= 12;
    }
    String output = day +
        "-" +
        month +
        "-" +
        year +
        "    " +
        hour.toString() +
        ":" +
        minitues +
        " " +
        midday;
    return output;
  }

  String getDuration(String duration) {
    int value = double.parse(duration).toInt();
    int days = 0, hours = 0, minitue = 0;
    days = value ~/ 86400;
    value %= 86400;
    hours = value ~/ 3600;
    value %= 3600;
    minitue = value ~/ 60;
    String output = "";
    if (days != 0) output += days.toString() + "d : ";
    if (hours != 0) output += hours.toString() + "h : ";
    output += minitue.toString() + "mn";
    return output;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: (myList.length != null)
          ? ((myList.length != 0)
              ? ListView.builder(
                  itemCount: myList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      leading: Image.asset(
                          getImageURL(myList[index]["site"].toString())),
                      title: Text(myList[index]["name"]),
                      subtitle: Text(getTime(myList[index]["start_time"])),
                      trailing: Text(getDuration(myList[index]["duration"])),
                      onTap: () async {
                        if (await canLaunch(myList[index]["url"])) {
                          launch(myList[index]["url"]);
                        } else {
                          throw "Network Error!";
                        }
                      },
                    );
                  },
                )
              : Text("No Contests"))
          : Text("Loading..."),
    );
  }
}
