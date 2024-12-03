import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'screens/upload_screen.dart';
import 'screens/results_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CV Matching Application',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => UploadScreen(),
        '/results': (context) => ResultsScreen(),
      },
    );
  }
}
