import 'package:electrum_task/Screens/login_form.dart';
import 'package:electrum_task/Screens/signup_form.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login with Signup',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SignupForm(),
    );
  }
}