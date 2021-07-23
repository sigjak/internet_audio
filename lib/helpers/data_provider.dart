import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import '../models/station.dart';

class DataProvider with ChangeNotifier {
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
        source: 'http://wamu-1.streamguys.com',
        logo: 'assets/images/wamu.png',
        location: 'Washington DC'),
    Station(
        name: 'WBUR',
        source: 'https://icecast-stream.wbur.org/wbur',
        logo: 'assets/images/wbur.png',
        location: 'Boston'),
    Station(
        name: 'RUV Rás 1',
        source: 'http://netradio.ruv.is/ras1.mp3',
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
