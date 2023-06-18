import "package:flutter/material.dart";

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ADAMS"),
      ),
      body: const Center(
        child: Text("Yo Broskies, It Worked !!", style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w900,
        ),),
      ) ,
    );
  }
}
