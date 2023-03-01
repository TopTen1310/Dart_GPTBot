import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CommonNetworkImageView extends StatelessWidget {
  ///[url] is required parameter for fetching network image
  final String url;
  final double height;
  final double width;
  final BoxFit fit;
  final String placeHolder;
  var imageBuilder;

  ///a [CommonNetworkImageView] it can be used for showing any network images
  /// it will shows the placeholder image if image is not found on network
  CommonNetworkImageView({
    required this.url,
    this.height = 200,
    this.width = 200,
    this.fit = BoxFit.contain,
    this.placeHolder = 'images/i9.png',
    this.imageBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return url.isEmpty
        ? Image.asset(
            placeHolder,
            height: 80,
            width: 80,
            fit: fit,
          )
        : CachedNetworkImage(
            fit: fit,
            imageUrl: url,
            imageBuilder: imageBuilder,
            placeholder: (context, url) => Container(
              height: height,
              width: width,
              child: LinearProgressIndicator(
                color: Colors.grey.shade200,
                backgroundColor: Colors.grey.shade100,
              ),
            ),
            errorWidget: (context, url, error) => Image.asset(
              placeHolder,
              height: 80,
              width: 80,
              fit: fit,
            ),
          );
  }
}
