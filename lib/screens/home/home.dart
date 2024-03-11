import "package:adams/models/student.dart";
import "package:adams/services/auth.dart";
import "package:adams/services/database.dart";
import "package:adams/shared/loading.dart";
import "package:adams/utils/bluetooth.dart";
import "package:adams/utils/datetime.dart";
import "package:adams/utils/server.dart";
import "package:firebase_database/firebase_database.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../../authenticate_face/authenticate_face_view.dart";

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final student = Provider.of<StudentData?>(context);

    DatabaseReference portalStateRef = FirebaseDatabase.instance
        .ref("${student?.year}/${student?.department}/${student?.section}");
    final db = DatabaseService(sid: student?.sid);

    handleSubmit() async {
      if (student != null) {
        var response = false;
        String date = getFormattedDate();
        String interval = getCurrentInterval();
        if (true || (interval != "")) {
          // if (true) {
          var uuid = await getUuid(
              student); // getsUuid of the session (bf27730d-860a-4e09-889c-2d8b6a9e0fe7)
          print(uuid);
          turnOn(); //turn on bluetooth

          while (response) {
            await advertise(uuid);
            response = await verify(student);
          }

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AuthenticateFaceView(student: student, date: date, interval: interval),
            ),
          );

          // moving this part after the auth page

          //after verification
          // dynamic result = await db.markAttendance();
          // print(result);



          var nearbyDevices = await getDevices();
          await postNearbyDevices(nearbyDevices, student);
        } else {
          print("Not in the time interval");
        }
      }
    }

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
                    onPressed: portalOpen ? handleSubmit : null,
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
