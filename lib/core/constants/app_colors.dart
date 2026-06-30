import 'package:flutter/material.dart';

/// Brand and semantic color constants for MirrorTube.
abstract final class AppColors {
  // Brand
  static const Color primary = Color(0xFFFF0000);
  static const Color primaryDark = Color(0xFFCC0000);
  static const Color onPrimary = Color(0xFFFFFFFF);

  // Surface
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF121212);
  static const Color surfaceVariantLight = Color(0xFFF5F5F5);
  static const Color surfaceVariantDark = Color(0xFF1E1E1E);

  // Text
  static const Color textPrimaryLight = Color(0xFF0F0F0F);
  static const Color textPrimaryDark = Color(0xFFF1F1F1);
  static const Color textSecondaryLight = Color(0xFF606060);
  static const Color textSecondaryDark = Color(0xFFAAAAAA);

  // Divider
  static const Color dividerLight = Color(0xFFE0E0E0);
  static const Color dividerDark = Color(0xFF303030);

  // Error
  static const Color error = Color(0xFFB00020);
}
