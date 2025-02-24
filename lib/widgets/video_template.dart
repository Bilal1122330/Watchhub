import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoTemplate extends StatefulWidget {
  const VideoTemplate({
    super.key,
    required this.body,
    required this.videoPath,
  });
  final Widget body;
  final String videoPath;

  @override
  State<VideoTemplate> createState() => _VideoTemplateState();
}

class _VideoTemplateState extends State<VideoTemplate> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.videoPath);
    _initializeVideoPlayerFuture = _controller.initialize().then((_) {
      _controller
        ..setVolume(0)
        ..setLooping(true)
        ..play();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Stack(
            children: [
              SizedBox.expand(
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: SizedBox(
                    width: _controller.value.size.width,
                    height: _controller.value.size.height,
                    child: VideoPlayer(_controller),
                  ),
                ),
              ),
              SizedBox.expand(
                child: widget.body,
              ),
            ],
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
