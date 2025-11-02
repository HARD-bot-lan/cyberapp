# Cybersec Events Flutter App

A Flutter mobile application for cybersecurity content, articles, live streams, and breach alerts. Converted from a React web application.

## Features

- 📱 **Home Page** - Featured articles and upcoming streams
- 📰 **Articles** - Browse all cybersecurity articles with search functionality
- 🎥 **Streams** - View upcoming and completed live streams
- ⚠️ **Breaches** - Data breach alerts and information
- 🔍 **Search** - Search across articles, tags, and content
- 👥 **Community** - Links to community platforms
- ℹ️ **About** - Information about the app

## Setup Instructions

### 1. Prerequisites

Make sure you have Flutter installed. If not, follow the [Flutter installation guide](https://docs.flutter.dev/get-started/install).

### 2. Install Dependencies

Run the following command in the project root:

```bash
flutter pub get
```

### 3. Firebase Configuration

This app uses Firebase Firestore for data storage. You need to:

1. Create a Firebase project at [Firebase Console](https://console.firebase.google.com/)
2. Enable **Cloud Firestore** in your Firebase project
3. Add your Android/iOS app to the Firebase project
4. Download the configuration files:
   - **Android**: Place `google-services.json` in `android/app/`
   - **iOS**: Place `GoogleService-Info.plist` in `ios/Runner/`
5. Configure Firestore security rules (see below)
6. Configure Firebase in your code (see `lib/main.dart`)

**Firestore Collections Structure:**

```
Collection: posts
  Document: {postId}
    Fields:
      id: string
      title: string
      slug: string
      description: string
      content: string
      coverImage: string (optional)
      category: string
      tags: array<string>
      date: timestamp or string (ISO 8601)
      author: map {
        name: string
        bio: string (optional)
        avatar: string (optional)
        github: string (optional)
        twitter: string (optional)
        linkedin: string (optional)
      } (optional)
      featured: boolean
      readTime: number (optional)
      youtubeId: string (optional)

Collection: streams
  Document: {streamId}
    Fields:
      id: string
      title: string
      description: string
      scheduledDate: timestamp (Firestore Timestamp)
      youtubeId: string (optional)
      thumbnail: string (optional)
      status: string ("upcoming" | "live" | "completed")
      metadata: map (optional)

Collection: breaches
  Document: {breachId}
    Fields:
      id: string
      name: string
      description: string
      breachDate: timestamp (Firestore Timestamp)
      recordsLost: number (optional)
      organization: string (optional)
      severity: string (optional)
      source: string (optional)
      affectedData: array<string> (optional)
```

**Firestore Security Rules (for development):**

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Allow read access to all users
    match /{document=**} {
      allow read: if true;
      allow write: if false; // Disable writes from client for security
    }
  }
}
```

For production, implement proper authentication and security rules.

### 4. GitHub Configuration

For fetching markdown files from GitHub:

1. Update the repository path in `lib/services/github_service.dart`:
   ```dart
   String? repositoryPath; // Set to 'username/repo-name/branch'
   ```

2. The service expects markdown files at paths like:
   - `src/posts/general/{slug}.md`
   - `src/posts/{category}/{slug}.md`

### 5. Run the App

```bash
flutter run
```

## Project Structure

```
lib/
├── main.dart                 # App entry point with navigation
├── models/                   # Data models
│   ├── article.dart
│   ├── stream.dart
│   └── breach.dart
├── services/                 # Backend services
│   ├── firebase_service.dart
│   └── github_service.dart
├── pages/                    # App screens
│   ├── home_page.dart
│   ├── articles_page.dart
│   ├── article_page.dart
│   ├── streams_page.dart
│   ├── breaches_page.dart
│   ├── search_page.dart
│   ├── about_page.dart
│   ├── community_page.dart
│   └── not_found_page.dart
├── widgets/                  # Reusable widgets
│   ├── article_card.dart
│   ├── featured_post.dart
│   ├── hero_section.dart
│   ├── search_bar.dart
│   ├── youtube_embed.dart
│   ├── upcoming_stream.dart
│   ├── author_bio.dart
│   └── breaches_table.dart
└── utils/                    # Utility functions
    └── formatters.dart
```

## Dependencies

- `firebase_core` - Firebase initialization
- `cloud_firestore` - Firestore database access
- `http` - HTTP requests for GitHub API
- `flutter_markdown_plus` - Markdown rendering (replacement for discontinued flutter_markdown)
- `youtube_player_flutter` - YouTube video embedding
- `url_launcher` - Opening external URLs
- `cached_network_image` - Image caching
- `intl` - Date/number formatting
- `provider` - State management (optional)
- `share_plus` - Sharing functionality

## Notes

- The app fetches article content from both Firestore and GitHub
- Firestore timestamps are automatically converted to DateTime objects
- For better search functionality, consider integrating Algolia or Elasticsearch
- Markdown files should have frontmatter for metadata
- YouTube embeds require a valid video ID
- Make sure to configure Firebase properly before running

## License

[Your License Here]