import 'package:flutter/material.dart';

class AppImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;
  final double? width;
  final double? height;

  const AppImage(
    this.imageUrl, {
    Key? key,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
  }) : super(key: key);

  bool get _isNetwork => imageUrl.startsWith('http') || imageUrl.startsWith('https');

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      // Optionally, return a placeholder or error widget
      return const Icon(Icons.broken_image);
    }
    return _isNetwork
        ? Image.network(imageUrl, fit: fit, width: width, height: height, errorBuilder: (c, e, s) => const Icon(Icons.broken_image))
        : Image.asset(imageUrl, fit: fit, width: width, height: height, errorBuilder: (c, e, s) => const Icon(Icons.broken_image));
  }
}
