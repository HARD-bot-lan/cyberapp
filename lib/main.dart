import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'pages/about_page.dart';
import 'pages/articles_page.dart';
import 'pages/streams_page.dart';
import 'pages/breaches_page.dart';
import 'pages/community_page.dart';
import 'pages/home_page.dart';
import 'pages/not_found_page.dart';

class AppColors {
  // Main colors
  static const red100 = Color(0xFFef4444);
  static const red200 = Color(0xFFFF3333);
  static const red300 = Color(0xFFb91c1c);

  static const gray100 = Color(0xFFFFFFFF);
  static const gray200 = Color(0xFFF0F0F0);
  static const gray300 = Color(0xFFE5E7EB);
  static const gray400 = Color(0xFFD1D5DB);
  static const gray500 = Color(0xFFD4D4D4);
  static const gray600 = Color(0xFFB0B0B0);
  static const gray700 = Color(0xFF1E1E1E);
  static const gray800 = Color(0xFF131313);
  static const gray900 = Color(0xFF0A0A0A);
  static const gray1000 = Color(0xFF000000);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('articlesCache');

  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('Firebase initialization error: $e');
  }

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CyberSec App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.red100,
          primary: AppColors.red100,
          secondary: AppColors.gray700,
          background: AppColors.gray200,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: AppColors.gray200,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.red100,
          foregroundColor: AppColors.gray100,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.gray100,
          selectedItemColor: AppColors.red100,
          unselectedItemColor: AppColors.gray700,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColors.red200,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: AppColors.gray900),
          bodySmall: TextStyle(color: AppColors.gray700),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.red300,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: AppColors.gray900,
      ),
      themeMode: ThemeMode.system,
      home: const MainNavigation(),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const ArticlesPage(),
    const StreamsPage(),
    const BreachesPage(),
    const CommunityPage(),
    const AboutPage(),
    const NotFoundPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.article_outlined),
            selectedIcon: Icon(Icons.article),
            label: 'Articles',
          ),
          NavigationDestination(
            icon: Icon(Icons.video_library_outlined),
            selectedIcon: Icon(Icons.video_library),
            label: 'Streams',
          ),
          NavigationDestination(
            icon: Icon(Icons.warning_outlined),
            selectedIcon: Icon(Icons.warning),
            label: 'Breaches',
          ),
          NavigationDestination(
            icon: Icon(Icons.group_outlined),
            selectedIcon: Icon(Icons.group),
            label: 'Community',
          ),
          NavigationDestination(
            icon: Icon(Icons.info_outline),
            selectedIcon: Icon(Icons.info),
            label: 'About',
          ),
        ],
      ),
    );
  }
}
