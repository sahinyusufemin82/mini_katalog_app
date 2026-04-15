// 🚀 Uygulama Giriş Noktası — Dark Mode destekli

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/home_screen.dart';

// Global tema notifier — Provider olmadan dark mode yönetimi
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const MiniKatalogApp());
}

class MiniKatalogApp extends StatelessWidget {
  const MiniKatalogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, mode, _) {
        return MaterialApp(
          title: 'Mini Katalog',
          debugShowCheckedModeBanner: false,
          themeMode: mode,

          // ── Açık Tema ──
          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF0071E3),
              brightness: Brightness.light,
            ),
            scaffoldBackgroundColor: const Color(0xFFF5F5F7),
          ),

          // ── Koyu Tema ──
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF0A84FF),
              brightness: Brightness.dark,
            ),
            scaffoldBackgroundColor: const Color(0xFF1C1C1E),
          ),

          home: const HomeScreen(),
        );
      },
    );
  }
}
