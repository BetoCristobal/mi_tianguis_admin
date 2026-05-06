import 'package:flutter/foundation.dart';
import 'package:mi_tianguis_admin/app/theme.dart';

/// Servicio singleton que gestiona la paleta de colores activa.
/// Usa [AnimatedBuilder] o [ListenableBuilder] para reaccionar a cambios.
class ThemeService extends ChangeNotifier {
  ThemeService._();

  static final ThemeService instance = ThemeService._();

  AppColorPalette _palette = AppColorPalette.verde;

  AppColorPalette get palette => _palette;

  void setPalette(AppColorPalette palette) {
    if (_palette == palette) return;
    _palette = palette;
    notifyListeners();
  }
}
