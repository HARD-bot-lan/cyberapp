import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import '../models/article.dart';
import '../utils/formatters.dart';

class ArticlePage extends StatelessWidget {
  final Article article;
  const ArticlePage({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(article.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => Share.share('Check out this article: ${article.title}'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCover(article.coverImage),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(article.title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(Formatters.formatDate(article.publishedAt ?? DateTime.now()), style: TextStyle(color: Colors.grey[600])),
                      const SizedBox(width: 16),
                      Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text('${article.readingTime ?? 0} min read', style: TextStyle(color: Colors.grey[600])),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    children: (article.tags ?? []).map((tag) => Chip(label: Text(tag))).toList(),
                  ),
                  const SizedBox(height: 16),
                  MarkdownBody(
                    data: article.content,
                    selectable: true,
                    styleSheet: MarkdownStyleSheet(
                      h1: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                      h2: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      h3: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      p: const TextStyle(fontSize: 16, height: 1.5),
                      code: TextStyle(
                        backgroundColor: Theme.of(context).brightness == Brightness.dark ? Colors.grey[800] : Colors.grey[200],
                        color: Theme.of(context).brightness == Brightness.dark ? Colors.greenAccent[200] : Colors.green[800],
                        fontFamily: 'monospace',
                      ),
                      codeblockDecoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[900] : const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[700]! : Colors.grey[300]!),
                      ),
                      codeblockPadding: const EdgeInsets.all(12),
                      blockquoteDecoration: BoxDecoration(
                        border: Border(left: BorderSide(color: Colors.blue, width: 4)),
                        color: Theme.of(context).brightness == Brightness.dark ? Colors.blueGrey[900] : Colors.blue[50],
                      ),
                    ),
                    imageBuilder: (uri, title, alt) {
                      final String url = uri.toString();
                      if (url.endsWith('.mp4')) {
                        if (kIsWeb) return const Text('Video cannot be played on web.');
                        return VideoPlayerWidget(url: url);
                      }
                      return CachedNetworkImage(imageUrl: url, placeholder: (_, __) => const CircularProgressIndicator(), errorWidget: (_, __, ___) => const Icon(Icons.broken_image));
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCover(String? url) {
    if (url == null || url.isEmpty) return const SizedBox.shrink();
    if (url.endsWith('.mp4')) {
      if (kIsWeb) return const Text('Video cannot be played on web.');
      return VideoPlayerWidget(url: url);
    } else {
      return CachedNetworkImage(
        imageUrl: url,
        width: double.infinity,
        fit: BoxFit.cover,
        placeholder: (_, __) => const SizedBox(height: 200, child: Center(child: CircularProgressIndicator())),
        errorWidget: (_, __, ___) => const Icon(Icons.broken_image, size: 48),
      );
    }
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final String url;
  const VideoPlayerWidget({super.key, required this.url});

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _loadVideo();
  }

  Future<void> _loadVideo() async {
    final file = await DefaultCacheManager().getSingleFile(widget.url);
    _controller = VideoPlayerController.file(file)
      ..initialize().then((_) {
        setState(() {
          _initialized = true;
          _controller.setLooping(true);
          _controller.play();
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) return const SizedBox(height: 200, child: Center(child: CircularProgressIndicator()));
    return GestureDetector(
      onTap: () => setState(() => _controller.value.isPlaying ? _controller.pause() : _controller.play()),
      child: AspectRatio(aspectRatio: _controller.value.aspectRatio, child: VideoPlayer(_controller)),
    );
  }
}
