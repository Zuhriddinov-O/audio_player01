import 'package:audio_player/home_page.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int indexForBoth = 0;
  bool isLikedForBoth = false;
  List<int> list = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HomePage(
        indexForBoth: indexForBoth,
        isLikedForBoth: isLikedForBoth,
        list: list,
        likedList: [],
      ),
    );
  }
}
