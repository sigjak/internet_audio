import 'package:flutter/material.dart';

class InernetCheck extends StatelessWidget {
  const InernetCheck({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Title'),
      ),
      body: Container(
        child: Text('check if internet'),
      ),
    );
  }
}
