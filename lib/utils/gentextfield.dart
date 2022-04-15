import 'package:electrum_task/utils/validate_helper.dart';
import 'package:flutter/material.dart';

class getTextFormField extends StatelessWidget {
  TextEditingController controller;
  String hintName;
  IconData icon;
  bool isObscureText;
  TextInputType inputType;
  bool isEnable;

  getTextFormField(
      {required this.controller,
      required this.hintName,
      required this.icon,
      this.isObscureText = false,
      this.inputType = TextInputType.text,
      this.isEnable = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
          controller: controller,
          obscureText: isObscureText,
          enabled: isEnable,
          keyboardType: inputType,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter $hintName';
            }
            if (hintName == "Email" && !validateEmail(value)) {
              return 'Please Enter Valid Email';
            }
            return null;
          },
          textAlign: TextAlign.start,
          decoration: InputDecoration(
            hintText: hintName,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(1),
              ),
              borderSide: BorderSide(color: Colors.black),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(1),
              ),
              borderSide: BorderSide(color: Colors.black),
            ),
          )),
    );
  }
}
