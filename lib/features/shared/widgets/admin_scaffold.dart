import 'package:flutter/material.dart';
import 'package:mi_tianguis_admin/app/routes.dart';
import 'package:mi_tianguis_admin/app/theme.dart';
import 'package:mi_tianguis_admin/core/constants/app_config.dart';
import 'package:mi_tianguis_admin/core/services/auth_service.dart';
import 'package:mi_tianguis_admin/core/services/theme_service.dart';

class AdminScaffold extends StatelessWidget {
  const AdminScaffold({
    super.key,
    required this.title,
    required this.currentRoute,
    required this.child,
    this.actions,
  });

  final String title;
  final String currentRoute;
  final Widget child;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          _AdminSidebar(currentRoute: currentRoute),
          Expanded(
            child: Column(
              children: [
                AppBar(
                  title: Text(title),
                  actions: [
                    ...(actions ?? const []),
                    IconButton(
                      tooltip: 'Cerrar sesion',
                      onPressed: () async {
                        await AuthService.instance.signOut();
                        if (!context.mounted) {
                          return;
                        }
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          AppRoutes.login,
                          (route) => false,
                        );
                      },
                      icon: const Icon(Icons.logout_rounded),
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: child,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AdminSidebar extends StatelessWidget {
  const _AdminSidebar({required this.currentRoute});

  final String currentRoute;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: ThemeService.instance,
      builder: (context, _) {
        final palette = ThemeService.instance.palette;
        return Container(
          width: 260,
          color: palette.sidebar,
          padding: const EdgeInsets.fromLTRB(18, 28, 18, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Mi Tianguis Admin',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Panel de captura y administracion',
                style: TextStyle(
                  color: Color(0xFFCDE4D8),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 28),
              _SidebarItem(
                label: 'Dashboard',
                icon: Icons.dashboard_outlined,
                selected: currentRoute == AppRoutes.dashboard,
                onTap: () => Navigator.pushReplacementNamed(
                  context,
                  AppRoutes.dashboard,
                ),
              ),
              _SidebarItem(
                label: 'Categorias',
                icon: Icons.category_outlined,
                selected: currentRoute == AppRoutes.categorias,
                onTap: () => Navigator.pushReplacementNamed(
                  context,
                  AppRoutes.categorias,
                ),
              ),
              _SidebarItem(
                label: 'Negocios',
                icon: Icons.storefront_outlined,
                selected: currentRoute == AppRoutes.negocios,
                onTap: () => Navigator.pushReplacementNamed(
                  context,
                  AppRoutes.negocios,
                ),
              ),
              const Spacer(),
              // ── Selector de paleta de colores ──────────────────
              _PaletteSelector(currentPalette: palette),
              const SizedBox(height: 14),
              // ── Versión ─────────────────────────────────────────
              Text(
                'v${AppConfig.appVersion}',
                style: const TextStyle(
                  color: Color(0xFF7AADA0),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Botón que abre un diálogo para cambiar la paleta de colores.
class _PaletteSelector extends StatelessWidget {
  const _PaletteSelector({required this.currentPalette});

  final AppColorPalette currentPalette;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showPaletteDialog(context),
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          children: [
            Icon(Icons.color_lens_outlined, color: Colors.white.withValues(alpha: 0.8), size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                currentPalette.label,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 13,
                ),
              ),
            ),
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: currentPalette.primary,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPaletteDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Paleta de colores'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: AppColorPalette.values.map((palette) {
              return AnimatedBuilder(
                animation: ThemeService.instance,
                builder: (context, _) {
                  final isSelected = ThemeService.instance.palette == palette;
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: palette.primary,
                      radius: 14,
                      child: isSelected
                          ? const Icon(Icons.check, color: Colors.white, size: 16)
                          : null,
                    ),
                    title: Text(palette.label),
                    selected: isSelected,
                    onTap: () {
                      ThemeService.instance.setPalette(palette);
                      Navigator.pop(dialogContext);
                    },
                  );
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

class _SidebarItem extends StatelessWidget {
  const _SidebarItem({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: selected ? const Color(0xFF245943) : Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            child: Row(
              children: [
                Icon(icon, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (onTap == null)
                  const Text(
                    'Prox.',
                    style: TextStyle(color: Color(0xFFCDE4D8), fontSize: 12),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
