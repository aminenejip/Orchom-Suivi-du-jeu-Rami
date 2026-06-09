import 'package:flutter/animation.dart';

class AppAnimations {
  AppAnimations._();

  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration pageTransition = Duration(milliseconds: 350);

  static const Curve easeOut = Curves.easeOutCubic;
  static const Curve easeInOut = Curves.easeInOutCubic;
  static const Curve spring = Curves.fastEaseInToSlowEaseOut;
  static const Curve bounce = Curves.elasticOut;

  static const Duration staggerBase = Duration(milliseconds: 80);
  static const Duration staggerFast = Duration(milliseconds: 50);
}
