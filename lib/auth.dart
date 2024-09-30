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
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isSignUp = true;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSignUp ? bgPrimaryBlue : Colors.grey[300],
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Center(
                        child: Text(
                          'Create Account',
                          style: TextStyle(
                            color: isSignUp ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isSignUp = false;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSignUp ? Colors.grey[300] : bgPrimaryBlue,
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Center(
                        child: Text(
                          'Log In',
                          style: TextStyle(
                            color: isSignUp ? Colors.black : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            isSignUp ? const SignUpForm() : LoginForm(),
          ],
        ),
      ),
    );
  }
}

class SignUpForm extends StatelessWidget {
  const SignUpForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TextField(
          decoration: InputDecoration(
            labelText: 'Patient ID',
            prefixIcon: Icon(Icons.badge),
            border: UnderlineInputBorder(),
          ),
        ),
        const SizedBox(height: 15),
        const TextField(
          decoration: InputDecoration(
            labelText: 'Name',
            prefixIcon: Icon(Icons.person),
            border: UnderlineInputBorder(),
          ),
        ),
        const SizedBox(height: 15),
        const TextField(
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Password',
            prefixIcon: Icon(Icons.lock),
            border: UnderlineInputBorder(),
          ),
        ),
        const SizedBox(height: 30),
        Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => DoctorDashboard()));
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
              'Sign up',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
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
