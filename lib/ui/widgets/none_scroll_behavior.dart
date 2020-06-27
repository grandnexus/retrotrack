import 'package:flutter/material.dart';

class NoneScrollBehavior extends ScrollBehavior {
  const NoneScrollBehavior();

  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
