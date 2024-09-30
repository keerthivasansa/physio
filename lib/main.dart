import 'package:flutter/material.dart';
import 'package:physio/api/register.dart';
import 'package:physio/auth.dart';
import 'package:physio/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  registerServices();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const AuthScreen(),
      theme: appTheme,
    );
  }
}
