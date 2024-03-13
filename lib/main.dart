import 'package:color_prediction/moduls/screens/home-screen/home-screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      routes: {
        '/': (context) => HomeScreen(),
      },
    ),
  );
}
