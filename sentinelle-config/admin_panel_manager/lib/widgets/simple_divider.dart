import 'package:flutter/material.dart';

class SimpleDivider extends StatelessWidget {
  const SimpleDivider(
      {super.key,
      required this.width,
      required this.height,
      required this.color,
      required this.borderRadius});

  final double width;
  final double height;
  final Color color;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius), color: color),
    );
  }
}
