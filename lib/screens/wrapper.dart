import "package:adams/models/student.dart";
import "package:adams/screens/authentication/authWrapper.dart";
import "package:adams/screens/home/home.dart";
// import 'package:adams/screens/ble_setup.dart';
import "package:flutter/material.dart";
import "package:provider/provider.dart";

// import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<StudentUser?>(context);

    // if (FlutterBluePlus.adapterStateNow != BluetoothAdapterState.on) {
    //   return BluetoothOffScreen(user: user);
    // } else {
    return user != null ? Home() : const AuthWrapper();
    // }
  }
}
