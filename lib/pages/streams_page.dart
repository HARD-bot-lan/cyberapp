import 'package:flutter/material.dart';
import '../models/stream.dart';
import '../widgets/upcoming_stream.dart';
import '../services/github_service.dart';

class StreamsPage extends StatelessWidget {
  const StreamsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final service = GitHubService(); // Instantiate the service

    return FutureBuilder<List<AppStream>>(
      future: service.fetchStreams(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show loading spinner
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // Show error message
          return Center(
            child: Text('Error fetching streams: ${snapshot.error}'),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          // No streams available
          return const Center(child: Text('No streams available'));
        } else {
          // Display the list of streams
          final streams = snapshot.data!;
          return ListView.builder(
            itemCount: streams.length,
            itemBuilder: (context, index) {
              final stream = streams[index];
              return UpcomingStreamCard(stream: stream);
            },
          );
        }
      },
    );
  }
}
