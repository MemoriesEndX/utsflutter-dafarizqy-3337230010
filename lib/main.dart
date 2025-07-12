// main.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uts/views/post_preview.dart';

void main() {
  runApp(const MyUts());
}

class MyUts extends StatelessWidget {
  const MyUts({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Dafa Rizqy_3337230010',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Define a modern blue color scheme
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          primary: Colors.blue,
          onPrimary: Colors.white,
          secondary: Colors.lightBlueAccent,
          onSecondary: Colors.white,
          surface: Colors.grey.shade100,
          onSurface: Colors.grey.shade800,
          background: Colors.grey.shade100,
          onBackground: Colors.grey.shade800,
          error: Colors.redAccent,
          onError: Colors.white,
          brightness: Brightness.light,
        ),
        useMaterial3: true, // Enable Material 3 design
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          elevation: 2,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        // --- FIX HERE: Changed CardTheme to CardThemeData ---
        cardTheme: CardThemeData(
          // Changed from CardTheme to CardThemeData
          color: Colors.white,
          surfaceTintColor: Colors.transparent,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
          ),
        ),
        listTileTheme: ListTileThemeData(
          tileColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          leadingAndTrailingTextStyle: TextStyle(color: Colors.blue),
        ),
        iconTheme: const IconThemeData(color: Colors.blue),
      ),
      home: const PostView(),
    );
  }
}
