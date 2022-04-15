// ignore_for_file: prefer_const_constructors

import 'package:electrum_task/Screens/login_form.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavDrawer extends StatefulWidget {
  final String username;

  const NavDrawer({Key? key, required this.username}) : super(key: key);
  @override
  State<NavDrawer> createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(
              'Hi, ${widget.username}',
              style: TextStyle(color: Colors.white, fontSize: 47),
            ),
            decoration: BoxDecoration(
              color: Colors.black,
            ),
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () => {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => LoginForm()),
              )
            },
          ),
        ],
      ),
    );
  }
}
