import 'package:adams/shared/snackbar.dart';
import "package:flutter_ble_peripheral/flutter_ble_peripheral.dart";
import "package:flutter_blue_plus/flutter_blue_plus.dart";
import "dart:io";

void turnOn() async {
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
}

void advertise(String uuid) async {
  final AdvertiseData advertiseData = AdvertiseData(
    serviceUuid: uuid,
  );

  final AdvertiseSetParameters advertiseSetParameters =
  AdvertiseSetParameters();

  final hasPermissions = await FlutterBlePeripheral().hasPermission();
  if (hasPermissions == BluetoothPeripheralState.denied) return; // End

  await FlutterBlePeripheral().start(
    advertiseData: advertiseData,
    advertiseSetParameters: advertiseSetParameters,
  );
}

getDevices() async {
  List<Map> ppNearby = [];

  var subscription =
  FlutterBluePlus.onScanResults.listen(
        (results) {
      if (results.isNotEmpty) {
        ScanResult r = results
            .last; // the most recently found device

        var map = {};
        map["uuid"] =
            r.advertisementData.serviceUuids[0].str;
        map["rssi"] = r.rssi;
        ppNearby.add(map);
        print(
            'uuid discovered: ${r.advertisementData.serviceUuids[0]}');
      }
    },
    onError: (e) => print(e),
  );

  FlutterBluePlus.cancelWhenScanComplete(
      subscription);

  await FlutterBluePlus.adapterState
      .where((val) => val == BluetoothAdapterState.on)
      .first;

  try {
    await FlutterBluePlus.startScan(
        timeout: const Duration(seconds: 15));
  } catch (e) {
    print('Start scan failed.\n');
  }

  await FlutterBluePlus.isScanning
      .where((val) => val == false)
      .first;

  await Future.delayed(const Duration(seconds: 17));

  return ppNearby;

}