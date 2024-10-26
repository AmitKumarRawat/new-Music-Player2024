import 'dart:io';

import 'package:MusicOn/screens/SingleSongPage.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => MyHomePageState();
}
class MyHomePageState extends State<MyHomePage> {
  bool perm = false, playit = false;
  List<Map<String, String>> songs = []; // Change to store song title and path
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    requestPerm();
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
    final musicDir = Directory('/storage/emulated/0/Download');
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
          String title = file.uri.pathSegments.last.split('.').first; // Extract title
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
   String? pathMusic,titleDisplay;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple.withOpacity(0.3),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                "Music 2024",
                style: TextStyle(fontFamily: 'serif'),
              ),
              Text('. .'),
              Icon(Icons.music_note, size: 25),
              Icon(Icons.music_note_outlined, size: 31),
              Icon(Icons.music_note_rounded, size: 36)
            ]),
            Card(
              elevation: 3,
              shape: CircleBorder(),
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white),
              ),
            )
          ],
        ),
      ),
      body: perm
          ? songs.isNotEmpty
          ? ListView.builder(
        itemCount: songs.length,
        itemBuilder: (context, index) {
          final songTitle = songs[index]['title'];
          final songPath = songs[index]['path'];
          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(),
            child: ListTile(
              leading: Card(
                elevation: 3,
                color: Colors.purple.withOpacity(0.3),
                shape: CircleBorder(),
                child: Text(
                  '${index + 1}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              title: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(songTitle!), // Display song title
              ),
              trailing: IconButton(
                icon: Container(
                  child: InkWell(
                    child: playit == true
                        ? Icon(
                      Icons.pause_circle_outline_sharp,
                      color: Colors.white,
                      size: 40,
                    )
                        : Icon(
                      Icons.play_circle_outline_sharp,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    pathMusic = songPath;
                    titleDisplay=songTitle;
                    playit = !playit; // Toggle play/pause state
                  });
                  if (playit == true) {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                      return SingleSongPage(
                        songTitle: songs[index]['title']!,
                        songPath: songs[index]['path']!,
                        songs: songs, // Pass the list of songs
                      );
                    }));

                  }

                },
              ),
            ),
          );
        },
      )
          : const Center(child: Text('No songs found in storage.'))
          : const Center(child: Text('Requesting permission...')),
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
