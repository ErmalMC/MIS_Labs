// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/api_service.dart';
import 'services/favorites_service.dart';
import 'services/notification_service.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();

  runApp(const MealApp());

  // schedule after app launched — wrapped in try/catch and non-blocking
  Future.microtask(() async {
    try {
      final now = DateTime.now();
      await NotificationService().scheduleDailyNotification(
        hour: now.hour,
        minute: (now.minute + 1) % 60, // 1 min from now
        exact: true,
      );
      debugPrint('Notification scheduled for 1 minute from now');
    } catch (e, st) {
      debugPrint('Notification scheduling failed: $e\n$st');
    }
  });
}

class MealApp extends StatelessWidget {
  const MealApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ApiService>(create: (_) => ApiService()),
        Provider<FavoritesService>(create: (_) => FavoritesService()),
      ],
      child: MaterialApp(
        title: 'MealDB',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.teal),
        home: const HomeScreen(),
      ),
    );
  }
}
