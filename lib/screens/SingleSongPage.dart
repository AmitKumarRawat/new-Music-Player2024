import 'package:MusicOn/screens/MyHomePage.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'SetImagesPage.dart'; // Make sure to import this

class SingleSongPage extends StatefulWidget {
  late String songTitle; // Receive song title
  late String songPath; // Receive song path
  final List<Map<String, String>> songs; // List of songs
  SingleSongPage({
    super.key,
    required this.songTitle,
    required this.songPath,
    required this.songs,
  });

  @override
  State<SingleSongPage> createState() => _SingleSongPageState();
}

class _SingleSongPageState extends State<SingleSongPage>
    with SingleTickerProviderStateMixin {
  bool playbtn = true;
  final AudioPlayer _audioPlayer = AudioPlayer();
  Duration duration = Duration.zero; // Duration of the song
  Duration position = Duration.zero; // Current position of the song
  bool isDragging = false; // To manage dragging state of the slider
  late AnimationController _animationController;
  late Animation<double> _sizeAnimation;

  var currentTheme;
  @override
  void initState() {
    super.initState();
    _loadAudio();
    getValue();

    _audioPlayer.positionStream.listen((pos) {
      if (!isDragging) {
        setState(() {
          position = pos;
          if (position >= duration) {
            _nextSong(); // Automatically go to next song when finished
          }
        });
      }
    });

    _audioPlayer.durationStream.listen((dur) {
      setState(() {
        duration = dur ?? Duration.zero;
      });
    });

    // Initialize Animation Controller for smooth timeline animation
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    // Animation for the circular scale effect
    _sizeAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    // Start the animation loop when the audio is playing
    _audioPlayer.playerStateStream.listen((state) {
      if (state.playing) {
        _animationController.repeat(reverse: true); // Start the animation
      } else {
        _animationController.stop(); // Stop the animation
        _animationController.value = 1.0; // Reset to original size
      }
    });
  }

  Future<void> _loadAudio() async {
    try {
      await _audioPlayer.setFilePath(widget.songPath);
    } catch (e) {
      print('Error loading audio: $e');
    }
  }

  void _playPause() {
    setState(() {
      if (playbtn) {
        _audioPlayer.pause(); // Pause the song
      } else {
        _audioPlayer.play(); // Play the song
      }
      playbtn = !playbtn; // Toggle play button state
    });
  }

  void _nextSong() {
    final currentIndex =
        widget.songs.indexWhere((song) => song['path'] == widget.songPath);
    if (currentIndex < widget.songs.length - 1) {
      _loadNextSong(currentIndex + 1);
    }
  }

  void _prevSong() {
    final currentIndex =
        widget.songs.indexWhere((song) => song['path'] == widget.songPath);
    if (currentIndex > 0) {
      _loadNextSong(currentIndex - 1);
    }
  }

  void _loadNextSong(int index) {
    final nextSong = widget.songs[index];
    setState(() {
      widget.songPath = nextSong['path']!;
      widget.songTitle = nextSong['title']!;
      _loadAudio(); // Load the new audio
      _audioPlayer.play(); // Automatically play the new song
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        actions: [
          Row(children: [
            const Icon(Icons.music_note_outlined,
                size: 12, color: Colors.white),
            const Icon(Icons.music_note, size: 22, color: Colors.white),
            const Icon(Icons.music_note_rounded, size: 30, color: Colors.white),
          ]),
        ],
        title: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Text(
            widget.songTitle,
            style: const TextStyle(fontSize: 16, fontFamily: 'serif'),
          ),
        ),
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(Icons.home_rounded, size: 33, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/$currentTheme"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.55,
                child: Center(
                  child: Card(
                    elevation: 3,
                    shape: const CircleBorder(),
                    color: Colors.white.withOpacity(0.4),
                    child: Container(
                      height: 260,
                      width: 260,
                      decoration: BoxDecoration(
                        color: Colors.blueGrey.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(130),
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Center(
                          child: Row(
                            children: [
                              ScaleTransition(
                                scale: _sizeAnimation,
                                child: const Icon(Icons.music_note_outlined,
                                    size: 62, color: Colors.black),
                              ),
                              ScaleTransition(
                                scale: _sizeAnimation,
                                child: const Icon(Icons.music_note,
                                    size: 42, color: Colors.black),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ScaleTransition(
                                    scale: _sizeAnimation,
                                    child: const Icon(Icons.music_note_outlined,
                                        size: 62, color: Colors.black),
                                  ),
                                  ScaleTransition(
                                    scale: _sizeAnimation,
                                    child: const Icon(Icons.music_note_rounded,
                                        size: 42, color: Colors.black),
                                  ),
                                  // ScaleTransition(
                                  //   scale: _sizeAnimation,
                                  //   child:
                                  //   const Icon(Icons.music_note_rounded,
                                  //       size: 30, color: Colors.black),),
                                  Container(
                                    height: 30,
                                    width: 30,
                                  ),
                                  ScaleTransition(
                                    scale: _sizeAnimation,
                                    child: const Icon(Icons.music_note_rounded,
                                        size: 42, color: Colors.black),
                                  ),
                                  ScaleTransition(
                                    scale: _sizeAnimation,
                                    child: const Icon(Icons.music_note_rounded,
                                        size: 62, color: Colors.black),
                                  ),
                                ],
                              ),
                              ScaleTransition(
                                scale: _sizeAnimation,
                                child: const Icon(Icons.music_note,
                                    size: 42, color: Colors.black),
                              ),
                              ScaleTransition(
                                scale: _sizeAnimation,
                                child: const Icon(Icons.music_note_outlined,
                                    size: 62, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Timeline Slider
              Padding(
                padding: const EdgeInsets.only(left: 35, right: 35),
                child: Column(
                  children: [
                    Slider(
                      activeColor: Colors.white.withOpacity(0.83),
                      inactiveColor: Colors.white.withOpacity(0.13),
                      min: 0,
                      max: duration.inSeconds.toDouble(),
                      value: position.inSeconds.toDouble(),
                      onChanged: (value) {
                        setState(() {
                          isDragging = true;
                          position = Duration(seconds: value.toInt());
                        });
                      },
                      onChangeEnd: (value) async {
                        setState(() {
                          isDragging = false;
                        });
                        await _audioPlayer
                            .seek(Duration(seconds: value.toInt()));
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(formatDuration(position)),
                        Text(formatDuration(duration)),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                width: 250,
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: _prevSong,
                      child: Icon(Icons.skip_previous_rounded,
                          size: 55, color: Colors.white.withOpacity(0.7)),
                    ),
                    Card(
                      elevation: 3,
                      shape: CircleBorder(),
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _playPause,
                        child: playbtn
                            ? Icon(Icons.pause,
                                size: 79, color: Colors.white.withOpacity(0.6))
                            : Icon(Icons.play_arrow_rounded,
                                size: 79, color: Colors.white.withOpacity(0.6)),
                      ),
                    ),
                    InkWell(
                      onTap: _nextSong,
                      child: Icon(Icons.skip_next,
                          size: 55, color: Colors.white.withOpacity(0.6)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '$twoDigitMinutes:$twoDigitSeconds';
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
