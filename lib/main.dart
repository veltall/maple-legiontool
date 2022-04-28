import 'package:flutter/material.dart';
import 'screens/homepage_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Legion Provider',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        primaryColor: Colors.white,
        dividerColor: Colors.grey.shade300,
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}
