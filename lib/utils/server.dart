import 'dart:convert';
import 'package:adams/models/student.dart';
import 'package:http/http.dart' as http;

const baseUrl = "http://192.168.29.95:5000";

Future getUuid(StudentData student) async {
  const base = "$baseUrl/get-student-uuid";
  var url =
      '$base/${student.year}/${student.department}/${student.section}/${student.email}';

  try {
    return await http.get(Uri.parse(url));
  } catch (e) {
    print(e);
  }
}

Future verify(StudentData student) async {
  const base = "$baseUrl/pp-status-verify";

  while (true) {
    await Future.delayed(const Duration(seconds: 3));
    var url =
    '$base/${student.year}/${student.department}/${student.section}/${student.email}';

    try {
      var response = await http.get(Uri.parse(url));
      print(response.body);
      if (response.body == "true") return;
    } catch (e) {
      print(e);
    }
  }
}

Future postNearbyDevices(List<Map> nearby, StudentData student) async {
  var base = "$baseUrl/pp-verify";
  var url =
  '$base/${student.year}/${student.department}/${student.section}';

  await http.post(Uri.parse(url),
      headers: {"Content-type": "application/json"},
      body: jsonEncode(nearby));
}