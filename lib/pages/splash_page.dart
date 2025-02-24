import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:watch_hub/routes/app_routes.dart';
import 'package:watch_hub/widgets/body_landscape.dart';
import 'package:watch_hub/widgets/video_template.dart';



class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  int counter = 0;
  Random rnd = Random();
  String saying = "";
  List<String> sayings = [
    "#Markhor🦌",
    "#MeTheLoneWolf🐺",
    "#thuglife☠️👽⚔️🔪⛓",
    "#nothingbox🙇🤷🏽‍♂️🕸🎁",
    "#hakunamatata🐅",
    "#maulahjat🏋🏾‍⚔",
    "#deadman💀⚰️",
    "#deadwillriseagain⚔",
    "#istandalone👑",
    "#istandaloneforjustic🐅☘️",
    "#nøfate⚓️🚀⚰️",
    "#bornfreeandwild👅💪",
    "#bornfreeandlivefree🐅🐆🐈",
    "#brutaltactician🎖",
    "#holysinner🕊",
    "#devilhunter😇",
    "#khalaimakhlooq👻☠️😈🦅👽",
    "#aakhrichittan👻🚶🏽‍♂️🦁🐆🐅🌊🧗🏼‍♂️🥇🎖🏆🗻",
    "#KoiJalGiaKisiNayDuaDi👤🔥🎃☠️🤯😇🙏📦",
    "#ZakhmiDillJallaDon🤦🏻‍♂️🤕🔥💔👿☠️👻",
    "#WhatHappensToTheSoulsWhoLookInTheEyesOfDragon🦖🐉☃️🌊⛈💥🔥🌪🐲☠️👻"
  ];

  void loadingStatus() {
    Future.delayed(const Duration(seconds: 2)).then((_) {
      setState(() {
        counter += 25;
        saying = sayings[rnd.nextInt(18)];
      });
      loadingStatus();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    loadingStatus();
    Timer(
        const Duration(seconds: 8),
        () => Navigator.popAndPushNamed(context, PageRoutes.homePage));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      body: OrientationBuilder(builder: (context, orientation) {
        if (orientation == Orientation.portrait) {
          return getBoyPortrait();
        } else {
          return const BodyLandscape();
        }
      }),
    );
  }

  Widget getBoyPortrait() {
    return VideoTemplate(body: fillBody(), videoPath: "assets/media/back_video/watch1.mp4");
  }

  Widget fillBody(){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            elevation: 2,
            color: Colors.black54,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const CircularProgressIndicator(
                    strokeWidth: 10,
                    backgroundColor: Colors.orangeAccent,
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.yellowAccent),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text('$counter'),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                      width: 200,
                      child: Text(
                        saying,
                        overflow: TextOverflow.clip,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                      ))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }


}
