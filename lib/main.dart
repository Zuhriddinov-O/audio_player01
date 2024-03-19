import 'package:audio_player/main_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
            centerTitle: true,
            iconTheme: IconThemeData(color: CupertinoColors.white, applyTextScaling: true)),
        navigationBarTheme: const NavigationBarThemeData(
          indicatorColor: Colors.red,
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: CupertinoColors.black),
        useMaterial3: true,
      ),
      home: MainPage(),
    );
  }
}
