import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/stream.dart';
import '../widgets/upcoming_stream.dart';

class StreamsPage extends StatefulWidget {
  const StreamsPage({super.key});

  @override
  State<StreamsPage> createState() => _StreamsPageState();
}

class _StreamsPageState extends State<StreamsPage> {
  late Future<List<AppStream>> _streamsFuture;

  @override
  void initState() {
    super.initState();
    _streamsFuture = fetchStreams();
  }

  Future<List<AppStream>> fetchStreams() async {
    const url =
        'https://raw.githubusercontent.com/cybersecma/CyberSecMain/refs/heads/youssef-remake/src/data/streams.json';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode != 200) {
        throw Exception('Failed to fetch streams: ${response.statusCode}');
      }

      final List<dynamic> list = json.decode(response.body);
      final streams = list.map((e) => AppStream.fromJson(e)).toList();

      return streams;
    } catch (e) {
      print('Error fetching streams: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<AppStream>>(
      future: _streamsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No streams available'));
        }

        final streams = snapshot.data!;

        return ListView.builder(
          itemCount: streams.length,
          itemBuilder: (context, index) {
            final stream = streams[index];
            return UpcomingStreamCard(stream: stream);
          },
        );
      },
    );
  }
}
