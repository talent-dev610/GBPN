import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ImageViewWidget extends StatelessWidget {
  final String url;
  const ImageViewWidget({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return url.contains("http") ? CachedNetworkImage(
      imageUrl: url,
      placeholder: (_, __) => const Center(child: CupertinoActivityIndicator()),
      fit: BoxFit.cover,
    ) : Image.file(
      File(url),
      fit: BoxFit.cover,
      height: double.infinity,
      width: double.infinity,
    );
  }
}
