import 'package:flutter_ble_peripheral/flutter_ble_peripheral.dart';

void advertise() async {
  final AdvertiseData advertiseData = AdvertiseData(
    serviceUuid: 'bf27730d-860a-4e09-889c-2d8b6a9e0fe7',
    // manufacturerId: 1234,
    // manufacturerData: Uint8List.fromList([1, 2, 3, 4, 5, 6]),
  );

  // final advertiseSettings = AdvertiseSettings(
  //   advertiseMode: AdvertiseMode.advertiseModeBalanced,
  //   txPowerLevel: AdvertiseTxPower.advertiseTxPowerMedium,
  //   timeout: 3000,
  // );

  final AdvertiseSetParameters advertiseSetParameters =
      AdvertiseSetParameters();

  final hasPermissions = await FlutterBlePeripheral().hasPermission();

  if (hasPermissions == BluetoothPeripheralState.denied) return; // End

  await FlutterBlePeripheral().start(
    advertiseData: advertiseData,
    advertiseSetParameters: advertiseSetParameters,
  );
}
