import 'package:flutter/material.dart';

class SamplePageTwo extends StatelessWidget {
  const SamplePageTwo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sample page two'),
      ),

      body: Center(
        child: Text('Sample page two'),
      ),
    );
  }
}