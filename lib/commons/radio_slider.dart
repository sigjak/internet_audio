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
              (position, bufferedPosition) => PositionData(
                position,
                bufferedPosition,
              ),
            ),
            builder: (context, snapshot) {
              final positionData =
                  snapshot.data ?? PositionData(Duration.zero, Duration.zero);
              // var position = positionData.position;
              //var bufferedposition = positionData.bufferedPosition;
              // var duration = positionData.duration;
              // print('Duration: $duration');
              return SeekBar(
                audioPlayer: _audioPlayer,
                position: positionData.position,
                bufferedPosition: positionData.bufferedPosition,
              );
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
  final AudioPlayer audioPlayer;
  final Duration position;
  final Duration bufferedPosition;

  SeekBar({
    required this.audioPlayer,
    required this.position,
    required this.bufferedPosition,
  });

  @override
  _SeekBarState createState() => _SeekBarState();
}

class _SeekBarState extends State<SeekBar> {
  double maxValue() {
    int ref = Duration(hours: 1).inMilliseconds;
    if (widget.position.inMilliseconds <= ref) {
      return ref.toDouble();
    } else {
      return widget.position.inMilliseconds.toDouble() + 100;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 20,
      child: SliderTheme(
        data: SliderThemeData(
          thumbShape: RoundSliderThumbShape(enabledThumbRadius: 7),
          trackHeight: 2,
          activeTrackColor: Colors.grey.shade500,
          inactiveTrackColor: Colors.grey.shade300,
          thumbColor: Colors.grey.shade500,
        ),
        child: Stack(
          children: [
            Slider(
              min: 0.0,
              max: maxValue(),
              value: widget.position.inMilliseconds.toDouble(),
              onChanged: (value) {},
            ),
            Positioned(
                top: 35.0,
                left: 10.0,
                child: Text(widget.position.toString().split(".").first))
          ],
        ),
      ),
    );
  }
}
