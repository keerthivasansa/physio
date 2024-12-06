import 'package:flutter/material.dart';
import 'package:physio/api/auth.dart';
import 'package:physio/api/client.dart';
import 'package:physio/colors.dart';
import 'package:physio/doctor/dashboard.dart';
import 'package:physio/nav/bar.dart';

class SignUp extends StatefulWidget {
  _SignUpScreen createState() => _SignUpScreen();
}

class _SignUpScreen extends State<SignUp> {
  String? name, id, password;
  int? totalDays, age;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: createAppBar(context, isDoc: true),
        body: SingleChildScrollView(
            child: Center(
                child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Create a new patient",
                          style: TextStyle(
                              fontSize: 24,
                              color: Color.fromRGBO(31, 10, 101, 0.898)),
                        ),
                        const SizedBox(height: 40),
                        TextField(
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            labelText: 'Patient ID',
                            prefixIcon: Icon(Icons.badge),
                            border: UnderlineInputBorder(),
                          ),
                          onChanged: (value) => id = value,
                        ),
                        const SizedBox(height: 15),
                        TextField(
                          keyboardType: TextInputType.name,
                          decoration: const InputDecoration(
                            labelText: 'Name',
                            prefixIcon: Icon(Icons.person),
                            border: UnderlineInputBorder(),
                          ),
                          onChanged: (value) => name = value,
                        ),
                        const SizedBox(height: 15),
                        TextField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Age',
                            prefixIcon: Icon(Icons.numbers),
                            border: UnderlineInputBorder(),
                          ),
                          onChanged: (value) => age = int.parse(value),
                        ),
                        const SizedBox(height: 15),
                        TextField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Total Days of Therapy',
                            prefixIcon: Icon(Icons.numbers_outlined),
                            border: UnderlineInputBorder(),
                          ),
                          onChanged: (value) => totalDays = int.parse(value),
                        ),
                        const SizedBox(height: 15),
                        TextField(
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            prefixIcon: Icon(Icons.lock),
                            border: UnderlineInputBorder(),
                          ),
                          onChanged: (value) => password = value,
                        ),
                        const SizedBox(height: 30),
                        Center(
                          child: ElevatedButton(
                            onPressed: () async {
                              ApiClient client = locator.get();
                              await client.post("/doctor/add-patient", {
                                "name": name,
                                "password": password,
                                "id": id,
                                "age": age,
                                "totalDays": totalDays,
                              });
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DoctorDashboard()));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: bgPrimaryBlue,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 100, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            child: const Text(
                              'Add Patient',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    )))));
  }
}
