import 'package:flutter/material.dart';
import 'package:mi_tianguis_admin/app/routes.dart';
import 'package:mi_tianguis_admin/core/constants/app_config.dart';
import 'package:mi_tianguis_admin/features/dashboard/viewmodel/dashboard_viewmodel.dart';
import 'package:mi_tianguis_admin/features/shared/widgets/admin_scaffold.dart';
import 'package:mi_tianguis_admin/features/shared/widgets/section_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late final DashboardViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = DashboardViewModel()..load();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _viewModel,
      builder: (context, _) {
        return AdminScaffold(
          title: 'Dashboard',
          currentRoute: AppRoutes.dashboard,
          child: Scrollbar(
            thumbVisibility: true,
            trackVisibility: true,
            child: SingleChildScrollView(
              primary: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Panel administrativo',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1E1E1E),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Desde aqui administraras categorias, negocios, imagenes y sincronizacion.',
                    style: TextStyle(color: Color(0xFF626262)),
                  ),
                  const SizedBox(height: 24),
                  // ── Contadores ───────────────────────────────────
                  Wrap(
                    spacing: 18,
                    runSpacing: 18,
                    children: [
                      _StatTile(
                        label: 'Categorias',
                        count: _viewModel.categoriasCount,
                        icon: Icons.category_rounded,
                        isLoading: _viewModel.isLoading,
                        lastUpdate: _viewModel.syncMeta.categoriasUpdatedAt,
                        onTap: () => Navigator.pushNamed(context, AppRoutes.categorias),
                      ),
                      _StatTile(
                        label: 'Negocios',
                        count: _viewModel.negociosCount,
                        icon: Icons.storefront_rounded,
                        isLoading: _viewModel.isLoading,
                        lastUpdate: _viewModel.syncMeta.negociosUpdatedAt,
                        onTap: () => Navigator.pushNamed(context, AppRoutes.negocios),
                      ),
                    ],
                  ),
                  if (_viewModel.error != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      'No se pudieron cargar las estadísticas: ${_viewModel.error}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ],
                  const SizedBox(height: 32),
                  // ── Versión ───────────────────────────────────────
                  Text(
                    'Versión ${AppConfig.appVersion}',
                    style: const TextStyle(
                      color: Color(0xFFAAAAAA),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.label,
    required this.count,
    required this.icon,
    required this.isLoading,
    required this.onTap,
    this.lastUpdate,
  });

  final String label;
  final int count;
  final IconData icon;
  final bool isLoading;
  final DateTime? lastUpdate;
  final VoidCallback onTap;

  String _formatDate(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year} '
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final secondary = Theme.of(context).colorScheme.secondary;

    return SizedBox(
      width: 320,
      child: SectionCard(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: secondary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(icon, color: secondary, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          label,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 60,
                                child: LinearProgressIndicator(),
                              )
                            : Text(
                                '$count registros',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                  color: primary,
                                ),
                              ),
                      ],
                    ),
                  ),
                ],
              ),
              if (lastUpdate != null) ...[
                const SizedBox(height: 12),
                Text(
                  'Últ. actualización: ${_formatDate(lastUpdate!)}',
                  style: const TextStyle(
                    color: Color(0xFF8A8A8A),
                    fontSize: 12,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

