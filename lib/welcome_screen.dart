import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employee Management'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 100),
            Text(
              'MY SONGS',
              style: TextStyle(
                  fontSize: 36,
                  fontFamily: 'Courgette',
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
