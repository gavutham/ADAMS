import 'package:adams/services/auth.dart';
import 'package:adams/shared/loading.dart';
import 'package:flutter/material.dart';

//Dropdown values
const List<String> years = ["I", "II", "III", "IV"];
const List<String> departments = ["CSE", "IT", "ECE", "EEE", "MECHANICAL", "CIVIL", "BIOMEDICAL", "CHEMICAL"];

class SignUp extends StatefulWidget {
  final void Function() toggleView;

  const SignUp({Key? key, required this.toggleView}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey =GlobalKey<FormState>();

  final _auth = AuthService();

  //form values
  String name = "";
  String email = "";
  String password = "";
  String year = years.first;
  String department = departments.first;
  String error = "";
  bool loading = false;


  @override
  Widget build(BuildContext context) {
    return loading ? const Loading() : Scaffold(
      appBar: AppBar(
        title: const Text("Sign In"),
        actions: [
          ElevatedButton(
            onPressed: widget.toggleView,
            child: const Text("Sign Up"),
          )
        ],
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 75),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(hintText: "Name"),
                onChanged: (value) {
                  setState(() {
                    name = value;
                  });
                },
              ),
              const SizedBox(height: 20,),
              TextFormField(
                decoration: const InputDecoration(hintText: "Email"),
                onChanged: (value) {
                  setState(() {
                    email = value;
                  });
                },
              ),
              const SizedBox(height: 20,),
              TextFormField(
                decoration: const InputDecoration(hintText: "Password"),
                onChanged: (value) {
                  setState(() {
                    password = value;
                  });
                },
              ),
              const SizedBox(height: 20,),
              Row(
                children: [
                  const Text("Year"),
                  const SizedBox(width: 20,),
                  DropdownButton<String>(
                    value: year,
                    hint: const Text("Year"),
                    icon: const Icon(Icons.arrow_drop_down_rounded),
                    elevation: 16,
                    underline: Container(
                      height: 2,
                      color: Colors.grey,
                    ),
                    onChanged: (String? value) {
                      // This is called when the user selects an item.
                      setState(() {
                        year = value!;
                      });
                    },
                    items: years.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
              const SizedBox(height: 20,),
              Row(
                children: [
                  const Text("Department"),
                  const SizedBox(width: 20,),
                  DropdownButton<String>(
                    value: department,
                    hint: const Text("Department"),
                    icon: const Icon(Icons.arrow_drop_down_rounded),
                    elevation: 16,
                    underline: Container(
                      height: 2,
                      color: Colors.grey,
                    ),
                    onChanged: (String? value) {
                      // This is called when the user selects an item.
                      setState(() {
                        department = value!;
                      });
                    },
                    items: departments.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
              const SizedBox(height: 20,),
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    loading = true;
                    error = "";
                  });
                  dynamic user = await _auth.studentSignUp(email, password, department, year, name);
                  if (user == null) {
                    setState(() {
                      loading = false;
                      error = "Something Went Wrong, please try again";
                    });
                  }
                },
                child: const Text("Sign Up"),
              ),
              const SizedBox(height: 20,),
              Text(
                  error,
                  style: const TextStyle(
                      color: Colors.red
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
