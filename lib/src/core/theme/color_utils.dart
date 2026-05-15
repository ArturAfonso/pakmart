

import 'dart:math';
import 'package:flutter/material.dart';

/// Converte oklch(L C H / opacity%) para Color do Flutter.
/// L: 0.0–1.0, C: 0.0–0.4 aprox., H: 0–360 (graus), opacity: 0.0–1.0
Color oklch(double l, double c, double h, {double opacity = 1.0}) {
  // 1. oklch → oklab
  final hRad = h * pi / 180;
  final a = c * cos(hRad);
  final b = c * sin(hRad);

  // 2. oklab → linear sRGB
  final lp = l + 0.3963377774 * a + 0.2158037573 * b;
  final mp = l - 0.1055613458 * a - 0.0638541728 * b;
  final sp = l - 0.0894841775 * a - 1.2914855480 * b;

  final rl = lp * lp * lp;
  final rm = mp * mp * mp;
  final rs = sp * sp * sp;

  final r =  4.0767416621 * rl - 3.3077115913 * rm + 0.2309699292 * rs;
  final g = -1.2684380046 * rl + 2.6097574011 * rm - 0.3413193965 * rs;
  final bv = -0.0041960863 * rl - 0.7034186147 * rm + 1.7076147010 * rs;

  // 3. linear sRGB → sRGB (correção gamma)
  int toSrgb(double v) {
    final x = v.clamp(0.0, 1.0);
    final gamma = x <= 0.0031308
        ? 12.92 * x
        : 1.055 * pow(x, 1 / 2.4) - 0.055;
    return (gamma * 255).round().clamp(0, 255);
  }

  return Color.fromARGB(
    (opacity.clamp(0.0, 1.0) * 255).round(),
    toSrgb(r),
    toSrgb(g),
    toSrgb(bv),
  );
}