import 'dart:async';

import 'package:app_review/app_review.dart';
import 'package:didier/AdHelper.dart';
import 'package:didier/adController.dart';
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

class _ThirdScreenState extends State<ThirdScreen> {
  AdController adc = Get.put(AdController());

  @override
  void initState() {
    super.initState();
    AppReview.getAppID.then(log);
  }

  String appID = "";

  String output = "";

  @override
  void dispose() {
    super.dispose();
    // interstitialAd?.dispose();
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
                      if (adc.interstitialAd != null) {
                        adc.showInterstitialAd(() {
                          Get.to(ChatScreen());
                        });
                      } else {
                        Get.to(ChatScreen());
                      }
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
                  SizedBox(
                    height: 20.0,
                  ),
                  // GestureDetector(
                  //   onTap: () {
                  //     // print("*****${AppReview.requestReview.then(log)}");
                  //     // print("**l***${log}");
                  //     // print("**a***${appID}");
                  //     // print("**o***${output}");
                  //     //
                  //     // if (output == "Success: true") {
                  //     //   AppReview.storeListing.then(log);
                  //     //
                  //     //   print("(****)");
                  //     // } else {
                  //     //   AppReview.requestReview.then(log);
                  //     // }
                  //   },
                  //   child: Container(
                  //     child: Image.asset('images/rating.png'),
                  //     height: 40,
                  //     color:Colors.white
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ));
  }

  void log(String? message) {
    if (message != null) {
      setState(() {
        output = message;
      });
      print(message);
    }
  }
}
