import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:internet_audio/screens/radio_player.dart';

class InternetCheck extends StatefulWidget {
  const InternetCheck({Key? key}) : super(key: key);

  @override
  _InternetCheckState createState() => _InternetCheckState();
}

class _InternetCheckState extends State<InternetCheck> {
  bool isChecked = false;
  bool isButtonShow = false;
  Color col = Colors.black;
  Connectivity _connectivity = Connectivity();
  late ConnectivityResult connectivityResult;
  late String connText;

  @override
  void initState() {
    _connectivity.checkConnectivity().then((value) {
      connectivityResult = value;
      setState(() {
        isChecked = true;
        connText = 'Connection available !';
      });
      if (connectivityResult != ConnectivityResult.none) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Player()));
      } else {
        setState(() {
          connText = "No Internet !";
          col = Colors.red;
          isChecked = true;
          isButtonShow = true;
        });
      }
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
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          isChecked
              ? Text(
                  connText,
                  style: TextStyle(color: col, fontSize: 34),
                )
              : CircularProgressIndicator(),
          isButtonShow
              ? ElevatedButton(
                  onPressed: () {
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  },
                  child: Text('Exit'))
              : SizedBox()
        ],
      )),
    );
  }
}
