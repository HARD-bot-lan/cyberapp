import 'package:flutter/material.dart';
import '../widgets/article_card.dart';
import '../services/github_service.dart';
import '../models/article.dart';
import 'article_page.dart';

class ArticlesPage extends StatefulWidget {
  const ArticlesPage({super.key});
  @override
  State<ArticlesPage> createState() => _ArticlesPageState();
}

class _ArticlesPageState extends State<ArticlesPage> {
  final GitHubService _githubService = GitHubService();
  List<Article> _articles = [];
  List<Article> _filteredArticles = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadArticles();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadArticles({bool forceRefresh = false}) async {
    setState(() => _isLoading = true);
    try {
      final articles = await _githubService.fetchArticles(forceRefresh: forceRefresh);
      setState(() {
        _articles = articles;
        _filteredArticles = articles;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error loading articles: $e')));
    }
  }

  void _filterArticles(String query) {
    if (query.isEmpty) {
      setState(() => _filteredArticles = _articles);
      return;
    }
    setState(() => _filteredArticles = _articles.where((a) => a.title.toLowerCase().contains(query.toLowerCase())).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Articles')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(hintText: 'Search articles...', prefixIcon: Icon(Icons.search), border: OutlineInputBorder()),
              onChanged: _filterArticles,
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredArticles.isEmpty
                    ? const Center(child: Text('No articles found'))
                    : RefreshIndicator(
                        onRefresh: () => _loadArticles(forceRefresh: true),
                        child: ListView.builder(
                          itemCount: _filteredArticles.length,
                          itemBuilder: (context, index) {
                            final article = _filteredArticles[index];
                            return ArticleCard(
                              article: article,
                              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ArticlePage(article: article))),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
