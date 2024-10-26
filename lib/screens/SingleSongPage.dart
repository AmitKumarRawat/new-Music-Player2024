import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart'; // Make sure to import this

class SingleSongPage extends StatefulWidget {
  late  String songTitle; // Receive song title
  late  String songPath; // Receive song path
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

class _SingleSongPageState extends State<SingleSongPage> with SingleTickerProviderStateMixin {
  bool playbtn = true;
  final AudioPlayer _audioPlayer = AudioPlayer();
  Duration duration = Duration.zero; // Duration of the song
  Duration position = Duration.zero; // Current position of the song
  bool isDragging = false; // To manage dragging state of the slider
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _loadAudio();
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

    // Animation Controller for smooth timeline animation
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
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
    final currentIndex = widget.songs.indexWhere((song) => song['path'] == widget.songPath);
    if (currentIndex < widget.songs.length - 1) {
      _loadNextSong(currentIndex + 1);
    }
  }

  void _prevSong() {
    final currentIndex = widget.songs.indexWhere((song) => song['path'] == widget.songPath);
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
      appBar: AppBar(
        backgroundColor: Colors.purple.withOpacity(0.3),
        title: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.songTitle,style: TextStyle(fontSize: 16,fontFamily: 'serif'),), // Use passed song title
              Icon(Icons.music_note_outlined, size: 12, color: Colors.white),
              Icon(Icons.music_note, size: 22, color: Colors.white),
              Icon(Icons.music_note_rounded, size: 30, color: Colors.white),
            ],
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.6,
            child: Center(
              child: Card(
                elevation: 6,
                shape: CircleBorder(),
                color: Colors.white.withOpacity(0.4),
                child: Container(
                  height: 260,
                  width: 260,
                  decoration: BoxDecoration(
                    color: Colors.purple.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(130),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Center(
                      child: Row(
                        children: [
                          Icon(Icons.music_note_outlined, size: 62, color: Colors.black),
                          Icon(Icons.music_note, size: 52, color: Colors.black),
                          Icon(Icons.music_note_rounded, size: 40, color: Colors.black),
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
            padding: const EdgeInsets.only(left: 6,right: 6),
            child: Column(
              children: [
                Slider(
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
                    await _audioPlayer.seek(Duration(seconds: value.toInt()));
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
          Card(
            color: Colors.white.withOpacity(0.03),
            margin: EdgeInsets.only(left: 21, right: 21),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: _prevSong,
                  child: Icon(Icons.skip_previous_rounded, size: 55, color: Colors.purple.withOpacity(0.7)),
                ),
                InkWell(
                  onTap: _playPause,
                  child: playbtn
                      ? Icon(Icons.pause, size: 55, color: Colors.purple.withOpacity(0.6))
                      : Icon(Icons.play_arrow_rounded, size: 55, color: Colors.purple.withOpacity(0.7)),
                ),
                InkWell(
                  onTap: _nextSong,
                  child: Icon(Icons.skip_next, size: 55, color: Colors.purple.withOpacity(0.6)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(1, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '$twoDigitMinutes:$twoDigitSeconds';
  }
}
