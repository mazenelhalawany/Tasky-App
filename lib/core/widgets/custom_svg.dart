import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomSvg extends StatelessWidget {
  const CustomSvg(
      {super.key, required this.assetName, this.width, this.height});
  final String assetName;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      assetName,
      width: width,
      height: height,
      fit: BoxFit.cover,
    );
  }
}
