import 'package:flutter/material.dart';
import '../widgets/hero_section.dart';
import '../widgets/search_bar.dart' as widgets;
import '../widgets/featured_post.dart';
import '../widgets/article_card.dart';
import '../widgets/upcoming_stream.dart';
import '../services/github_service.dart';
import '../models/article.dart';
import '../models/stream.dart' as app_stream;
import 'article_page.dart';
import 'streams_page.dart';
import 'articles_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GitHubService _githubService = GitHubService();
  List<Article> _featuredArticles = [];
  List<Article> _recentArticles = [];
  List<app_stream.AppStream> _upcomingStreams = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final allArticles = await _githubService.fetchArticles();
      final streams = await _githubService.fetchStreams();
      print('Fetched ${streams.length} streams');
      setState(() {
        _featuredArticles =
            allArticles.where((a) => a.pinned == true).toList();
        _recentArticles = List.from(allArticles)
          ..sort((a, b) =>
              (b.publishedAt ?? DateTime(0))
                  .compareTo(a.publishedAt ?? DateTime(0)));
        _upcomingStreams = streams
            .where((s) => s.type == 'upcoming')
            .take(3)
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading data: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: CustomScrollView(
                slivers: [
                  const SliverToBoxAdapter(child: HeroSection()),
                  SliverToBoxAdapter(
                    child: widgets.SearchBar(
                      onTap: () {
                        
                      },
                    ),
                  ),
                  if (_featuredArticles.isNotEmpty)
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Text(
                          'Featured',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  if (_featuredArticles.isNotEmpty)
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => FeaturedPost(
                          article: _featuredArticles[index],
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ArticlePage(
                                    article: _featuredArticles[index]),
                              ),
                            );
                          },
                        ),
                        childCount: _featuredArticles.length,
                      ),
                    ),
                  if (_upcomingStreams.isNotEmpty)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Upcoming Streams',
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const StreamsPage()),
                                );
                              },
                              child: const Text('View All'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => UpcomingStreamCard(
                        stream: _upcomingStreams[index],
                      ),
                      childCount: _upcomingStreams.length,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Recent Articles',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const ArticlesPage()),
                              );
                            },
                            child: const Text('View All'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => ArticleCard(
                        article: _recentArticles[index],
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ArticlePage(article: _recentArticles[index]),
                            ),
                          );
                        },
                      ),
                      childCount:
                          _recentArticles.length > 5 ? 5 : _recentArticles.length,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
