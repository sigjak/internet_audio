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
          final icyTitle = icyData?.info?.title;
          if (icyTitle != null && icyTitle.isNotEmpty) {
            return Text(icyTitle); // Colum comes here
          } else {
            return Text(
                icyData?.headers?.genre ?? ''); // header genre comes here
          }

          //if (icyData != null) {
          //   print('Title ------------ ${icyData.info?.title?.isEmpty}');
          //   return Text(icyData.info?.title ?? 'notitle');
          // } else {
          //   return Text('Nodata');
          // }
          //return Text(icyData?.info?.title ?? 'notitle');
        },
      ),
    );
  }
}
