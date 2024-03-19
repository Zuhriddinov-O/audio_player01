import 'dart:ui';

import 'package:audio_player/liked_page_details.dart';
import 'package:audio_player/music_lib/musics_class.dart';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LikePage extends StatefulWidget {
  LikePage({
    super.key,
    required this.indexForBoth,
    required this.music,
    required this.list,
    required this.isLikedForBoth,
  });

  Musics music;
  int indexForBoth;
  bool isLikedForBoth;

  List list = [];

  @override
  State<LikePage> createState() => _LikePageState();
}

class _LikePageState extends State<LikePage> {
  @override
  Widget build(BuildContext context) {
    return ColorfulSafeArea(
      color: Colors.white.withOpacity(1).withAlpha(1900).withRed(2000),
      filter: ImageFilter.blur(sigmaY: 20, sigmaX: 5),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          forceMaterialTransparency: true,
          title: const Text(
            "Favorites",
            style: TextStyle(fontSize: 27),
          ),
          foregroundColor: Colors.white,
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/background_images/background_img2.png"),
              fit: BoxFit.cover,
            ),
          ),
          height: MediaQuery.of(context).size.height,
          child: widget.list.isEmpty
              ? const Center(
                  child: Icon(
                    CupertinoIcons.cloud_drizzle,
                    color: Colors.green,
                    size: 100,
                  ),
                )
              : ListView.builder(
                  itemCount: widget.list.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        Navigator.of(context).push(
                          CupertinoPageRoute(
                            builder: (context) => LikedPageDetails(
                              isLikedForBoth: musicList[index].isLiked,
                              musics: musicList[widget.list[index]],
                              indexForBoth: musicList[widget.list[index]].id,
                            ),
                          ),
                        );
                      },
                      leading: ClipRRect(
                          borderRadius: BorderRadius.circular(3),
                          child: Image.asset(
                            musicList[widget.list[index]].image,
                            fit: BoxFit.fill,
                            height: 50,
                            width: 50,
                          )),
                      title: Text(musicList[widget.list[index]].name,
                          style: const TextStyle(color: Colors.white)),
                      subtitle: Text(musicList[widget.list[index]].artis,
                          style: const TextStyle(color: Colors.white70)),
                      trailing: SizedBox(
                        width: 80,
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                bool boolean = musicList[widget.list[index]].isLiked;
                                setState(() {
                                  boolean = !boolean;
                                  musicList[widget.list[index]].isLiked = boolean;
                                  widget.isLikedForBoth = boolean;

                                  musicList[widget.list[index]].isLiked == true
                                      ? widget.list.add(musicList[widget.list[index]].id)
                                      : widget.list.remove(musicList[widget.list[index]].id);
                                });
                              },
                              icon: musicList[widget.list[index]].isLiked
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
