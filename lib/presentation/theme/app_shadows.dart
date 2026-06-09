import 'package:flutter/material.dart';

class AppShadows {
  AppShadows._();

  static const List<BoxShadow> cardLight = [
    BoxShadow(
      color: Color(0x0F0F172A),
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
    BoxShadow(
      color: Color(0x050F172A),
      blurRadius: 16,
      offset: Offset(0, 4),
    ),
  ];

  static const List<BoxShadow> cardElevatedLight = [
    BoxShadow(
      color: Color(0x140F172A),
      blurRadius: 12,
      offset: Offset(0, 4),
    ),
    BoxShadow(
      color: Color(0x080F172A),
      blurRadius: 24,
      offset: Offset(0, 8),
    ),
  ];

  static const List<BoxShadow> cardDark = [
    BoxShadow(
      color: Color(0x40000000),
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
    BoxShadow(
      color: Color(0x20000000),
      blurRadius: 16,
      offset: Offset(0, 4),
    ),
  ];

  static const List<BoxShadow> cardElevatedDark = [
    BoxShadow(
      color: Color(0x50000000),
      blurRadius: 12,
      offset: Offset(0, 4),
    ),
    BoxShadow(
      color: Color(0x30000000),
      blurRadius: 24,
      offset: Offset(0, 8),
    ),
  ];

  static const List<BoxShadow> buttonLight = [
    BoxShadow(
      color: Color(0x1A059669),
      blurRadius: 8,
      offset: Offset(0, 3),
    ),
  ];

  static const List<BoxShadow> buttonDark = [
    BoxShadow(
      color: Color(0x4010B981),
      blurRadius: 8,
      offset: Offset(0, 3),
    ),
  ];

  static const List<BoxShadow> glassLight = [
    BoxShadow(
      color: Color(0x1AFFFFFF),
      blurRadius: 20,
      offset: Offset(0, 4),
    ),
  ];

  static const List<BoxShadow> glassDark = [
    BoxShadow(
      color: Color(0x40000000),
      blurRadius: 20,
      offset: Offset(0, 4),
    ),
    BoxShadow(
      color: Color(0x15FFFFFF),
      blurRadius: 8,
      offset: Offset(0, 1),
    ),
  ];

  static const List<BoxShadow> glowGreen = [
    BoxShadow(
      color: Color(0x40059669),
      blurRadius: 16,
      offset: Offset(0, 0),
    ),
  ];

  static const List<BoxShadow> glowGold = [
    BoxShadow(
      color: Color(0x40D4A853),
      blurRadius: 20,
      offset: Offset(0, 0),
    ),
  ];

  static const List<BoxShadow> glowRed = [
    BoxShadow(
      color: Color(0x40DC2626),
      blurRadius: 12,
      offset: Offset(0, 0),
    ),
  ];
}
