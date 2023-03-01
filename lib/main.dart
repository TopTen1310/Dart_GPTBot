// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:didier/SharedPreference.dart';
import 'package:didier/ThirdScreen.dart';
import 'package:didier/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'chat_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Didier',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    checkNewUser();
  }

  checkNewUser() async {
    String newUser = await SharedPreference.getStringValuesSF("newUser");
    Constant.newUser = newUser;
    Timer(Duration(seconds: 3),
        () => Navigator.pushReplacement(context, createRoute(SecondScreen())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                  child: Image.asset(
                'images/i9.png',
                width: MediaQuery.of(context).size.width * 0.50,
              )),
            ),
          ],
        ),
      ),
    );
  }
}

// class SecondScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: Colors.white,
//         body: SafeArea(
//           child: Center(
//             child: Padding(
//               padding: const EdgeInsets.only(top: 0.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Image.asset('images/i3.png'),
//                   SizedBox(height: 15.0),
//                   Container(
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(
//                           vertical: 50, horizontal: 36),
//                       child: Text(
//                         "Press and hold the microphone icon to talk to Didier",
//                         style: TextStyle(
//                           fontSize: 17.0,
//                           color: Colors.black,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.of(context).push(createRoute(ThirdScreen()));
//                     },
//                     child: Container(
//                       height: 50.0,
//                       width: 200.0,
//                       decoration: BoxDecoration(
//                         border: Border.all(color: Color.fromRGBO(183, 4, 4, 1)),
//                         color: Color.fromRGBO(183, 4, 4, 1),
//                         borderRadius: BorderRadius.all(Radius.circular(20)),
//                       ),
//                       child: Center(
//                           child: Text(
//                         'Continue'.toUpperCase(),
//                         style: TextStyle(
//                             fontSize: 15.0,
//                             fontFamily: 'Poppins',
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold),
//                       )),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ));
//   }
// }

class SecondScreen extends StatelessWidget {
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
                  Image.asset('images/i3.png'),
                  SizedBox(height: 15.0),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 50, horizontal: 36),
                      child: Text(
                        "Press and hold the microphone icon to talk to Didier",
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
                      Navigator.of(context).push(createRoute(ThirdScreen()));
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
                        'Continue'.toUpperCase(),
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

Route createRoute(nextScreen) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => nextScreen,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
