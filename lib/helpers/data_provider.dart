import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'dart:async';
import '../models/station.dart';
import 'dart:io';

class DataProvider with ChangeNotifier {
  late Timer timer;
  int sleepTime = 0;
  bool isSleep = false;

  sleeping(int sleep) {
    sleepTime = sleep;
    print(sleepTime);
    isSleep = true;

    timer = Timer.periodic(Duration(minutes: 1), (timer) {
      sleepTime--;
      notifyListeners();

      if (sleepTime <= 0) {
        timer.cancel();
        dispose();
        SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        exit(0);
      }
    });
    notifyListeners();
  }

  snack(String greeting, context) {
    SnackBar snackBar = SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        elevation: 5,
        content: Text(
          greeting,
          textAlign: TextAlign.center,
          style: TextStyle(),
        ));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  List<Station> stations = [
    Station(
        name: 'BBC World Service',
        // BBC is a Dash audio see radio
        //source:
        // 'https://a.files.bbci.co.uk/media/live/manifesto/audio/simulcast/dash/nonuk/dash_low/aks/bbc_world_service.mpd',
        source: 'http://stream.live.vc.bbcmedia.co.uk/bbc_world_service',
        logo: 'assets/images/bbc.png',
        location: 'UK'),
    Station(
        name: 'WNYC 93.9',
        //source: 'http://fm939.wnyc.org/wnycfm',

        source: 'https://fm939.wnyc.org/wnycfm-web',
        logo: 'assets/images/wnyc.png',
        location: 'New York City'),
    Station(
        name: 'WNYC 820 AM',
        source: 'https://am820.wnyc.org/wnycam-tunein.aac',
        logo: 'assets/images/wnyc.png',
        location: 'New York City'),
    Station(
        name: 'WAMU',
        //source: 'http://wamu-1.streamguys.com',
        source: 'https://hd1.wamu.org/wamu-1.aac',
        logo: 'assets/images/wamu.png',
        location: 'Washington DC'),
    Station(
        name: 'WBUR',
        //source: 'https://icecast-stream.wbur.org/wbur',
        source: 'http://wbur-sc.streamguys.com/wbur.aac',
        logo: 'assets/images/wbur.png',
        location: 'Boston'),
    Station(
        name: 'RUV Rás 1',
        source: 'http://netradio.ruv.is/ras1.mp3',

        //source:
        //  'https://ruv-ras1-live-hls.secure.footprint.net/hls-live/ruv-ras1/_definst_/live.m3u8',
        logo: 'assets/images/ras_1.png',
        location: 'Reykjavík'),
    Station(
        name: 'RUV Rás 2',
        source: 'http://netradio.ruv.is/ras2.mp3',
        logo: 'assets/images/ras_2.png',
        location: 'Reykjavík'),
    Station(
        name: 'Bylgjan',
        //source: 'http://stream3.radio.is:443/tbylgjan',
        source: 'http://icecast.365net.is:8000/orbbylgjan.aac',
        logo: 'assets/images/bylgjan.png',
        location: 'Reykjavík'),
  ];
}
