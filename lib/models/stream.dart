class AppStream {
  final String id;
  final String title;
  final String description;
  final String videoId;
  final String date; // ISO string
  final String duration;
  final String host;
  final List<String> tags;
  final String type; // 'upcoming' or 'past'

  late final DateTime scheduledDate;
  late final String formattedDate;

  AppStream({
    required this.id,
    required this.title,
    required this.description,
    required this.videoId,
    required this.date,
    required this.duration,
    required this.host,
    required this.tags,
    required this.type,
  }) {
    // Parse once
    scheduledDate = DateTime.parse(date);
    formattedDate =
        '${scheduledDate.month.toString().padLeft(2,'0')}/${scheduledDate.day.toString().padLeft(2,'0')}/${scheduledDate.year} • ${scheduledDate.hour.toString().padLeft(2,'0')}:${scheduledDate.minute.toString().padLeft(2,'0')}';
  }

  factory AppStream.fromJson(Map<String, dynamic> json) {
    return AppStream(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      videoId: json['videoId'] as String,
      date: json['date'] as String,
      duration: json['duration'] as String,
      host: json['host'] as String,
      tags: (json['tags'] as List<dynamic>).cast<String>(),
      type: json['type'] as String,
    );
  }
}
