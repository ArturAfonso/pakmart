import 'package:flutter/material.dart';
import 'app_colors.dart';

abstract final class AppTheme {
  static ThemeData get light => ThemeData(
        appBarTheme: const AppBarTheme(
          toolbarHeight: 82,
          backgroundColor: AppColors.background,
          elevation: 3,
          centerTitle: false,
          surfaceTintColor: Colors.transparent,
          shape: Border(
    bottom: BorderSide(
      color: AppColors.border, 
      width: 1,
    ),),),
        

        
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.background,
        dividerColor: AppColors.border,
        
       
        colorScheme:  ColorScheme.light(
          primary: AppColors.accent,
          onPrimary: Colors.white,
          secondary: AppColors.success,
          surface: AppColors.surface,
          onSurface: AppColors.textPrimary,
          onSurfaceVariant: AppColors.textSecondary,
          outline: AppColors.border,
        ),

        
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.input,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          hintStyle: const TextStyle(color: AppColors.textMuted),
        ),

        cardTheme: CardThemeData(
          color: AppColors.surface,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppColors.border, width: 1),
          ),
        ),
      );

  static ThemeData get dark => ThemeData(
        appBarTheme: const AppBarTheme(
          toolbarHeight: 82,
          backgroundColor: AppColors.darkBackground,
          elevation: 1,
          centerTitle: false,
          surfaceTintColor: Colors.transparent,
           shape: Border(
    bottom: BorderSide(
      color: AppColors.darkBorder, 
      width: 1,
    ),),
        ),
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.darkBackground,
        dividerColor: AppColors.darkBorder,

        colorScheme:  ColorScheme.dark(
          primary: AppColors.accent,
          onPrimary: Colors.white,
          secondary: AppColors.success,
          surface: AppColors.darkSurface,
          onSurface: AppColors.darkTextPrimary,
          onSurfaceVariant: AppColors.darkTextSecondary,
          outline: AppColors.darkBorder,
        ),

        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.darkInput,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          hintStyle: const TextStyle(color: AppColors.darkTextMuted),
        ),

        cardTheme: CardThemeData(
          color: AppColors.darkSurface,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppColors.darkBorder, width: 1),
          ),
        ),
      );
}