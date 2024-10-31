import 'dart:async';
import 'package:flutter/material.dart';

import 'MyHomePage.dart';

class Splashpage extends StatefulWidget {
  const Splashpage({super.key});

  @override
  State<Splashpage> createState() => _SplashpageState();
}

class _SplashpageState extends State<Splashpage> {
  @override
  void initState() {
    // TODO: implement initState
    Timer(Duration(seconds: 3), () {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) {
        return MyHomePage();
      }));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(
                Icons.music_note,
                size: 55,
              ),
              Icon(
                Icons.music_note_outlined,
                size: 41,
              ),
              Icon(Icons.music_note_rounded)
            ]),
            Text(
              "Music on Tension gone",
              style: TextStyle(fontSize: 26, fontFamily: 'cursive'),
            ),
            SizedBox(
              height: 155,
            )
          ],
        ),
      ),
    );
  }
}
