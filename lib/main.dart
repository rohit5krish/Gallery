import 'package:flutter/material.dart';
import 'package:gallery/screen_home.dart';

void main() {
  runApp(GalleryApp());
}

class GalleryApp extends StatelessWidget {
  const GalleryApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.red),
      home: ScreenHome(),
    );
  }
}
