import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SetImagesPage extends StatefulWidget {
  final String pathImg;
  SetImagesPage({super.key, required this.pathImg});
  @override
  State<SetImagesPage> createState() => SetImagesPageState();
}

class SetImagesPageState extends State<SetImagesPage> {
  String? THEME_KEY = 'theme.jpg';
  String? currentTheme;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTheme();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/${widget.pathImg}'), // change accordingly
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.all(21),
              child: InkWell(
                onTap: () async {
                  var themeValue = widget.pathImg;
                  var sharedPrefs = await SharedPreferences.getInstance();
                  setState(() {
                    sharedPrefs.setString(
                        THEME_KEY!, themeValue.trim().toString());
                  });
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.grey.withOpacity(0.7),
                      content: Text(
                    'Restart app to apply changes',
                    style: TextStyle(
                        fontFamily: 'serif',
                        fontSize: 16,
                        color: Colors.white),
                    textAlign: TextAlign.center,
                  )));
                  Navigator.of(context).pop();
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration:
                      BoxDecoration(color: Colors.lightGreen.withOpacity(0.4)),
                  height: 33,
                  child: Text(
                    "Set as Background Imgae",
                    style: TextStyle(fontFamily: 'serif', fontSize: 21),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  getTheme() async {
    // get value from shared prefs after restart
    var checker;
    var sharedPref = await SharedPreferences.getInstance();
    checker = sharedPref.getString(THEME_KEY!);
    setState(() {
      currentTheme = checker != null ? checker : widget.pathImg;
    });
  }
}
