
import 'package:findpg/provider/MyProvider.dart';
import 'package:findpg/screens/HostleListScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
      ChangeNotifierProvider(
        create: (_) => MyProvider(),
        child: MyApp(),
      ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple
      ),
      home: SafeArea(child: HostleListScreen())
    );
  }
}