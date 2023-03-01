import 'dart:async';

import 'package:didier/AdHelper.dart';
import 'package:didier/chat_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class ThirdScreen extends StatefulWidget {
  const ThirdScreen({Key? key}) : super(key: key);

  @override
  State<ThirdScreen> createState() => _ThirdScreenState();
}

const int maxFailedLoadAttempts = 3;

class _ThirdScreenState extends State<ThirdScreen> {
  InterstitialAd? interstitialAd;
  int numInterstitialLoadAttempts = 0;
  var adCompleter = Completer<void>();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    await createInterstitialAd();
  }

  createInterstitialAd() async {
    await InterstitialAd.load(
        adUnitId: AdHelper.interstitialAdUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            print('$ad loaded 000000');
            interstitialAd = ad;
            numInterstitialLoadAttempts = 0;
            interstitialAd!.setImmersiveMode(true);
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load0000: $error.');
            numInterstitialLoadAttempts += 1;
            interstitialAd = null;
            if (numInterstitialLoadAttempts < maxFailedLoadAttempts) {
              createInterstitialAd();
            }
          },
        ));
    await adCompleter.future;
  }

  void showInterstitialAd() {


    if (interstitialAd == null) {
      print('Warning 000 111 : attempt to show interstitial before loaded.');
      return;
    }
    interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) {
        print('$ad show ad......00');
      },
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('$ad  dismiss ad.....00');
        ad.dispose();
        createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad faild.....: $error');
        ad.dispose();
        createInterstitialAd();
      },
    );
    interstitialAd!.show();
    interstitialAd = null;
  }

  @override
  void dispose() {
    super.dispose();
    interstitialAd?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 0.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('images/i2.png'),
                  SizedBox(height: 15.0),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 50, horizontal: 36),
                      child: Text(
                        "Press and hold the microphone icon to request images from Didier",
                        style: TextStyle(
                          fontSize: 17.0,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // if (interstitialAd != null) {
                      //   showInterstitialAd();
                      //   Future.delayed(Duration(milliseconds: 1000), () {
                      //     Get.to(ChatScreen());
                      //   });
                      // } else {
                      //   print('hsgyfsgffuds');
                      //   Get.to(ChatScreen());
                      // }
                      showInterstitialAd();
                      Future.delayed(Duration(milliseconds: 5000), () {
                        Get.to(ChatScreen());
                      });
                    },
                    child: Container(
                      height: 50.0,
                      width: 200.0,
                      decoration: BoxDecoration(
                        border: Border.all(color: Color.fromRGBO(183, 4, 4, 1)),
                        color: Color.fromRGBO(183, 4, 4, 1),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Center(
                          child: Text(
                        'Get Started'.toUpperCase(),
                        style: TextStyle(
                            fontSize: 15.0,
                            fontFamily: 'Poppins',
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      )),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
