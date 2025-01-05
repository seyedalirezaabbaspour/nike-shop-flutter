
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageLoadingService extends StatelessWidget {
  final String imageUrl;
  final double borderRadius;
  const ImageLoadingService({
    super.key, 
    required this.imageUrl, required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      ),
    );
  }
}