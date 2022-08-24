
import 'package:flutter/material.dart';

class SamplePageOne extends StatelessWidget {
  const SamplePageOne({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sample page one'),
      ),

      body: Center(
        child: Text('Sample page one'),
      ),
    );
  }
}
