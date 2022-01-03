import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:audio_session/audio_session.dart';
import 'package:internet_audio/commons/icy_metadata.dart';
import 'package:internet_audio/commons/radio_slider.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import '../commons/player_buttons.dart';

import '../helpers/data_provider.dart';

class Player extends StatefulWidget {
  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  final List<int> sleepingTime = [5, 10, 20, 30, 45, 60];
  final _loudnessEnhancer = AndroidLoudnessEnhancer();
  late final AudioPlayer _player = AudioPlayer(
    audioPipeline: AudioPipeline(
      androidAudioEffects: [
        _loudnessEnhancer,
        // _equalizer,
      ],
    ),
  );

  int index = 0;
  late DataProvider data;

  @override
  void initState() {
    super.initState();
    // _player = AudioPlayer();
    initRadio(index);
  }

  initRadio(index) async {
    data = context.read<DataProvider>();
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.speech());
    _loudnessEnhancer.setEnabled(true);
    try {
      await _player.setAudioSource(AudioSource.uri(
          Uri.parse("http://stream.live.vc.bbcmedia.co.uk/bbc_world_service")));
    } catch (e) {
      print("Error loading audio source: $e");
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
    print('dispose');
  }

  @override
  Widget build(BuildContext context) {
    // final wdata = Provider.of<DataProvider>(context);

    final wdata = context.watch<DataProvider>();
    return Scaffold(
      //backgroundColor: Colors.grey[400],
      appBar: AppBar(
        title: Text('Audioplayer'),
        actions: [
          wdata.isSleep
              ? Row(
                  children: [
                    Text(
                      'Minutes until sleep: ${data.sleepTime}',
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    TextButton(
                      onPressed: () {
                        data.timer.cancel();
                        setState(() {
                          wdata.isSleep = false;
                        });
                        wdata.snack('Sleep cancelled !', context);
                      },
                      child: Text('Cancel Sleep',
                          style: TextStyle(color: Colors.grey)),
                    )
                  ],
                )
              : PopupMenuButton<int>(
                  offset: Offset(60, 40),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text('Sleep'),
                  ),
                  onSelected: (value) {
                    data.sleeping(value);
                    data.snack('Sleeping in $value minutes', context);
                  },
                  itemBuilder: (context) {
                    return sleepingTime.map((item) {
                      return PopupMenuItem<int>(
                        value: item,
                        child: Text('${item.toString()} minutes.'),
                      );
                    }).toList();
                  })
        ],
      ),
      body: Center(
        child: Column(
          children: [
            // StreamBuilder<SequenceState?>(
            //   stream: _player.sequenceStateStream,
            //   builder: (_, snapshot) {
            //     final state = snapshot.data;

            //     return state != null
            //         ? Column(children: [
            //             Container(
            //               margin: EdgeInsets.symmetric(vertical: 20),
            //               height: 200,
            //               //child: state.sequence[0].tag.extras['image'],
            //               child: Image(
            //                 image: AssetImage(
            //                     state.sequence[0].tag.extras['image']),
            //               ),
            //             ),
            //             Text(state.sequence[0].tag.album,
            //                 style: TextStyle(fontSize: 20)),
            //             // Text(state.sequence[state.currentIndex].tag
            //             //     .extras['location'])
            //           ])
            //         : Text('');
            //   },
            // ),
            Icy(_player),
            PlayerButtons(_player),
            RadioSlider(_player),
            StreamBuilder<bool>(
              stream: _loudnessEnhancer.enabledStream,
              builder: (context, snapshot) {
                final enabled = snapshot.data ?? false;
                return SwitchListTile(
                  title: Text('Loudness Enhancer'),
                  value: enabled,
                  onChanged: _loudnessEnhancer.setEnabled,
                );
              },
            ),
            LoudnessEnhancerControls(loudnessEnhancer: _loudnessEnhancer),
            SizedBox(
              height: 5,
            ),
            Expanded(
              child: Column(
                
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      'Radio Stations',
                      style: TextStyle(fontSize: 22),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: data.stations.length,
                      itemBuilder: (BuildContext ctx, int index) {
                        return Card(
                          margin: EdgeInsets.fromLTRB(16, 2, 16, 0),
                          child: ListTile(
                            leading: CircleAvatar(
                                backgroundImage: ResizeImage(
                              AssetImage(data.stations[index].logo),
                              width: 40,
                              height: 40,
                            )),
                            title: Text(data.stations[index].name),
                            trailing: IconButton(
                              onPressed: () async {
                                await _player.stop();
                                await initRadio(index);
                                _player.play();
                              },
                              icon: Icon(
                                Icons.play_arrow,
                                size: 35,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 26)
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey[600],
        onPressed: () {
          dispose();
          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        },
        child: Icon(Icons.exit_to_app),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class LoudnessEnhancerControls extends StatelessWidget {
  final AndroidLoudnessEnhancer loudnessEnhancer;

  const LoudnessEnhancerControls({
    Key? key,
    required this.loudnessEnhancer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<double>(
      stream: loudnessEnhancer.targetGainStream,
      builder: (context, snapshot) {
        final targetGain = snapshot.data ?? 0.0;
        return Slider(
          min: -1.0,
          max: 1.0,
          value: targetGain,
          onChanged: loudnessEnhancer.setTargetGain,
          label: 'foo',
        );
      },
    );
  }
}
