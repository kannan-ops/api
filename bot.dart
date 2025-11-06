// import 'package:dragon1/profile.dart';
// import 'package:dragon1/splach2%20home.dart';
// import 'package:dragon1/theme.dart';
import 'package:flutter/material.dart';

import 'home.dart';

// import 'botn.dart';
// import 'cdr poraction.dart';
// import 'login.dart';

class bot extends StatefulWidget {
  const bot({super.key});

  @override
  State<bot> createState() => _botState();
}

class _botState extends State<bot> {

  int _intex = 0;

  final screen=[
    CRDScreen(),

  ];
  void top (a)
  {
    setState(() {
      _intex =a;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:
        screen[_intex],
        bottomNavigationBar:BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home),label: "home"),
            BottomNavigationBarItem(icon: Icon(Icons.person_rounded),label: "profile"),
          ],
          currentIndex: _intex,
          onTap:top,
        )
    );
  }
}
