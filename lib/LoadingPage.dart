import 'package:flutter/material.dart';
import 'package:news_app/MyHomePage.dart';
import 'package:splashscreen/splashscreen.dart';
  

class LoadingPage extends StatefulWidget {
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 5,
      navigateAfterSeconds: MyHomePage(),
      image: Image.asset('assets/images/articles.png'),
      backgroundColor: Colors.white,
      styleTextUnderTheLoader: TextStyle(),
      photoSize: 150.0,
      loaderColor: Colors.blue
    );
  }
}