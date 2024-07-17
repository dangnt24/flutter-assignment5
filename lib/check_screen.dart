import 'package:assignment5/song.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';

class CheckScreen extends StatefulWidget {
  final Song song;

  CheckScreen({Key? key, required this.song}) : super(key: key);

  @override
  _CheckScreenState createState() => _CheckScreenState();
}

class _CheckScreenState extends State<CheckScreen> {
  AudioPlayer player = AudioPlayer();
  PlayerState? _playerState;
  final _songController = TextEditingController();
  final _formChecksong = GlobalKey<FormState>();
  int _selectIndex = 1;

  StreamSubscription? _playerCompleteSubscription;
  StreamSubscription? _playerStateChangeSubscription;

  bool get _isPlaying => _playerState == PlayerState.playing;

  bool get _isPaused => _playerState == PlayerState.paused;

  @override
  void initState() {
    super.initState();

    // Create the audio player.
    player = AudioPlayer();

    // Set the release mode to keep the source after playback has completed.
    player.setReleaseMode(ReleaseMode.stop);

    // Start the player as soon as the app is displayed.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await player.setSource(AssetSource('sounds/${widget.song.audio}'));
      await player.resume();
    });

    // Use initial values from player
    _playerState = player.state;

    _initStreams();
  }

  @override
  void setState(VoidCallback fn) {
    // Subscriptions only can be closed asynchronously,
    // therefore events can occur after widget has been disposed.
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    _playerCompleteSubscription?.cancel();
    _playerStateChangeSubscription?.cancel();
    player.dispose(); // Ensure the player is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Play Check Song'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'CHECK SONG',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                )),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 100),
                child: Image.asset(
                  widget.song.img,
                )),
            Padding(
                padding: EdgeInsets.symmetric(vertical: 6),
                child: Text(
                  widget.song.singer,
                  style: TextStyle(fontSize: 16),
                )),
            SizedBox(
              height: 40,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: _selectIndex == 1? Colors.red: Colors.green,
                  child: IconButton(
                    key: const Key('play_button'),
                    onPressed: () {
                      _changeColor(1);
                      _isPlaying ? null : _play();
                    },
                    iconSize: 32.0,
                    icon: const Icon(Icons.play_arrow),
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 10,),
                CircleAvatar(
                  radius: 30,
                  backgroundColor: _selectIndex == 2? Colors.red: Colors.green,
                  child: IconButton(
                    key: const Key('pause_button'),
                    onPressed: () {
                      _changeColor(2);
                      _isPlaying ? _pause() : null;
                    },
                    iconSize: 32.0,
                    icon: const Icon(Icons.pause),
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 10,),
                Form(
                  key: _formChecksong,
                  child: Expanded(
                    child: TextFormField(
                        controller: _songController,
                        validator: (value) => value == null || value.isEmpty
                            ? 'This field cannot be left blank!'
                            : null),
                  ),
                ),
                SizedBox(width: 10,),
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.green,
                  child: IconButton(
                    key: const Key('check_button'),
                    onPressed: (){
                      _checksong();
                    },
                    iconSize: 32.0,
                    icon: const Icon(Icons.check),
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _initStreams() {
    _playerCompleteSubscription = player.onPlayerComplete.listen((event) {
      setState(() {
        _playerState = PlayerState.stopped;
      });
    });

    _playerStateChangeSubscription =
        player.onPlayerStateChanged.listen((state) {
      setState(() {
        _playerState = state;
      });
    });
  }

  void _changeColor(int index) {
    setState(() {
      _selectIndex = (_selectIndex == index) ? -1 : index;
    });
  }

  void _checksong() {
    if (_formChecksong.currentState!.validate()) {
      if (_songController.text == widget.song.name) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Correct!', style: TextStyle(color: Colors.black),),
          duration: Duration(seconds: 2), // Display time of the SnackBar
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.grey.shade200,
          width: 86,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Incorrect!', style: TextStyle(color: Colors.black),),
          duration: Duration(seconds: 2), // Display time of the SnackBar
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.grey.shade200,
          width: 96,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
        ));
      }
    }
  }

  Future<void> _play() async {
    // Request audio focus
    await player.resume();
    setState(() => _playerState = PlayerState.playing);
  }

  Future<void> _pause() async {
    await player.pause();
    setState(() => _playerState = PlayerState.paused);
  }
}
