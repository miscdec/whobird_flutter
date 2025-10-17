import 'package:flutter/material.dart';

void main() {
  runApp(const WhoBirdApp());
}

class WhoBirdApp extends StatelessWidget {
  const WhoBirdApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'whoBIRD',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const Scaffold(
        body: Center(
          child: Text('whoBIRD Flutter'),
        ),
      ),
    );
  }
}