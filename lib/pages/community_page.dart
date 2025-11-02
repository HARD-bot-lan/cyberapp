import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CommunityPage extends StatelessWidget {
  const CommunityPage({super.key});

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Community'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Join Our Community',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Connect with cybersecurity professionals, share knowledge, and stay updated with the latest in cybersecurity.',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            const SizedBox(height: 32),
            _buildCommunityLink(
              context,
              Icons.code,
              'GitHub',
              'Contribute to our open-source projects',
              () => _launchUrl('https://github.com'),
            ),
            _buildCommunityLink(
              context,
              Icons.alternate_email,
              'Twitter/X',
              'Follow us for updates and news',
              () => _launchUrl('https://twitter.com'),
            ),
            _buildCommunityLink(
              context,
              Icons.work,
              'LinkedIn',
              'Connect with professionals',
              () => _launchUrl('https://linkedin.com'),
            ),
            _buildCommunityLink(
              context,
              Icons.chat,
              'Discord',
              'Join our Discord server',
              () => _launchUrl('https://discord.com'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommunityLink(
    BuildContext context,
    IconData icon,
    String title,
    String description,
    VoidCallback onTap,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: Icon(icon, size: 32, color: Theme.of(context).primaryColor),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(description),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}
