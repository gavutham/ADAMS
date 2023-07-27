import "package:adams/models/student.dart";
import "package:adams/services/auth.dart";
import "package:adams/shared/loading.dart";
import "package:firebase_database/firebase_database.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final student = Provider.of<StudentData?>(context);
    DatabaseReference portalStateRef = FirebaseDatabase.instance.ref("${student?.department}/${student?.section}");

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
              StreamBuilder(
                stream: portalStateRef.onValue,
                builder: (context, snapshot) {
                  final portalOpen = snapshot.data != null ? snapshot.data!.snapshot.value as bool: false;
                  return ElevatedButton(
                    onPressed: portalOpen ? () {print("Attendance marked");} : null,
                    child: const Text("Mark attendance"),
                  );
                },
              )
            ],
          ),
        ) ,
      );
    } else {
      return const Loading();
    }

  }
}
