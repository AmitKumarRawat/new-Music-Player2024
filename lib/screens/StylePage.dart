
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'SetImagesPage.dart';
class StylePage extends StatefulWidget {
   StylePage({super.key});
  @override
  State<StylePage> createState() => StylePageState();
}

class StylePageState extends State<StylePage> {
String? currentTheme;
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    getValue();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent.withOpacity(0.3),
        title: Text('Styles & Theme',style: TextStyle(fontFamily: 'serif',fontSize: 21,color: Colors.white),),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration:  BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/$currentTheme'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(21),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context){return SetImagesPage(pathImg: 'img1.jpg');}));
                    },
                      child: Container(
                        height: MediaQuery.of(context).size.height*0.3,
                        width: MediaQuery.of(context).size.width*0.4,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          image: DecorationImage(
                            image: AssetImage("assets/img1.jpg"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    InkWell(onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context){return SetImagesPage(pathImg: 'img2.jpg');}));
                    },
                      child: Container(
                        height: MediaQuery.of(context).size.height*0.3,
                        width: MediaQuery.of(context).size.width*0.4,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          image: DecorationImage(
                            image: AssetImage("assets/img2.jpg"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(21),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context){return SetImagesPage(pathImg: 'img3.jpg');}));
                    },
                      child: Container(
                        height: MediaQuery.of(context).size.height*0.3,
                        width: MediaQuery.of(context).size.width*0.4,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          image: DecorationImage(
                            image: AssetImage("assets/img3.jpg"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    InkWell(onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context){return SetImagesPage(pathImg: 'img4.png');}));
                    },
                      child: Container(
                        height: MediaQuery.of(context).size.height*0.3,
                        width: MediaQuery.of(context).size.width*0.4,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          image: DecorationImage(
                            image: AssetImage("assets/img4.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(21),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context){return SetImagesPage(pathImg: 'img5.jpg');}));
                    },
                      child: Container(
                        height: MediaQuery.of(context).size.height*0.3,
                        width: MediaQuery.of(context).size.width*0.4,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          image: DecorationImage(
                            image: AssetImage("assets/img5.jpg"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    InkWell(onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context){return SetImagesPage(pathImg: 'img6.jpg');}));
                    },
                      child: Container(
                        height: MediaQuery.of(context).size.height*0.3,
                        width: MediaQuery.of(context).size.width*0.4,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          image: DecorationImage(
                            image: AssetImage("assets/img6.jpg"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(21),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context){return SetImagesPage(pathImg: 'img7.jpg');}));
                    },
                      child: Container(
                        height: MediaQuery.of(context).size.height*0.3,
                        width: MediaQuery.of(context).size.width*0.4,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          image: DecorationImage(
                            image: AssetImage("assets/img7.jpg"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    InkWell(onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context){return SetImagesPage(pathImg: 'img8.jpg');}));
                    },
                      child: Container(
                        height: MediaQuery.of(context).size.height*0.3,
                        width: MediaQuery.of(context).size.width*0.4,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          image: DecorationImage(
                            image: AssetImage("assets/img8.jpg"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(21),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context){return SetImagesPage(pathImg: 'img9.jpg');}));
                    },
                      child: Container(
                        height: MediaQuery.of(context).size.height*0.3,
                        width: MediaQuery.of(context).size.width*0.4,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          image: DecorationImage(
                            image: AssetImage("assets/img9.jpg"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    InkWell(onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context){return SetImagesPage(pathImg: 'img10.jpg');}));
                    },
                      child: Container(
                        height: MediaQuery.of(context).size.height*0.3,
                        width: MediaQuery.of(context).size.width*0.4,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          image: DecorationImage(
                            image: AssetImage("assets/img10.jpg"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(21),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context){return SetImagesPage(pathImg: 'img11.jpg');}));
                    },
                      child: Container(
                        height: MediaQuery.of(context).size.height*0.3,
                        width: MediaQuery.of(context).size.width*0.4,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          image: DecorationImage(
                            image: AssetImage("assets/img11.jpg"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    InkWell(onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context){return SetImagesPage(pathImg: 'img12.jpg');}));
                    },
                      child: Container(
                        height: MediaQuery.of(context).size.height*0.3,
                        width: MediaQuery.of(context).size.width*0.4,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          image: DecorationImage(
                            image: AssetImage("assets/img12.jpg"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(21),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context){return SetImagesPage(pathImg: 'img13.jpg');}));
                    },
                      child: Container(
                        height: MediaQuery.of(context).size.height*0.3,
                        width: MediaQuery.of(context).size.width*0.4,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          image: DecorationImage(
                            image: AssetImage("assets/img13.jpg"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    InkWell(onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context){return SetImagesPage(pathImg: 'img14.jpg');}));
                    },
                      child: Container(
                        height: MediaQuery.of(context).size.height*0.3,
                        width: MediaQuery.of(context).size.width*0.4,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          image: DecorationImage(
                            image: AssetImage("assets/img14.jpg"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(21),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context){return SetImagesPage(pathImg: 'iimg15.jpg');}));
                    },
                      child: Container(
                        height: MediaQuery.of(context).size.height*0.3,
                        width: MediaQuery.of(context).size.width*0.4,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          image: DecorationImage(
                            image: AssetImage("assets/iimg15.jpg"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height*0.3,
                      width: MediaQuery.of(context).size.width*0.4,
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

    );
  }
void getValue()async {
  var checker;
  var sharedPrefs = await SharedPreferences.getInstance();
  checker =sharedPrefs.getString(SetImagesPageState().THEME_KEY!);
  setState(() {
    currentTheme=checker != null ? checker:'theme.jpg';
  });
}
}