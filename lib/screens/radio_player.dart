import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:audio_session/audio_session.dart';
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
  final List<int> sleepingTime = [2, 10, 20, 30, 45, 60];
  late AudioPlayer _audioPlayer;
  int index = 0;
  late DataProvider data;
  //bool isSleep = false;
  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    initRadio(index);
  }

  initRadio(index) async {
    data = context.read<DataProvider>();
    final session = await AudioSession.instance;
    final AudioSource radio;
    // final _playList = ConcatenatingAudioSource(children: data.playlist);
    radio = AudioSource.uri(
      Uri.parse(data.stations[index].source),
      tag: MediaItem(
          id: index.toString(),
          album: data.stations[index].name,
          title: data.stations[index].location,
          extras: {
            'image': data.stations[index].logo,
            'location': data.stations[index].location
          }),
    );

    await session.configure(AudioSessionConfiguration.speech());
    await _audioPlayer.setAudioSource(radio);
    setState(() {});
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
    print('dispose');
  }

  @override
  Widget build(BuildContext context) {
    // final wdata = Provider.of<DataProvider>(context);

    final wdata = context.watch<DataProvider>();
    return Scaffold(
      backgroundColor: Colors.grey[400],
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
                          style: TextStyle(color: Colors.black)),
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
            StreamBuilder<SequenceState?>(
              stream: _audioPlayer.sequenceStateStream,
              builder: (_, snapshot) {
                final state = snapshot.data;

                return state != null
                    ? Column(children: [
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 20),
                          height: 200,
                          child: Image(
                            image: AssetImage(
                                state.sequence[0].tag.extras['image']),
                          ),
                        ),
                        Text(state.sequence[0].tag.album,
                            style: TextStyle(fontSize: 20)),
                        Text(state.sequence[state.currentIndex].tag
                            .extras['location'])
                      ])
                    : Text('');
              },
            ),
            PlayerButtons(_audioPlayer),
            RadioSlider(_audioPlayer),
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
                              backgroundImage:
                                  AssetImage(data.stations[index].logo),
                            ),
                            title: Text(data.stations[index].name),
                            trailing: IconButton(
                              onPressed: () async {
                                await _audioPlayer.stop();
                                initRadio(index);
                              },
                              icon: Icon(Icons.play_arrow),
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
