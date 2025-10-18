import 'package:flutter/material.dart';

class MainAnalysisScreen extends StatelessWidget {
  const MainAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBar(
        title: Text('whoBIRD Analysis'),
      ),
      body: Center(
        child: Text('Analysis Screen'),
      ),
    );
  }
}