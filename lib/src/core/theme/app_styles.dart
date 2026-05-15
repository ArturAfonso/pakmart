

import 'package:flutter/material.dart';


abstract final class AppTextStyles {
  // =========================
  // AVRILE SERIF (local)
  // =========================

  static TextStyle get titleLarge => const TextStyle(
        fontFamily: 'AvrileSerif',
        fontSize: 32,
        fontWeight: FontWeight.w700, // Bold
        fontStyle: FontStyle.normal,
        height: 1.2,
      );

  static TextStyle get titleLargeItalic => const TextStyle(
        fontFamily: 'AvrileSerif',
        fontSize: 32,
        fontWeight: FontWeight.w700, // Bold
        fontStyle: FontStyle.italic,
        height: 1.2,
      );

  static TextStyle get titleMedium => const TextStyle(
        fontFamily: 'AvrileSerif',
        fontSize: 24,
        fontWeight: FontWeight.w600, // SemiBold
        fontStyle: FontStyle.normal,
        height: 1.2,
      );

  static TextStyle get titleMediumItalic => const TextStyle(
        fontFamily: 'AvrileSerif',
        fontSize: 24,
        fontWeight: FontWeight.w600, // SemiBold
        fontStyle: FontStyle.italic,
        height: 1.2,
      );

  static TextStyle get titleSmall => const TextStyle(
        fontFamily: 'AvrileSerif',
        fontSize: 18,
        fontWeight: FontWeight.w500, // Medium
        fontStyle: FontStyle.normal,
      );

  static TextStyle get titleSmallItalic => const TextStyle(
        fontFamily: 'AvrileSerif',
        fontSize: 18,
        fontWeight: FontWeight.w500, // Medium
        fontStyle: FontStyle.italic,
      );

  static TextStyle get bodyLarge => const TextStyle(
        fontFamily: 'AvrileSerif',
        fontSize: 18,
        fontWeight: FontWeight.w400, // Regular
        fontStyle: FontStyle.normal,
        height: 1.5,
      );

  static TextStyle get bodyLargeItalic => const TextStyle(
        fontFamily: 'AvrileSerif',
        fontSize: 18,
        fontWeight: FontWeight.w400, // Regular
        fontStyle: FontStyle.italic,
        height: 1.5,
      );

  static TextStyle get bodyMedium => const TextStyle(
        fontFamily: 'AvrileSerif',
        fontSize: 16,
        fontWeight: FontWeight.w300, // Light
        fontStyle: FontStyle.normal,
        height: 1.5,
      );

  static TextStyle get bodyMediumItalic => const TextStyle(
        fontFamily: 'AvrileSerif',
        fontSize: 16,
        fontWeight: FontWeight.w300, // Light
        fontStyle: FontStyle.italic,
        height: 1.5,
      );

  static TextStyle get bodySmall => const TextStyle(
        fontFamily: 'AvrileSerif',
        fontSize: 14,
        fontWeight: FontWeight.w100, // Thin
        fontStyle: FontStyle.normal,
        height: 1.4,
      );

  static TextStyle get bodySmallItalic => const TextStyle(
        fontFamily: 'AvrileSerif',
        fontSize: 14,
        fontWeight: FontWeight.w100, // Thin
        fontStyle: FontStyle.italic,
        height: 1.4,
      );
}