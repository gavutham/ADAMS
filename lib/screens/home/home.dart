import "dart:io";

import "package:adams/models/student.dart";
import "package:adams/services/auth.dart";
import "package:adams/services/database.dart";
import "package:adams/shared/loading.dart";
import "package:adams/utils/datetime.dart";
import "package:firebase_database/firebase_database.dart";
import "package:flutter/material.dart";
import "package:flutter_blue_plus/flutter_blue_plus.dart";
import "package:provider/provider.dart";

import 'package:adams/utils/snackbar.dart';

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
                    onPressed: portalOpen
                        ? () async {
                            try {
                              if (Platform.isAndroid) {
                                await FlutterBluePlus.turnOn();
                              } else {
                                Snackbar.show(ABC.a,
                                    "Turn on bluetooth manually and try again.",
                                    success: false);
                                return;
                              }
                            } catch (e) {
                              Snackbar.show(ABC.a,
                                  prettyException("Error Turning On:", e),
                                  success: false);
                              return; // Exit if failed!
                            }
                            var subscription =
                                FlutterBluePlus.onScanResults.listen(
                              (results) {
                                if (results.isNotEmpty) {
                                  ScanResult r = results
                                      .last; // the most recently found device
                                  print(
                                      '${r.device.remoteId}: "${r.advertisementData.advName}" found! rssi: ${r.rssi} \n');
                                  for (final guid
                                      in r.advertisementData.serviceUuids) {
                                    print('uuid: $guid');
                                  }
                                }
                              },
                              onError: (e) => print(e),
                            );

                            // cleanup: cancel subscription when scanning stops
                            FlutterBluePlus.cancelWhenScanComplete(
                                subscription);

                            // Wait for Bluetooth enabled & permission granted
                            // In your real app you should use `FlutterBluePlus.adapterState.listen` to handle all states
                            await FlutterBluePlus.adapterState
                                .where((val) => val == BluetoothAdapterState.on)
                                .first;

                            // Start scanning w/ timeout
                            // Optional: you can use `stopScan()` as an alternative to using a timeout
                            // Note: scan filters use an *or* behavior. i.e. if you set `withServices` & `withNames`
                            //   we return all the advertisments that match any of the specified services *or* any
                            //   of the specified names.
                            await FlutterBluePlus.startScan(
                              timeout: const Duration(seconds: 15),
                            );

                            // wait for scanning to stop
                            await FlutterBluePlus.isScanning
                                .where((val) => val == false)
                                .first;

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
