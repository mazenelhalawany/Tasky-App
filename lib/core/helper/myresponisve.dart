import 'package:flutter/material.dart';

abstract class AppResponsive {
  static double height(context, {required double height}) =>
      MediaQuery.of(context).size.height * (height/812);
  static double width(context, {required double width}) =>
      MediaQuery.of(context).size.width * (width/375);
}
