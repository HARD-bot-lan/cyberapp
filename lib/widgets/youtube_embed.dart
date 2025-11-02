import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YouTubeEmbed extends StatefulWidget {
  final String videoId;
  final bool showControls;
  final double aspectRatio;

  const YouTubeEmbed({
    super.key,
    required this.videoId,
    this.showControls = true,
    this.aspectRatio = 16 / 9,
  });

  @override
  State<YouTubeEmbed> createState() => _YouTubeEmbedState();
}

class _YouTubeEmbedState extends State<YouTubeEmbed> {
  late final YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        controlsVisibleAtStart: widget.showControls,
      ),
    );
  }

  @override
  void didUpdateWidget(covariant YouTubeEmbed oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update controller if videoId changes
    if (oldWidget.videoId != widget.videoId) {
      _controller.load(widget.videoId);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: YoutubePlayerBuilder(
        player: YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: true,
          progressIndicatorColor: Theme.of(context).primaryColor,
        ),
        builder: (context, player) {
          return AspectRatio(
            aspectRatio: widget.aspectRatio,
            child: player,
          );
        },
      ),
    );
  }
}
