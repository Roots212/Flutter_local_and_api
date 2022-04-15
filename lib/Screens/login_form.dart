import 'package:electrum_task/Modal/user_modal.dart';
import 'package:electrum_task/Screens/dashboard_page.dart';
import 'package:electrum_task/Screens/home_page.dart';
import 'package:electrum_task/Screens/signup_form.dart';
import 'package:electrum_task/dbhelper/dbhelper.dart';
import 'package:electrum_task/utils/gen_widget.dart';
import 'package:electrum_task/utils/gentextfield.dart';
import 'package:electrum_task/utils/validate_helper.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  Future<SharedPreferences> _pref = SharedPreferences.getInstance();
  final _formKey = new GlobalKey<FormState>();

  final _conUserId = TextEditingController();
  final _conPassword = TextEditingController();
  var dbHelper;

  @override
  void initState() {
    super.initState();
    dbHelper = DbHelper();
  }

  login() async {
    String uid = _conUserId.text;
    String passwd = _conPassword.text;

    if (uid.isEmpty) {
      alertDialog(context, "Please Enter User ID");
    } else if (passwd.isEmpty) {
      alertDialog(context, "Please Enter Password");
    } else {
      await dbHelper.getLoginUser(uid, passwd).then((userData) {
        if (userData != null) {
          setSP(userData).whenComplete(() {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => DashBoard()),
                (Route<dynamic> route) => false);
          });
        } else {
          alertDialog(context, "Error: User Not Found");
        }
      }).catchError((error) {
        print(error);
        alertDialog(context, "Error: Login Fail");
      });
    }
  }

  Future setSP(UserModal user) async {
    final SharedPreferences sp = await _pref;

      sp.setString("first_name", user.first_name!);
      sp.setString("last_name", user.last_name!);
      sp.setString("user_id", user.user_id!);

      sp.setString("email", user.email!);
      sp.setString("password", user.password!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: [],
        title: Text(
          'Login',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                genLoginSignupHeader('Login'),
                getTextFormField(
                    controller: _conUserId,
                    icon: Icons.person,
                    hintName: 'User ID'),
                SizedBox(height: 10.0),
                getTextFormField(
                  controller: _conPassword,
                  icon: Icons.lock,
                  hintName: 'Password',
                  isObscureText: true,
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black,
                  ),
                  // ignore: deprecated_member_use
                  child: RaisedButton(
                    onPressed: login,
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      "Login",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          letterSpacing: 0.168,
                          fontWeight: FontWeight.w500),
                    ),
                    color: Colors.black,
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Does not have account? '),
                      TextButton(
                        child: Text('Signup',
                            style: TextStyle(color: Colors.black)),
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) => SignupForm()));
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
