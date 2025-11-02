import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/article.dart';

class AuthorBio extends StatelessWidget {
  final Article article;

  const AuthorBio({
    super.key,
    required this.article,
  });

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.authorAvatar != null)
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(article.authorAvatar!),
              )
            else
              CircleAvatar(
                radius: 30,
                child: Text(
                  article.author![0].toUpperCase(),
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (article.author != null)
                    Text(
                      article.author!,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  if (article.authorBio != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      article.authorBio!,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
