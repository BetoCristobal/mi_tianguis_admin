import 'package:flutter/material.dart';
import 'package:mi_tianguis_admin/app/routes.dart';

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
    return Container(
      width: 260,
      color: const Color(0xFF163B2D),
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
        ],
      ),
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
