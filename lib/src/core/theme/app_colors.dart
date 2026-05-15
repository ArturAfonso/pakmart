import 'package:flutter/material.dart';

abstract final class AppColors {
  // Identidade e Destaques
  static const accent = Color(0xFFE7885D); // Marrom terracota (botões e logo)
  static const success = Color(0xFF7FAE98); // Verde sutil (badges)

  // ── Light Mode ──────────────────────────────────────────────
  static const background = Color(0xFFFCFAF7); // Papel quente
  static const surface = Color(0xFFFFFFFF);    // Blocos/Cards brancos
  static const border = Color(0xFFE8E4E0);      // Divisores sutis
  static const input = Color(0xFFF2F0ED); // Um creme um pouco mais denso que o fundo
  
  // Texto Light
  static const textPrimary = Color(0xFF2D2926);   // Títulos
  static const textSecondary = Color(0xFF706C68); // Descrições
  static const textMuted = Color(0xFFA8A4A0);     // Números (01, 02)

  // ── Dark Mode ───────────────────────────────────────────────
  // Fundo principal ("Tinta noturna")
  static const darkBackground = Color(0xFF141210); 
  
  
  // Fundo dos cards no Dark (Levemente mais claro que o background)
  static const darkSurface = Color(0xFF1C1A18);
  
  // Bordas e divisores no Dark
  static const darkBorder = Color(0xFF2D2A27);

  // Texto Dark
  static const darkTextPrimary = Color(0xFFE8E4E0);   // Off-white para leitura
  static const darkTextSecondary = Color(0xFFA8A4A0); // Cinza para descrições
  static const darkTextMuted = Color(0xFF5E5955);     // Textos de baixo contraste

  // Elementos de UI Dark
  static const darkInput = Color(0xFF1C1A18); // Barra de busca
}