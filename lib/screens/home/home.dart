import "package:adams/models/student.dart";
import "package:adams/services/auth.dart";
import "package:adams/services/database.dart";
import "package:adams/shared/loading.dart";
import "package:adams/utils/datetime.dart";
import "package:firebase_database/firebase_database.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

import 'package:adams/services/advertise.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final student = Provider.of<StudentData?>(context);

    DatabaseReference portalStateRef = FirebaseDatabase.instance
        .ref("${student?.year}/${student?.department}/${student?.section}");
    final db = DatabaseService(sid: student?.sid);

    if (student != null) {
      final text = "Welcome ${student.name}";
      return Scaffold(
        appBar: AppBar(
          title: const Text("ADAMS"),
          actions: [
            ElevatedButton(
              onPressed: () {
                _auth.signOut();
              },
              child: const Text("Logout"),
            )
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                text,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                ),
              ),
              FutureBuilder(
                future: db.getCurrentHourDetails(
                    "${student.year}/${student.department}/${student.section}"),
                initialData: "",
                builder: (context, snapshot) {
                  return Text(
                    snapshot.hasData &&
                            snapshot.data.runtimeType is Map<String, dynamic>
                        ? "Current Hour: ${snapshot.data["name"]}"
                        : "Current Hour: Nil",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                    ),
                  );
                },
              ),
              StreamBuilder(
                stream: portalStateRef.onValue,
                builder: (context, snapshot) {
                  final portalOpen = snapshot.data != null
                      ? snapshot.data!.snapshot.value as bool
                      : false;
                  return ElevatedButton(
                    onPressed: true
                        ? () async {
                            advertise();
                            String date = getFormattedDate();
                            String interval = getCurrentInterval();
                            if (interval != "") {
                              dynamic result = await db.markAttendance(
                                  student, date, interval);
                              print(result);
                            } else {
                              print("Not in the time interval");
                            }
                          }
                        : null,
                    child: const Text("Mark attendance"),
                  );
                },
              )
            ],
          ),
        ),
      );
    } else {
      return const Loading();
    }
  }
}
