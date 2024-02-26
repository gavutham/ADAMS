import "dart:async";
import "package:adams/models/student.dart";
import "package:adams/services/auth.dart";
import "package:adams/services/database.dart";
import "package:adams/shared/loading.dart";
import "package:adams/utils/datetime.dart";
import "package:firebase_database/firebase_database.dart";
import "package:flutter/material.dart";
import "package:flutter/physics.dart";
import "package:flutter_blue_plus/flutter_blue_plus.dart";
import "package:provider/provider.dart";
import 'package:flutter_ble_peripheral/flutter_ble_peripheral.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();
  List<ScanResult> _scanResults = [];
  bool isa = false;
  late StreamSubscription<List<ScanResult>> _scanResultsSubscription;

  @override
  void initState() {
    super.initState();

    _scanResultsSubscription = FlutterBluePlus.scanResults.listen((results) {
      setState(() {
        _scanResults = results.where((element) => element.rssi > -380).toList();
      });
      
    }, onError: (e) {
      print(e);
    });
  }

  @override
  void dispose() {
    _scanResultsSubscription.cancel();
    super.dispose();
  }

  Future scan() async {
    FlutterBluePlus.turnOn();
    try {
      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 15));
    } catch (e) {
      print(e);
    }
  }

  void advertise() async {
    final AdvertiseData advertiseData = AdvertiseData(
      serviceUuid: 'bf27730d-860a-4d0a-89a1-2f91a6252bf7',
      serviceDataUuid: "bf27730d-860a-4d0a-89a1-2f91a6252bf7",
      includeDeviceName: true,
      localName: "bf27730d-860a-4d0a-89a1-2f91a6252bf7",
    );



    final AdvertiseSetParameters advertiseSetParameters =
    AdvertiseSetParameters();

    final hasPermissions = await FlutterBlePeripheral().hasPermission();

    if (hasPermissions == BluetoothPeripheralState.denied) return; // End

    setState(() {
      isa = true;
    });

    await FlutterBlePeripheral().start(
      advertiseSettings: AdvertiseSettings(
        txPowerLevel: AdvertiseTxPower.advertiseTxPowerHigh,
      ),
      advertiseData: advertiseData,
      advertiseSetParameters: advertiseSetParameters,
    );

    print(FlutterBlePeripheral().isAdvertising);
  }

  Widget buildSub(ScanResult e) {
    var text = "";
    print(e.device.localName);
    print(e.device.name);
    print(e.device.toString());
    e.advertisementData.serviceData.isNotEmpty ? text += e.advertisementData.serviceData[0].toString() : null;
    e.advertisementData.serviceUuids.isNotEmpty ? text += e.advertisementData.serviceUuids[0].toString(): null;
    return Text(text != "" ? text : "no uuids");
  }


  @override
  Widget build(BuildContext context) {
    final student = Provider.of<StudentData?>(context);

    DatabaseReference portalStateRef = FirebaseDatabase.instance.ref("${student?.year}/${student?.department}/${student?.section}");
    final db = DatabaseService(sid: student?.sid);

    if (student != null) {
      final text = "Welcome ${student.name}";
      return Scaffold(
        appBar: AppBar(
          title: const Text("ADAMS"),
          actions: [
            ElevatedButton(
              onPressed: () {_auth.signOut();},
              child: const Text("Logout"),
            )
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(text, style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w900,
              ),),
              FutureBuilder(
                future: db.getCurrentHourDetails("${student.year}/${student.department}/${student.section}"),
                initialData: "",
                builder: (context, snapshot) {
                  return Text(
                    snapshot.hasData && snapshot.data.runtimeType is Map<String, dynamic> ? "Current Hour: ${snapshot.data["name"]}": "Current Hour: Nil",
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
                  final portalOpen = snapshot.data != null ? snapshot.data!.snapshot.value as bool: false;
                  return ElevatedButton(
                    // onPressed: portalOpen ? () async {
                    //   String date = getFormattedDate();
                    //   String interval = getCurrentInterval();
                    //   if (interval != "") {
                    //     dynamic result = await db.markAttendance(student, date, interval);
                    //     print(result);
                    //   } else {
                    //     print("Not in the time interval");
                    //   }
                    // } : null,
                    onPressed: scan,
                    child: const Text("Mark attendance"),
                  );
                },
              ),
              Container(
                height: 200,
                child: ListView(
                  children: _scanResults.map((e) {
                    return ListTile(
                      title: Text(e.device.advName.isNotEmpty ? e.device.advName : e.device.remoteId.id.toString(),),
                      subtitle: buildSub(e),
                      trailing: Text(e.rssi.toString()),
                    );
                  }).toList(),
                ),
              ),
              isa ? Text("Advertising") : Text("data"),
            ],
          ),
        ) ,
      );
    } else {
      return const Loading();
    }

  }
}
