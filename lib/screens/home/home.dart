import "package:adams/models/student.dart";
import "package:adams/screens/statistics/statistics.dart";
import "package:adams/services/auth.dart";
import "package:adams/services/database.dart";
import "package:adams/shared/loading.dart";
import 'package:adams/services/bluetooth.dart';
import 'package:adams/services/server.dart';
import "package:firebase_database/firebase_database.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "../../authenticate_face/authenticate_face_view.dart";

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final student = Provider.of<StudentData?>(context);

    DatabaseReference portalStateRef = FirebaseDatabase.instance
        .ref("${student?.year}/${student?.department}/${student?.section}");
    final db = DatabaseService(sid: student?.sid);

    handleSubmit() async {
      setState(() {
        isLoading = true;
      });
      if (student != null) {
        var response = false;

        var uuid = await getUuid(student); // getsUuid of the session (bf27730d-860a-4e09-889c-2d8b6a9e0fe7)
        print(uuid);
        turnOn(); //turn on bluetooth

        while (!response) {
          await advertise(uuid);
          response = await verify(student);
        }

        //need to fix the flow (face auth)
        // Navigator.of(context).push(
        //   MaterialPageRoute(
        //     builder: (context) => AuthenticateFaceView(student: student, date: date, interval: interval),
        //   ),
        // );


        var nearbyDevices = await getDevices();
        await postNearbyDevices(nearbyDevices, student);
      }
      setState(() {
        isLoading = false;
      });
    }

    if (student != null) {
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
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Welcome,",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        student.name,
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const Statistics()));
                    },
                    child: const Row(
                      children: [
                        Text(
                          "See Stats",
                          style: TextStyle(
                            fontSize: 20,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                        )
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 50,),
              StreamBuilder(
                stream: portalStateRef.onValue,
                builder: (context, snapshot) {
                  final portalOpen = snapshot.data != null
                      ? snapshot.data!.snapshot.value as bool
                      : false;
                  print(portalOpen);
                  return Column(
                    children: [
                      ElevatedButton(
                        onPressed: portalOpen && !isLoading ? handleSubmit : null,
                        child: const Text("Mark attendance"),

                      ),
                      const SizedBox(height: 10,),
                      Text(
                        //get current attendance session from mongo
                        portalOpen ? "Current Attendance Session : blah" : "No Active Attendance Session",
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
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
