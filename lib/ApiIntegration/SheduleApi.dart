import 'dart:convert';

import 'package:http/http.dart' as http;

const ReadUrl = 'http://www.nkrtest.xyz/public/api/schedule/';

class SheduleInfo {
  String day;
  String sheduleName;
  var sheduleVideo;
  String rips;
  String sets;
  String date;

  SheduleInfo({
    required this.date,
    required this.day,
    required this.rips,
    required this.sets,
    required this.sheduleName,
    required this.sheduleVideo,
  });
}

class BackEndServiceShedule {
  List<SheduleInfo> sheduleFromJson(String jsonString) {
    final data = json.decode(jsonString);
    List<SheduleInfo> sheduleInfo = [];
    try {
      for (int i = 0; i < 100; i++) {
        SheduleInfo _sheduleInfo = SheduleInfo(
          day: data["schedule"]["workouts"][i]["day_id"],
          date: data["schedule"]["start_date"],
          sheduleName: data["schedule"]["workouts"][i]["Wname"],
          sheduleVideo: data["schedule"]["workouts"][i]["Wvideo"],
          rips: data["schedule"]["workouts"][i]["rips"],
          sets: data["schedule"]["workouts"][i]["sets"],
        );
        sheduleInfo.add(_sheduleInfo);
      }
    } catch (e) {
      return sheduleInfo;
    }
    return sheduleInfo;
  }

  Future getSheduleDetails(int memberId) async {
    final response = await http.get(Uri.parse(ReadUrl + memberId.toString()));
    if (response.statusCode == 200) {
      List<SheduleInfo> list = sheduleFromJson(response.body);
      return list;
    } else {
      List<SheduleInfo> list = [];
      return list;
    }
  }
}
