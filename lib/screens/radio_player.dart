import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:audio_session/audio_session.dart';
import 'package:internet_audio/commons/radio_slider.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import '../commons/player_buttons.dart';
import 'package:path/path.dart' as p;
//import '../models/meta.dart';
import '../helpers/data_provider.dart';
//import '../commons/slider.dart';

class Player extends StatefulWidget {
  // final int index;
  // const Player(this.index);
  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  late AudioPlayer _audioPlayer;
  int index = 0;
  late DataProvider data;
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
    if (p.extension(data.stations[index].source) == '.mpd') {
      radio = DashAudioSource(
        Uri.parse(data.stations[index].source),
        tag: MediaItem(
            id: index.toString(),
            album: data.stations[index].name,
            title: data.stations[index].name,
            // artist: data.stations[index].logo,
            extras: {
              'image': data.stations[index].logo,
              'location': data.stations[index].location
            }),
      );
    } else {
      radio = AudioSource.uri(
        Uri.parse(data.stations[index].source),
        tag: MediaItem(
            id: index.toString(),
            album: data.stations[index].name,
            title: data.stations[index].name,
            extras: {
              'image': data.stations[index].logo,
              'location': data.stations[index].location
            }),
        //artist: data.stations[index].logo),
      );
    }

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
    //final data = Provider.of<DataProvider>(context);
    return Scaffold(
      backgroundColor: Colors.grey[400],
      appBar: AppBar(
        title: Text('Audioplayer'),
        centerTitle: true,
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
