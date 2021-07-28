import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:internet_audio/screens/radio_player.dart';

class InternetCheck extends StatefulWidget {
  const InternetCheck({Key? key}) : super(key: key);

  @override
  _InternetCheckState createState() => _InternetCheckState();
}

class _InternetCheckState extends State<InternetCheck> {
  bool isChecked = false;
  Connectivity _connectivity = Connectivity();
  late ConnectivityResult connectivityResult;

  @override
  void initState() {
    _connectivity.checkConnectivity().then((value) {
      connectivityResult = value;
      setState(() {
        isChecked = true;
      });
      // if (connectivityResult != ConnectivityResult.none) {
      //   Navigator.push(
      //       context, MaterialPageRoute(builder: (context) => Player()));
      // }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Title'),
      ),
      body: Center(
          child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isChecked
                ? Text(connectivityResult.toString())
                : CircularProgressIndicator(),
          ],
        ),
      )),
    );
  }
}
