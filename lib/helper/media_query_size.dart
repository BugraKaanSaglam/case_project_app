import 'package:flutter/material.dart';

class SizerMediaQuery {
  static getW(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static getH(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static getText(BuildContext context) {
    return MediaQuery.of(context).textScaler;
  }
}
