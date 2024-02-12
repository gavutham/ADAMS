import "package:adams/models/student.dart";
import "package:adams/screens/authentication/authWrapper.dart";
import "package:adams/screens/home/home.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final user = Provider.of<StudentUser?>(context);

    return user != null ? AuthWrapper() : const AuthWrapper();
  }
}
