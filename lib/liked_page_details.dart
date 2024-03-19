import 'dart:math';
import 'dart:ui';
import 'package:audio_player/music_lib/musics_class.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LikedPageDetails extends StatefulWidget {
  LikedPageDetails({
    super.key,
    required this.musics,
    required this.indexForBoth,
    required this.isLikedForBoth,
  });

  List likedList = [];
  Musics musics;
  int indexForBoth;
  bool isLikedForBoth;

  @override
  State<LikedPageDetails> createState() => _LikedPageDetailsState();
}

class _LikedPageDetailsState extends State<LikedPageDetails> with TickerProviderStateMixin {
  late AnimationController animationController;
  late AudioPlayer audioPlayer;
  Duration maxDuration = const Duration(seconds: 0);
  late ValueListenable<Duration> progress;

  @override
  void initState() {
    audioPlayer = AudioPlayer();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );
    super.initState();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  getDuration() {
    audioPlayer.getDuration().then((value) {
      maxDuration = value ?? const Duration(seconds: 0);
      setState(() {});
    });
  }

  List colors = [
    0xff2b2b2b,
    0xff7ab3ef,
    0xfF4D2DFF,
    0xff1666ba,
  ];
  Random random = Random();
  int _index = 0;

  void changeIndex() {
    setState(() {
      _index = random.nextInt(3);
    });
  }

  @override
  Widget build(BuildContext context) {
    getDuration();
    return ColorfulSafeArea(
      color: Colors.white.withOpacity(1).withAlpha(1900).withRed(2000),
      filter: ImageFilter.blur(sigmaY: 20, sigmaX: 5),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
            actions: [
              IconButton(
                onPressed: () {
                  bool boolean = musicList[widget.musics.id].isLiked;
                  setState(
                    () {
                      boolean = !boolean;
                      widget.isLikedForBoth = boolean;
                      // +4
                      musicList[widget.musics.id].isLiked ? widget.likedList.add(widget.indexForBoth) : null;
                    },
                  );
                },
                icon: widget.isLikedForBoth
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
            ],
            title: Text(
              audioPlayer.state == PlayerState.playing ? musicList[widget.indexForBoth].name : "Play Music",
              style: const TextStyle(fontSize: 27, color: Colors.white),
            ),
            forceMaterialTransparency: true,
            foregroundColor: Colors.white70),
        body: Container(
          decoration:  BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/background_images/background_img2.png"),
              fit: BoxFit.cover,
            ),
          ),
          height: MediaQuery.of(context).size.height,
          child: ListView(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    child: SpinKitWaveSpinner(
                      color: Color(colors[_index]),
                      size: MediaQuery.of(context).size.longestSide / 3,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(MediaQuery.of(context).size.width / 4),
                    child: CircleAvatar(
                      minRadius: MediaQuery.of(context).size.width / 3.5,
                      foregroundImage: AssetImage(
                        musicList[widget.indexForBoth].image,
                        // opacity: const AlwaysStoppedAnimation(0.9),
                      ),
                    ),
                  ),
                ],
              ),
              Text(musicList[widget.indexForBoth].name,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontSize: 30),
                  textAlign: TextAlign.center),
              Text(musicList[widget.indexForBoth].artis,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w400),
                  textAlign: TextAlign.center),
              StreamBuilder(
                stream: audioPlayer.onPositionChanged,
                builder: (context, snapshot) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 18),
                    child: ProgressBar(
                      progressBarColor: Colors.red,
                      timeLabelType: TimeLabelType.totalTime,
                      thumbColor: CupertinoColors.white,
                      thumbGlowColor: Colors.blue,
                      timeLabelTextStyle: const TextStyle(color: CupertinoColors.white),
                      onSeek: (duration) {
                        audioPlayer.seek(duration);
                        setState(() {});
                        if (audioPlayer.state == PlayerState.completed) {
                          musicList[widget.musics.id];
                          setState(() {});
                        }
                      },
                      progress: snapshot.data ?? const Duration(seconds: 0),
                      total: maxDuration,
                    ),
                  );
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      if (widget.indexForBoth > 0) {
                        setState(
                          () {
                            widget.indexForBoth--;
                            changeIndex();
                            audioPlayer.play(AssetSource(musicList[widget.indexForBoth].music));
                          },
                        );
                      }
                    },
                    icon: Image.asset("assets/backward_icon.png",
                        width: 50, height: 50, color: CupertinoColors.white),
                  ),
                  IconButton(
                    onPressed: playOrStop,
                    icon: audioPlayer.state == PlayerState.playing
                        ? Image.asset("assets/pause.png",
                            width: 50, height: 50, color: CupertinoColors.white, fit: BoxFit.cover)
                        : Image.asset("assets/play.png",
                            width: 50, height: 50, color: CupertinoColors.white, fit: BoxFit.cover),
                  ),
                  IconButton(
                    onPressed: () {
                      changeIndex();
                      if (widget.indexForBoth < musicList.length - 1) {
                        setState(() {
                          changeIndex();
                          widget.indexForBoth++;
                        });
                        audioPlayer.play(AssetSource(musicList[widget.indexForBoth].music));
                      } else {
                        setState(() {
                          changeIndex();
                          // widget.indexForBoth = 0;
                        });
                      }
                    },
                    icon: Image.asset("assets/forward_icon.png",
                        width: 50, height: 50, color: CupertinoColors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void playOrStop() async {
    if (audioPlayer.state == PlayerState.playing) {
      await audioPlayer.pause();
      animationController.stop();
    } else {
      animationController.repeat();
      await audioPlayer.play(AssetSource(musicList[widget.indexForBoth].music));
    }
    setState(() {});
  }
}
