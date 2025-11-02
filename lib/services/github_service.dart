import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import '../models/article.dart';
import '../models/stream.dart'; // make sure this imports AppStream

class GitHubService {
  static const String baseUrl =
      'https://raw.githubusercontent.com/cybersecma/CyberSecMain/youssef-remake';
  static const String apiUrl = 'https://api.github.com/repos';
  String? repositoryPath; // Set to 'username/repo-name/branch'
  final Box _cache = Hive.box('articlesCache');


  String _getRepoPath() {
    return repositoryPath ?? 'cybersecma/CyberSecMain';
  }
  

  String _getBranch() {
    // Branch containing your articles
    return 'youssef-remake';
  }
  /// Fetch file names (stub or JSON from repo)
  Future<List<String>> fetchFileNames({String folder = 'src/posts/general'}) async {
    final url = '$apiUrl/${_getRepoPath()}/contents/$folder?ref=${_getBranch()}';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch file list: ${response.statusCode}');
    }

    final List<dynamic> data = jsonDecode(response.body);
    // Only return markdown files
    return data
        .where((item) => item['type'] == 'file' && item['name'].endsWith('.md'))
        .map<String>((item) => item['name'] as String)
        .toList();
  }

  /// Fetch markdown content
  Future<String> fetchMarkdown(String filePath) async {
    final url = '$baseUrl/src/posts/general/$filePath';
    final res = await http.get(Uri.parse(url));
    if (res.statusCode == 200) return res.body;
    throw Exception('Failed to fetch $filePath');
  }

  /// Parse markdown to Article
  Future<Article> fetchPostFromMarkdown(String markdown, String fileName) async {
    final Map<String, dynamic> frontmatter = {};
    String content = markdown;

    if (markdown.startsWith('---')) {
      final parts = markdown.split('---');
      if (parts.length >= 3) {
        final fmLines = parts[1].split('\n');
        for (var line in fmLines) {
          line = line.trim();
          if (line.isEmpty || !line.contains(':')) continue;
          final idx = line.indexOf(':');
          var key = line.substring(0, idx).trim();
          var value = line.substring(idx + 1).trim();
          if (value.startsWith('[') && value.endsWith(']')) {
            final list = value
                .substring(1, value.length - 1)
                .split(',')
                .map((e) => e.trim().replaceAll('"', '').replaceAll("'", ''))
                .toList();
            frontmatter[key] = list;
          } else if (value.toLowerCase() == 'true' || value.toLowerCase() == 'false') {
            frontmatter[key] = value.toLowerCase() == 'true';
          } else if (int.tryParse(value) != null) {
            frontmatter[key] = int.parse(value);
          } else {
            frontmatter[key] = value;
          }
        }
        content = parts.sublist(2).join('---').trim();
      }
    }

    return Article(
      title: frontmatter['title'] ?? fileName.replaceAll('.md', ''),
      slug: frontmatter['slug'],
      excerpt: frontmatter['excerpt'],
      author: frontmatter['author'],
      authorAvatar: frontmatter['authorAvatar'],
      authorRole: frontmatter['authorRole'],
      authorBio: frontmatter['authorBio'],
      publishedAt: frontmatter['publishedAt'] != null
          ? DateTime.tryParse(frontmatter['publishedAt'])
          : null,
      coverImage: frontmatter['coverImage'],
      thumbnail: frontmatter['thumbnail'],
      categories: frontmatter['categories'] != null
          ? List<String>.from(frontmatter['categories'])
          : null,
      tags: frontmatter['tags'] != null
          ? List<String>.from(frontmatter['tags'])
          : null,
      readingTime: frontmatter['readingTime'],
      pinned: frontmatter['pinned'],
      hide: frontmatter['hide'],
      content: content,
    );
  }

  /// Fetch all articles with optional cache
  Future<List<Article>> fetchArticles({bool forceRefresh = false}) async {
    if (!forceRefresh) {
      final cached = _cache.get('articles');
      if (cached != null) {
        final List list = jsonDecode(cached);
        return list.map((e) => Article.fromJson(e)).where((a) => a.hide == false || a.hide == 0).toList();
      }
    }

    final fileNames = await fetchFileNames();
    final List<Article> articles = [];

    for (final fileName in fileNames) {
      final markdown = await fetchMarkdown(fileName);
      final article = await fetchPostFromMarkdown(markdown, fileName);
      if (article.hide == false || article.hide == 0) {
        articles.add(article);
      }
    }

    // Cache articles
    _cache.put('articles', jsonEncode(articles.map((a) => a.toJson()).toList()));

    return articles;
  }
  /// Fetches streams from GitHub
 Future<List<AppStream>> fetchStreams() async {
  const url =
      'https://raw.githubusercontent.com/cybersecma/CyberSecMain/refs/heads/youssef-remake/src/data/streams.json';

  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch streams: ${response.statusCode}');
    }

    // Decode JSON directly
    final List<dynamic> list = json.decode(response.body);

    // Map to Dart objects
    final streams = list.map((e) => AppStream.fromJson(e)).toList();

    // Optional: print for debugging
    for (var s in streams) {
      print('${s.id}: ${s.title}');
    }

    print('✅ Loaded streams successfully');
    return streams;
  } catch (e) {
    print('Error fetching streams: $e');
    return [];
  }
}

}