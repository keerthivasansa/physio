import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:physio/api/auth.dart';
import 'package:physio/colors.dart';
import 'package:physio/doctor/dashboard.dart';
import 'package:physio/user/dashboard.dart';
import 'package:physio/utils.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isSignUp = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Login",
              style: TextStyle(
                  fontSize: 24,
                  color: Color.fromRGBO(60, 25, 166, 0.89),
                  fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 20),
            LoginForm(),
          ],
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  String id = "", password = "";

  LoginForm({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginForm> {
  void submitLogin(BuildContext ctx) async {
    final auth = locator.get<AuthState>();
    final valid = await auth.login(widget.id, widget.password);
    switch (valid) {
      case AuthResult.fail:
        ScaffoldMessenger.of(ctx).showSnackBar(
            const SnackBar(content: Text("Invalid credentials!")));
        break;
      case AuthResult.doc:
        navigate(ctx, DoctorDashboard());
        break;
      case AuthResult.patient:
        navigate(ctx, Dashboard());
    }
  }

  void loadPrevState(BuildContext ctx) async {
    final storage = FlutterSecureStorage();
    final isDoc = await storage.read(key: "isDoctor");
    print("Prev state: $isDoc");
    if (isDoc != null) {
      final goto = isDoc == "OK" ? DoctorDashboard() : Dashboard();
      navigate(ctx, goto);
    }
  }

  @override
  Widget build(BuildContext context) {
    loadPrevState(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          decoration: const InputDecoration(
            labelText: 'Username',
            prefixIcon: Icon(Icons.person),
            border: UnderlineInputBorder(),
          ),
          onChanged: (value) => widget.id = value,
        ),
        const SizedBox(height: 15),
        TextField(
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Password',
              prefixIcon: Icon(Icons.lock),
              border: UnderlineInputBorder(),
            ),
            onChanged: (value) => widget.password = value),
        const SizedBox(height: 30),
        Center(
          child: ElevatedButton(
            onPressed: () {
              submitLogin(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: bgPrimaryBlue,
              padding:
                  const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: const Text(
              'Log in',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
