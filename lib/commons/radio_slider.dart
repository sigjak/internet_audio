import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:just_audio/just_audio.dart';

class RadioSlider extends StatelessWidget {
  RadioSlider(this._audioPlayer);
  final AudioPlayer _audioPlayer;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        StreamBuilder<PositionData>(
            stream: Rx.combineLatest2<Duration, Duration, PositionData>(
              _audioPlayer.positionStream,
              _audioPlayer.bufferedPositionStream,
              (position, bufferedPosition) =>
                  PositionData(position, bufferedPosition),
            ),
            builder: (context, snapshot) {
              final positionData =
                  snapshot.data ?? PositionData(Duration.zero, Duration.zero);
              // var position = positionData.position;
              //var bufferedposition = positionData.bufferedPosition;
              return SeekBar(
                  audioPlayer: _audioPlayer,
                  position: positionData.position,
                  bufferedPosition: positionData.bufferedPosition);
            })
      ],
    );
  }
}

class PositionData {
  final Duration position;
  final Duration bufferedPosition;
  PositionData(this.position, this.bufferedPosition);
}

class SeekBar extends StatefulWidget {
  final Duration position;
  final Duration bufferedPosition;
  final AudioPlayer audioPlayer;

  SeekBar(
      {required this.audioPlayer,
      required this.position,
      required this.bufferedPosition});

  @override
  _SeekBarState createState() => _SeekBarState();
}

class _SeekBarState extends State<SeekBar> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 400,
          child: Slider(
              min: 0.0,
              max: Duration(hours: 1).inMilliseconds.toDouble(),
              value: widget.position.inMilliseconds.toDouble(),
              onChanged: (value) {}),
        ),
      ],
    );
  }
}
