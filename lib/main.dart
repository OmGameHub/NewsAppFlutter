import 'package:flutter/material.dart';
import 'package:dynamic_theme/dynamic_theme.dart';

import 'LoadingPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DynamicTheme(
      defaultBrightness: Brightness.light,
      data: (brightness) => ThemeData.light(),
      themedWidgetBuilder: (context, theme) {
        return  MaterialApp(
          title: "News App",
          theme: theme,
          debugShowCheckedModeBanner: false,
          home: LoadingPage()
        );
      }
    );
  }
}