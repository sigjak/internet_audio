import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

Column icyCol(String str) {
  List<String> splitString = [];
  if (str.contains('-')) {
    splitString = str.split('-');
    return Column(
      children: [
        Text(
          splitString[0],
          textAlign: TextAlign.center,
        ),
        Text(
          splitString[1],
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12),
        )
      ],
    );
  } else {
    return Column(
      children: [Text(str)],
    );
  }
}

class Icy extends StatelessWidget {
  const Icy(this._audioPlayer);
  final AudioPlayer _audioPlayer;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder<IcyMetadata?>(
        stream: _audioPlayer.icyMetadataStream,
        builder: (_, snapshot) {
          final icyData = snapshot.data;
          final icyTitle = icyData?.info?.title;
          if (icyTitle != null && icyTitle.isNotEmpty) {
            return icyCol(icyTitle);
          } else {
            return Text(icyData?.headers?.genre ?? '');
          }
        },
      ),
    );
  }
}
