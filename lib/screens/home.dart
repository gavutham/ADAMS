import "package:adams/models/student.dart";
import "package:adams/services/auth.dart";
import "package:adams/shared/loading.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final student = Provider.of<StudentData?>(context);

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
          child: Text(text, style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w900,
          ),),
        ) ,
      );
    } else {
      return const Loading();
    }

  }
}
