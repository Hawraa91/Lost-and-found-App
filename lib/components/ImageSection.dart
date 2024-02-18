import 'package:flutter/material.dart';

//this will help with adding images in other pages if needed
class ImageSection extends StatelessWidget {
  const ImageSection({super.key, required this.image, required this.width, required this.height});

  final String image;
  final int width;
  final int height;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      image,
      width: width.toDouble(), // Convert int to double
      height: height.toDouble(), // Convert int to double
      fit: BoxFit.cover,
    );
  }
}