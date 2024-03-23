import 'package:flutter/material.dart';

extension MediaQueryExtension on BuildContext {
  get screenWith => MediaQuery.of(this).size.width;
  get screenHeight => MediaQuery.of(this).size.height;
}
