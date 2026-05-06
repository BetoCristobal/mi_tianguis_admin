import 'package:flutter/material.dart';

/// Paletas de color disponibles para el panel administrativo.
enum AppColorPalette {
  verde(
    label: 'Verde bosque',
    primary: Color(0xFF1F5C42),
    accent: Color(0xFFD96C3F),
    surface: Color(0xFFF7F3EC),
    sidebar: Color(0xFF163B2D),
  ),
  azul(
    label: 'Azul marino',
    primary: Color(0xFF1A3A5C),
    accent: Color(0xFFE8A830),
    surface: Color(0xFFF0F4F8),
    sidebar: Color(0xFF0F2238),
  ),
  morado(
    label: 'Morado',
    primary: Color(0xFF4A2D6B),
    accent: Color(0xFFD4A853),
    surface: Color(0xFFF6F2F9),
    sidebar: Color(0xFF2E1A44),
  ),
  terracota(
    label: 'Terracota',
    primary: Color(0xFF7C2626),
    accent: Color(0xFFE8A830),
    surface: Color(0xFFFAF3F0),
    sidebar: Color(0xFF4E1616),
  ),
  pizarra(
    label: 'Pizarra',
    primary: Color(0xFF2D3748),
    accent: Color(0xFF68B09F),
    surface: Color(0xFFF7F8FA),
    sidebar: Color(0xFF1A2233),
  );

  const AppColorPalette({
    required this.label,
    required this.primary,
    required this.accent,
    required this.surface,
    required this.sidebar,
  });

  final String label;
  final Color primary;
  final Color accent;
  final Color surface;
  final Color sidebar;
}

ThemeData buildAdminTheme([AppColorPalette palette = AppColorPalette.verde]) {
  final primary = palette.primary;
  final accent = palette.accent;
  final surface = palette.surface;

  final scheme = ColorScheme.fromSeed(
    seedColor: primary,
    primary: primary,
    secondary: accent,
    surface: Colors.white,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: surface,
    appBarTheme: AppBarTheme(
      backgroundColor: primary,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Color(0xFFE7DED1)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: primary, width: 1.4),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
    ),
  );
}
