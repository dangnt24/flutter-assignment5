import 'package:flutter/material.dart';
import 'package:assignment5/song.dart';
import 'package:assignment5/check_screen.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Permission.storage.request();
  runApp(CheckSongApp());
}

class CheckSongApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Song Lists',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  final List<Song> songlists = [
    Song('Happy new year', 'ABBA', 'abba_happynewyear.mp3',
        'assets/images/abba.jpg'),
    Song('Close to you', 'Carpenter', 'carpenter_closetoyou.mp3',
        'assets/images/carpenter.jpg'),
    Song(
        'Top of the world',
        'Carpenter',
        'carpenter_topoftheworld.mp3',
        'assets/images/carpenter.jpg'),
    Song(
        'Yesterday once more',
        'Carpenter',
        'carpenter_yesterdayoncemore.mp3',
        'assets/images/carpenter.jpg'),
    Song(
        'De mi noi cho ma nghe',
        'Hoang Thuy Linh',
        'hoangthuylinh_deminoichomanghe.mp3',
        'assets/images/hoangthuylinh.jpg'),
    Song(
        'Di de tro ve',
        'Soobin Hoang Son',
        'soobinhoangson_didetrove.mp3',
        'assets/images/soobinhoangson.jpg'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Song Lists'),
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'MY SONGS',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              )
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                ),
                itemCount: songlists.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => CheckScreen(song: songlists[index])));
                    },
                    child: Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: Image.asset(
                              songlists[index].img,
                              //fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(
                                  songlists[index].singer,
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ));
  }
}
