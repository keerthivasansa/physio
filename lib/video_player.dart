import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ChewiePlayer extends StatefulWidget {
  final String videoUrl;

  const ChewiePlayer({super.key, required this.videoUrl});

  @override
  _ChewieVideoPlayerScreenState createState() =>
      _ChewieVideoPlayerScreenState();
}

class _ChewieVideoPlayerScreenState extends State<ChewiePlayer> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  bool _isPlayerReady = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    Uri uri = Uri.parse(widget.videoUrl);
    print("Initializing video player with URL: ${widget.videoUrl}");
    _videoPlayerController = VideoPlayerController.networkUrl(uri);

    await _videoPlayerController.initialize();
    print("Video player initialized");

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: false,
      looping: true,
    );

    setState(() {
      _isPlayerReady = true; // Player is ready to show
      print("Player is ready");
    });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isPlayerReady
        ? Chewie(controller: _chewieController)
        : Center(child: CircularProgressIndicator());
  }
}
