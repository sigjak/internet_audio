import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class PlayerButtons extends StatelessWidget {
  const PlayerButtons(this._audioPlayer, {Key? key}) : super(key: key);
  final AudioPlayer _audioPlayer;

  void showSliderDialog({
    required BuildContext context,
    required String title,
    required int divisions,
    required double min,
    required double max,
    String valueSuffix = '',
    required double value,
    required Stream<double> stream,
    required ValueChanged<double> onChanged,
  }) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title, textAlign: TextAlign.center),
        content: StreamBuilder<double>(
          stream: stream,
          builder: (context, snapshot) => Container(
            height: 50.0,
            child: Column(
              children: [
                // Text('${snapshot.data?.toStringAsFixed(1)}$valueSuffix',
                //     style: TextStyle(
                //         // fontFamily: 'Fixed',
                //         fontWeight: FontWeight.bold,
                //         fontSize: 24.0)),
                SliderTheme(
                  data: SliderThemeData(
                    inactiveTrackColor: Colors.grey.shade500,
                    activeTrackColor: Colors.grey[500],
                    overlayColor: Colors.grey.shade300,
                    thumbColor: Colors.grey[500],
                    overlappingShapeStrokeColor: Colors.red,
                    trackHeight: 1,
                  ),
                  child: Slider(
                    divisions: divisions,
                    label: snapshot.data?.toStringAsFixed(1) ??
                        value.toStringAsFixed(1),
                    min: min,
                    max: max,
                    value: snapshot.data ?? value,
                    onChanged: onChanged,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(Icons.volume_up),
          onPressed: () {
            showSliderDialog(
              context: context,
              title: "Adjust volume",
              divisions: 10,
              min: 0.0,
              max: 1.0,
              value: _audioPlayer.volume,
              stream: _audioPlayer.volumeStream,
              onChanged: _audioPlayer.setVolume,
            );
          },
        ),
        StreamBuilder<PlayerState>(
          stream: _audioPlayer.playerStateStream,
          builder: (_, snapshot) {
            final playerState = snapshot.data;

            return _playPauseButton(playerState);
          },
        ),
      ],
    );
  }

  Widget _playPauseButton(PlayerState? playerState) {
    final processingState = playerState?.processingState;
    if (processingState == ProcessingState.loading ||
        processingState == ProcessingState.buffering) {
      return Container(
        margin: EdgeInsets.all(8.0),
        width: 64.0,
        height: 64.0,
        child: CircularProgressIndicator(),
      );
    } else if (_audioPlayer.playing != true) {
      return IconButton(
        icon: Icon(Icons.play_arrow),
        iconSize: 64.0,
        onPressed: _audioPlayer.play,
      );
    } else if (processingState != ProcessingState.completed) {
      return IconButton(
        icon: Icon(Icons.pause),
        iconSize: 64.0,
        onPressed: _audioPlayer.pause,
      );
    } else {
      return IconButton(
        icon: Icon(Icons.replay),
        iconSize: 64.0,
        onPressed: () => _audioPlayer.seek(Duration.zero,
            index: _audioPlayer.effectiveIndices?.first),
      );
    }
  }
}
