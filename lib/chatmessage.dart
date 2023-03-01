// ignore_for_file: prefer_const_constructors

import 'package:didier/common_network_image.dart';
import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  const ChatMessage(
      {super.key,
      required this.text,
      required this.sender,
      this.isImage = false});

  final String text;
  final String sender;
  final bool isImage;

  @override
  Widget build(BuildContext context) {
    return sender == "user"
        ? Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                width: 10.0,
              ),
              Flexible(
                child: Container(
                    margin: EdgeInsets.only(left: 30, bottom: 5, top: 10),
                    // margin:
                    //     EdgeInsets.only(left: 30, top: 10, bottom: 5, right: 3),
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(220, 218, 218, 1),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Text(
                        text.replaceFirst("\n\n", ''),
                        style: TextStyle(color: Colors.black),
                      ),
                    )),
              ),
              SizedBox(
                width: 20.0,
              ),
              Image.asset(
                'images/i10.png',
                height: 30.0,
                width: 30,
              ),
              SizedBox(
                width: 20.0,
              ),
            ],
          )
        : Row(
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
              Flexible(
                child: Container(
                    margin:
                        isImage ? null : EdgeInsets.only(bottom: 5, right: 30),
                    padding: isImage
                        ? null
                        : EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                    decoration: BoxDecoration(
                      color: isImage ? null : Colors.black,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10)),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: isImage ? 0 : 10,
                          vertical: isImage ? 0 : 10),
                      child: isImage
                          ? CommonNetworkImageView(
                              url: text,
                              height: MediaQuery.of(context).size.width * 0.45,
                              width: MediaQuery.of(context).size.width * 0.45,
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                width: MediaQuery.of(context).size.width * 0.45,
                                height:
                                    MediaQuery.of(context).size.width * 0.45,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10)),
                                  image: DecorationImage(
                                      image: imageProvider, fit: BoxFit.cover),
                                ),
                              ),
                            )
                          : Text(
                              text.replaceAll("\n\n", ''),
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.white,
                              ),
                            ),
                    )),
              ),
            ],
          );
  }
}
