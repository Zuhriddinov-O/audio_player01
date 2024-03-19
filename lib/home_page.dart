import 'dart:ui';

import 'package:audio_player/music_lib/musics_class.dart';
import 'package:audio_player/second_page.dart';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'likedPage.dart';

class HomePage extends StatefulWidget {
  HomePage({
    super.key,
    required this.indexForBoth,
    required this.isLikedForBoth,
    required this.list,
    required likedList,
  });


  int indexForBoth;
  bool isLikedForBoth;
  List likedList = [];
  List list;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String titleState = "Play Music";
  bool searchState = false;
  TextEditingController textEditingController = TextEditingController();
  String textField = "";
  List<Musics> _searchedMusic = [];

  @override
  void initState() {
    _searchedMusic = musicList;
    super.initState();
  }

  void _runFilter(String query) {
    List<Musics> results = [];
    if (query.isEmpty) {
      results = musicList;
    } else {
      results =
          musicList.where((element) => element.name.toLowerCase().contains(query.toLowerCase())).toList();
    }
    setState(() {
      _searchedMusic = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ColorfulSafeArea(
      color: Colors.white.withOpacity(1).withAlpha(1900).withRed(2000),
      filter: ImageFilter.blur(sigmaY: 20, sigmaX: 5),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          leading: searchState
              ? Padding(
                  padding: EdgeInsets.only(left: MediaQuery.of(context).size.width / 18),
                  child: IconButton(
                      onPressed: () {
                        textEditingController.clear();
                        textEditingController.clearComposing();
                        setState(() {
                          searchState = !searchState;
                        });
                      },
                      icon: const Icon(CupertinoIcons.clear_thick)),
                )
              : Padding(
                  padding: EdgeInsets.only(left: MediaQuery.of(context).size.width / 18),
                  child: IconButton(
                      onPressed: () {
                        textEditingController.clear();
                        setState(() {
                          searchState = !searchState;
                        });
                      },
                      icon: const Icon(
                        CupertinoIcons.search,
                        size: 30,
                      )),
                ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: MediaQuery.of(context).size.width / 18),
              child: IconButton(
                onPressed: () {
                  _searchedMusic[widget.indexForBoth].isLiked
                      ? widget.likedList.add(widget.indexForBoth)
                      : null;
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (context) {
                        return LikePage(
                          isLikedForBoth: widget.isLikedForBoth,
                          list: widget.list,
                          indexForBoth: widget.indexForBoth,
                          music: _searchedMusic[widget.indexForBoth],
                        );
                      },
                    ),
                  );
                },
                icon: const Icon(
                  Icons.data_saver_on_outlined,
                  color: CupertinoColors.white,
                  size: 28,
                ),
              ),
            ),
          ],
          title: searchState
              ? TextField(
                  style: const TextStyle(color: Colors.white),
                  smartDashesType: SmartDashesType.enabled,
                  showCursor: true,
                  textCapitalization: TextCapitalization.none,
                  textInputAction: TextInputAction.search,
                  controller: textEditingController,
                  onChanged: (value) {
                    _runFilter(value);
                  },
                  decoration: const InputDecoration(
                    focusColor: Colors.blue,
                  ),
                )
              : const Text(
                  "Play Music",
                  style: TextStyle(fontSize: 27),
                ),
          forceMaterialTransparency: true,
          foregroundColor: Colors.white,
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/background_images/background_img0.png"),
              fit: BoxFit.cover,
            ),
          ),
          height: MediaQuery.of(context).size.height,
          child: _searchedMusic.isEmpty
              ? const Center(
                  child: Icon(
                    CupertinoIcons.cloud_drizzle,
                    color: Colors.green,
                    size: 100,
                  ),
                )
              : ListView.builder(
                  itemCount: _searchedMusic.length,
                  itemBuilder: (context, index) {
                    widget.indexForBoth = index;
                    final music = _searchedMusic[widget.indexForBoth];
                    return ListTile(
                      onTap: () {
                        Navigator.of(context).push(
                          CupertinoPageRoute(
                            builder: (context) => SecondPage(
                              isLikedForBoth: _searchedMusic[index].isLiked,
                              musics: _searchedMusic[index],
                              indexForBoth: _searchedMusic[index].id,
                            ),
                          ),
                        );
                      },
                      leading: ClipRRect(
                          borderRadius: BorderRadius.circular(3),
                          child: Image.asset(
                            musicList[music.id].image,
                            fit: BoxFit.fill,
                            height: 50,
                            width: 50,
                          )),
                      title: Text(musicList[music.id].name, style: const TextStyle(color: Colors.white)),
                      subtitle:
                          Text(musicList[music.id].artis, style: const TextStyle(color: Colors.white70)),
                      trailing: SizedBox(
                        width: 80,
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                bool boolean = musicList[music.id].isLiked;
                                setState(() {
                                  boolean = !boolean;
                                  musicList[music.id].isLiked = boolean;
                                  widget.isLikedForBoth = boolean;

                                  musicList[music.id].isLiked == true
                                      ? widget.list.add(musicList[music.id].id)
                                      : widget.list.remove(musicList[music.id].id);
                                });
                              },
                              icon: musicList[music.id].isLiked
                                  ? const Icon(
                                      CupertinoIcons.heart_solid,
                                      color: CupertinoColors.systemRed,
                                      size: 28,
                                      applyTextScaling: true,
                                    )
                                  : const Icon(
                                      CupertinoIcons.suit_heart,
                                      color: CupertinoColors.white,
                                      size: 28,
                                      applyTextScaling: true,
                                    ),
                            ),
                            const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
