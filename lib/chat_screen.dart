// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:didier/AdHelper.dart';
import 'package:didier/SharedPreference.dart';
import 'package:didier/chatModel.dart';
import 'package:didier/constants.dart';
import 'package:didier/dio_api_client.dart';
// import 'package:didier/dio_api_client.dart';
// import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:speech_to_text/speech_to_text.dart';

import 'chatmessage.dart';
import 'game_route.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  // ChatGPT? chatGPT;
  bool _isImageSearch = false;
  SpeechToText speechToText = SpeechToText();
  bool image = false;
  StreamSubscription? _subscription;
  bool _isTyping = false;
  var isListing = false;

  BannerAd? _bannerAd;
  bool _isBannerAdReady = false;

  @override
  void initState() {
    super.initState();
    loadBannerAd();
    image = false;
  }

  Future<void> imageAPI() async {
    var jsonData = {"prompt": _controller.text, "n": 1, "size": "512x512"};
    final response = await DioResponse.postApi(
        'https://api.openai.com/v1/images/generations', jsonData);

    ci.value = ChatImageModel.fromJson(response?.data ?? {});
  }

  Rx<chatModel> cm = chatModel().obs;
  Rx<ChatImageModel> ci = ChatImageModel().obs;
  Future<void> chatAPI() async {
    var jsonData = {
      "model": "text-davinci-003",
      "prompt": _controller.text,
      "temperature": 0.9,
      "max_tokens": 150,
      "top_p": 1,
      "frequency_penalty": 0.0,
      "presence_penalty": 0.6,
      "stop": [" AI:", "Human:"]
    };
    final response = await DioResponse.postApi(
        'https://api.openai.com/v1/completions', jsonData);

    cm.value = chatModel.fromJson(response?.data ?? {});
  }

  @override
  void dispose() {
    _bannerAd!.dispose();

    _subscription?.cancel();
    Constant.newUser = "1";
    SharedPreference.addStringToSF("newUser", "0");
    super.dispose();
  }

  void _sendMessage() async {
    if (_controller.text.isEmpty) {
      return;
    }

    ChatMessage message = ChatMessage(
      text: _controller.text,
      sender: "user",
      isImage: false,
    );

    setState(() {
      _messages.insert(0, message);
      _isTyping = true;
    });
    _isTyping = true;
    if (image) {
      await imageAPI();
      _isTyping = false;

      _controller.clear();
      if ((ci.value.data?[0].url ?? "").toString().contains("http")) {
        insertNewData(ci.value.data?[0].url ?? '', isImage: true);
      } else {
        insertNewData("Try something else.", isImage: true);
      }
    } else {
      await chatAPI();
      _isTyping = false;

      _controller.clear();

      insertNewData(cm.value.choices?[0].text ?? 'NA');
    }
    ci.value = ChatImageModel();
    cm.value = chatModel();
    // _scrollController.animateTo(
    //   _scrollController.position.maxScrollExtent + 512,
    //   curve: Curves.easeOut,
    //   duration: const Duration(milliseconds: 1000),
    // );
  }

  final ScrollController _scrollController = ScrollController();

  void insertNewData(String response, {bool isImage = false}) {
    ChatMessage botMessage = ChatMessage(
      text: response,
      sender: "bot",
      isImage: isImage,
    );

    setState(() {
      _isTyping = false;
      _messages.insert(0, botMessage);
    });
  }

  final key = GlobalKey<State<Tooltip>>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Stack(
            children: [




              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // COMPLETE: Display a banner when ready

                  if (_isBannerAdReady)
                    Container(
                      width: _bannerAd!.size.width.toDouble(),
                      height: _bannerAd!.size.height.toDouble(),
                      child: AdWidget(ad: _bannerAd!),
                    ),
                  SizedBox(
                    height: 10.0,
                  ),

                  if (_messages.length == 0)
                    GestureDetector(
                      onTap: () {
                        Get.to(GameRoute());
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Container(
                                height: _bannerAd!.size.height.toDouble(),
                                margin: EdgeInsets.only(
                                  bottom: 5,
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 0.0),
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    child: Text(
                                      "Start Using DIDIER",
                                      style: TextStyle(
                                          fontFamily: 'Poppins',
                                          color: Colors.white),
                                    ),
                                  ),
                                )),
                          ),
                        ],
                      ),
                    ),
                  SizedBox(
                    height: 10,
                  ),
                  Flexible(
                      child: ListView.builder(
                    controller: _scrollController,
                    reverse: true,
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: _messages[index],
                          ),
                        ],
                      );
                    },
                  )),
                  if (_isTyping)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 20.0,
                        ),
                        Image.asset(
                          'images/i11.png',
                          height: 30.0,
                          width: 30,
                        ),
                        SizedBox(
                          width: 20.0,
                        ),
                        Image.asset(
                          'images/gif-maker.gif',
                          height: 25.0,
                        )
                      ],
                    ),
                  if (isListing) ...[
                    Image.asset(
                      'images/rwave.gif',
                      height: 100.0,
                      width: 250.0,
                    ),
                  ],
                  SizedBox(
                    height: 5,
                  ),
                  const Divider(
                    height: 1.0,
                  ),

                  ///-----------------------------------------------------------------------------------------------------------------------
                  Row(
                    children: [
                      Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.black,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 50,
                            ),
                            GestureDetector(
                              onTap: () {
                                image = false;
                                setState(() {});
                              },
                              child: Image.asset(
                                "images/i13.png",
                                height: 30,
                                width: 30,
                                color: image ? Colors.white : Colors.red,
                              ),
                            ),
                            Spacer(),
                            GestureDetector(
                              onTap: () {
                                image = true;
                                setState(() {});
                              },
                              child: Image.asset(
                                "images/i14.png",
                                height: 30,
                                width: 30,
                                color: !image ? Colors.white : Colors.red,
                              ),
                            ),
                            SizedBox(
                              width: 50,
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: GestureDetector(
                    onTap: () async {
                      setState(() {});
                      if (_isTyping) return;

                      if (!isListing) {
                        var available = await speechToText.initialize();
                        if (available) {
                          setState(() {
                            isListing = true;
                            speechToText.listen(onResult: (result) {
                              setState(() {
                                _controller.text = result.recognizedWords;
                              });
                            });
                          });
                          // setState(() {
                          //   isListing = true;
                          //   _controller.text = "result.recognizedWords";
                          // });
                        }
                      } else {
                        setState(() {
                          isListing = false;
                        });

                        speechToText.stop();

                        _sendMessage();
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: Image.asset(
                        isListing ? "images/i5.png" : "images/i6.png",
                        height: 65,
                        width: 65,
                      ),
                    ),
                  ),
                ),
              ),

            ],

          ),
        ));
  }

  void loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerAdReady = true;
            print('########## ${_isBannerAdReady}');
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          _isBannerAdReady = false;
          ad.dispose();
        },
      ),
    );

    _bannerAd!.load();
  }
}

class MyTooltip extends StatelessWidget {
  final Widget? child;
  final String? message;

  MyTooltip({@required this.message, @required this.child});

  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<State<Tooltip>>();
    return Tooltip(
      key: key,
      message: message,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _onTap(key),
        child: child,
      ),
    );
  }

  void _onTap(GlobalKey key) {
    final dynamic tooltip = key.currentState;
    tooltip?.ensureTooltipVisible();
  }
}
