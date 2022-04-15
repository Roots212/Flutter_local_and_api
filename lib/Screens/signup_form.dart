import 'package:electrum_task/Modal/user_modal.dart';
import 'package:electrum_task/Screens/login_form.dart';
import 'package:electrum_task/dbhelper/dbhelper.dart';
import 'package:electrum_task/utils/gen_widget.dart';
import 'package:electrum_task/utils/gentextfield.dart';
import 'package:electrum_task/utils/validate_helper.dart';
import 'package:flutter/material.dart';

class SignupForm extends StatefulWidget {
  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = new GlobalKey<FormState>();

  final _conUserId = TextEditingController();
  final _conFirstName = TextEditingController();
  final _conLastName = TextEditingController();

  final _conEmail = TextEditingController();
  final _conPassword = TextEditingController();
  final _conCPassword = TextEditingController();
  var dbHelper;

  @override
  void initState() {
    super.initState();
    dbHelper = DbHelper();
  }

  signUp() async {
    String uid = _conUserId.text;
    String firstname = _conFirstName.text;
    String lastname = _conLastName.text;

    String email = _conEmail.text;
    String passwd = _conPassword.text;
    String cpasswd = _conCPassword.text;

    if (_formKey.currentState!.validate()) {
      if (passwd != cpasswd) {
        alertDialog(context, 'Password Mismatch');
      } else {
        _formKey.currentState!.save();

        UserModal uModel = UserModal(uid, firstname, lastname, email, passwd);
        await dbHelper.saveData(uModel).then((userData) {
          alertDialog(context, "Successfully Saved");

          Navigator.push(
              context, MaterialPageRoute(builder: (_) => LoginForm()));
        }).catchError((error) {
          print(error);
          alertDialog(context, "Error: Data Save Fail");
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actions: [],
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          'Signup',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  genLoginSignupHeader('Signup'),
                  getTextFormField(
                      controller: _conUserId,
                      icon: Icons.person,
                      hintName: 'User ID'),
                  SizedBox(height: 10.0),
                  getTextFormField(
                      controller: _conFirstName,
                      icon: Icons.person_outline,
                      inputType: TextInputType.name,
                      hintName: 'First Name'),
                  SizedBox(height: 10.0),
                  getTextFormField(
                      controller: _conLastName,
                      icon: Icons.person_outline,
                      inputType: TextInputType.name,
                      hintName: 'Last Name'),
                  SizedBox(height: 10.0),
                  getTextFormField(
                      controller: _conEmail,
                      icon: Icons.email,
                      inputType: TextInputType.emailAddress,
                      hintName: 'Email'),
                  SizedBox(height: 10.0),
                  getTextFormField(
                    controller: _conPassword,
                    icon: Icons.lock,
                    hintName: 'Password',
                    isObscureText: true,
                  ),
                  SizedBox(height: 10.0),
                  getTextFormField(
                    controller: _conCPassword,
                    icon: Icons.lock,
                    hintName: 'Confirm Password',
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
                      onPressed: signUp,
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        "Sign up",
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
                        Text('Does you have account? '),
                        TextButton(
                          child: Text(
                            'Sign In',
                            style: TextStyle(color: Colors.black),
                          ),
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (_) => LoginForm()),
                                (Route<dynamic> route) => false);
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
      ),
    );
  }
}
