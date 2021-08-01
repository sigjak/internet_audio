import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

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
            if (icyData != null) {
              return Text(icyData.info?.title ?? 'notitle');
            } else {
              return Text('Nodata');
            }
            //return Text(icyData?.info?.title ?? 'notitle');
          }),
    );
  }
}
