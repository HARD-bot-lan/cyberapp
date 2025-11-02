class Article {
  final String title;
  final String? slug;
  final String? excerpt;
  final String? author;
  final String? authorAvatar;
  final String? authorRole;
  final String? authorBio;
  final DateTime? publishedAt;
  final String? coverImage;
  final String? thumbnail;
  final List<String>? categories;
  final List<String>? tags;
  final int? readingTime;
  final bool? pinned;
  final dynamic hide; // keep dynamic if you have 0 or false
  final String content;

  Article({
    required this.title,
    this.slug,
    this.excerpt,
    this.author,
    this.authorAvatar,
    this.authorRole,
    this.authorBio,
    this.publishedAt,
    this.coverImage,
    this.thumbnail,
    this.categories,
    this.tags,
    this.readingTime,
    this.pinned,
    this.hide,
    required this.content,
  });

  /// From JSON
  factory Article.fromJson(Map<String, dynamic> json) => Article(
        title: json['title'] ?? '',
        slug: json['slug'],
        excerpt: json['excerpt'],
        author: json['author'],
        authorAvatar: json['authorAvatar'],
        authorRole: json['authorRole'],
        authorBio: json['authorBio'],
        publishedAt: json['publishedAt'] != null
            ? DateTime.tryParse(json['publishedAt'])
            : null,
        coverImage: json['coverImage'],
        thumbnail: json['thumbnail'],
        categories: json['categories'] != null
            ? List<String>.from(json['categories'])
            : null,
        tags: json['tags'] != null ? List<String>.from(json['tags']) : null,
        readingTime: json['readingTime'],
        pinned: json['pinned'],
        hide: json['hide'],
        content: json['content'] ?? '',
      );

  /// To JSON
  Map<String, dynamic> toJson() => {
        'title': title,
        'slug': slug,
        'excerpt': excerpt,
        'author': author,
        'authorAvatar': authorAvatar,
        'authorRole': authorRole,
        'authorBio': authorBio,
        'publishedAt': publishedAt?.toIso8601String(),
        'coverImage': coverImage,
        'thumbnail': thumbnail,
        'categories': categories,
        'tags': tags,
        'readingTime': readingTime,
        'pinned': pinned,
        'hide': hide,
        'content': content,
      };
}
