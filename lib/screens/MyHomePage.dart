import 'dart:io';
import 'package:MusicOn/screens/SetImagesPage.dart';
import 'package:MusicOn/screens/SingleSongPage.dart';
import 'package:MusicOn/screens/StylePage.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  bool perm = false, playit = false;
  List<Map<String, String>> songs = []; // Change to store song title and path
  final AudioPlayer _audioPlayer = AudioPlayer();
  String? currentTheme;
  @override
  void initState() {
    super.initState();
    requestPerm();
    getValue();
  }

  Future<void> requestPerm() async {
    final plugin = DeviceInfoPlugin();
    final android = await plugin.androidInfo;

    final storageStatus = android.version.sdkInt < 33
        ? await Permission.storage.request()
        : PermissionStatus.granted;

    if (storageStatus == PermissionStatus.granted) {
      print('Granted permission');
      setState(() {
        perm = true;
      });
      fetchSongs(); // Fetch songs after permission is granted
    } else if (storageStatus == PermissionStatus.denied) {
      print('Denied permission');
    } else if (storageStatus == PermissionStatus.permanentlyDenied) {
      print('Permanently denied');
      openAppSettings();
    }
  }

  Future<void> fetchSongs() async {
    final musicDir = Directory('/storage/emulated/0/Music');

    if (await musicDir.exists()) {
      print('Accessing music directory: ${musicDir.path}');
      setState(() {
        songs = musicDir
            .listSync()
            .where((file) =>
                file is File &&
                (file.path.endsWith('.mp3') ||
                    file.path.endsWith('.wav') ||
                    file.path.endsWith('.m4a')))
            .map((file) {
          String title =
              file.uri.pathSegments.last.split('.').first; // Extract title
          return {'title': title, 'path': file.path};
        }).toList();
      });
    } else {
      print('Music directory does not exist');
    }
  }

  Future<void> playSong(String path) async {
    try {
      await _audioPlayer.setFilePath(path);
      _audioPlayer.play();
    } catch (e) {
      print('Error playing song: $e');
    }
  }

  Future<void> pauseSong(String path) async {
    try {
      await _audioPlayer.setFilePath(path);
      _audioPlayer.pause();
    } catch (e) {
      print('Error pausing song: $e');
    }
  }

  String? pathMusic, titleDisplay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent.withOpacity(0.3),
        elevation: 0.0,
        actions: [
          InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return StylePage();
              }));
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.bottomCenter,
                  width: 40,
                  height: 40,
                  child: Text(
                    'Theme& Style',
                    style: TextStyle(
                        fontSize: 11, color: Colors.white, fontFamily: 'serif'),
                    textAlign: TextAlign.center,
                  ),
                ),
                Card(
                  elevation: 3,
                  shape: CircleBorder(),
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: const DecorationImage(
                        image: AssetImage("assets/icon.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
        title: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(
                  "Music 2024",
                  style: TextStyle(fontFamily: 'serif'),
                ),
                Text('. .'),
                Icon(Icons.music_note, size: 25),
                Icon(Icons.music_note_outlined, size: 31),
                Icon(Icons.music_note_rounded, size: 36)
              ]),
            ],
          ),
        ),
      ),
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/$currentTheme"),
              fit: BoxFit.cover,
            ),
          ),
          child: perm
              ? songs.isNotEmpty
                  ? ListView.builder(
                      itemCount: songs.length,
                      itemBuilder: (context, index) {
                        final songTitle = songs[index]['title'];
                        final songPath = songs[index]['path'];
                        return Card(
                          color: Colors.white.withOpacity(0.1),
                          elevation: 2,
                          child: ListTile(
                            leading: Card(
                              elevation: 3,
                              color: Colors.purple.withOpacity(0.3),
                              shape: CircleBorder(),
                              child: Container(
                                child: Text(
                                  '${index + 1}',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            title: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      pathMusic = songPath;
                                      titleDisplay = songTitle;
                                    });
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) {
                                      return SingleSongPage(
                                        songTitle: index > 0
                                            ? songs[index - 1]['title']!
                                            : songs[index]['title']!,
                                        songPath: index > 0
                                            ? songs[index - 1]['path']!
                                            : songs[0]['path']!,
                                        songs: songs, // Pass the list of songs
                                      );
                                    }));
                                  },
                                  child:
                                      Text(songTitle!)), // Display song title
                            ),
                            trailing: IconButton(
                              icon: InkWell(
                                child: playit == true
                                    ? const Icon(
                                        Icons.music_note_outlined,
                                        color: Colors.white,
                                        size: 35,
                                      )
                                    : const Icon(
                                        Icons.music_note_outlined,
                                        color: Colors.white,
                                        size: 35,
                                      ),
                              ),
                              onPressed: () {
                                setState(() {
                                  pathMusic = songPath;
                                  titleDisplay = songTitle;
                                });
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) {
                                  return SingleSongPage(
                                    songTitle: songs[index]['title']!,
                                    songPath: songs[index]['path']!,
                                    songs: songs, // Pass the list of songs
                                  );
                                }));
                              },
                            ),
                          ),
                        );
                      },
                    )
                  : const Center(child: Text('No songs found in storage.'))
              : Column(
                  children: [
                    Container(
                        alignment: Alignment.center,
                        height: 55,
                        width: 55,
                        child: const CircularProgressIndicator()),
                  ],
                )),
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void getValue() async {
    var checker;
    var sharedPrefs = await SharedPreferences.getInstance();
    checker = sharedPrefs.getString(SetImagesPageState().THEME_KEY!);
    setState(() {
      currentTheme = checker != null ? checker : 'theme.jpg';
    });
  }
}
