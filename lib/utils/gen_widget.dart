import 'package:flutter/material.dart';

class genLoginSignupHeader extends StatelessWidget {
  String headerName;

  genLoginSignupHeader(this.headerName);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(height: 50.0),
          Text(
            headerName,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 40.0),
          ),
          SizedBox(height: 10.0),
          SizedBox(height: 10.0),
          Text(
            'Yash Sharma',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black38.withOpacity(0.1),
                fontSize: 25.0),
          ),
          SizedBox(height: 10.0),
        ],
      ),
    );
  }
}
