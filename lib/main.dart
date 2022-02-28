import 'package:flutter/material.dart';
import 'package:satsang_attendance/homePage.dart';
import 'package:satsang_attendance/upload.dart';

Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await UploadToGoogleSheet().init();
  runApp(MaterialApp(
    home: MyApp(),
    debugShowCheckedModeBanner: false,
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return HomePage();
  }
}