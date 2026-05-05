import 'package:flutter/material.dart';
import 'package:mi_tianguis_admin/app/routes.dart';
import 'package:mi_tianguis_admin/data/models/categoria_model.dart';
import 'package:mi_tianguis_admin/data/models/negocio_model.dart';
import 'package:mi_tianguis_admin/features/negocios/viewmodel/negocios_list_viewmodel.dart';
import 'package:mi_tianguis_admin/features/negocios/widgets/negocio_card.dart';
import 'package:mi_tianguis_admin/features/shared/widgets/admin_scaffold.dart';

class NegociosListScreen extends StatefulWidget {
  const NegociosListScreen({super.key});

  @override
  State<NegociosListScreen> createState() => _NegociosListScreenState();
}

class _NegociosListScreenState extends State<NegociosListScreen> {
  late final NegociosListViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = NegociosListViewModel()..loadCategorias();
  }

  Future<void> _confirmDelete(NegocioModel negocio) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Eliminar negocio'),
          content: Text(
            'Se eliminara "${negocio.nombre}" en Firestore y sus imagenes de Storage. '
            'Usa esto para limpiar datos de prueba o registros que ya no deban existir.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );

    if (confirm != true || !mounted) {
      return;
    }

    try {
      await _viewModel.deleteNegocio(negocio);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Negocio eliminado.')),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo eliminar el negocio.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _viewModel,
      builder: (context, _) {
        return AdminScaffold(
          title: 'Negocios',
          currentRoute: AppRoutes.negocios,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: FilledButton.icon(
                onPressed: () => Navigator.pushNamed(
                  context,
                  AppRoutes.negocioForm,
                ),
                icon: const Icon(Icons.add),
                label: const Text('Nuevo negocio'),
              ),
            ),
          ],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Selector de categoría ──────────────────────────────
              _CategoriaSelectorBar(
                categorias: _viewModel.categorias,
                selected: _viewModel.selectedCategoria,
                isLoading: _viewModel.isLoadingCategorias,
                onSelected: _viewModel.selectCategoria,
              ),
              const Divider(height: 1),
              // ── Lista de negocios ──────────────────────────────────
              Expanded(
                child: _buildBody(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBody() {
    if (_viewModel.selectedCategoria == null) {
      return const Center(
        child: Text(
          'Selecciona una categoría para ver sus negocios.',
          style: TextStyle(color: Color(0xFF888888)),
        ),
      );
    }

    if (_viewModel.isLoadingNegocios) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_viewModel.negocios.isEmpty) {
      return const Center(
        child: Text(
          'No hay negocios en esta categoría.',
          style: TextStyle(color: Color(0xFF888888)),
        ),
      );
    }

    return Scrollbar(
      thumbVisibility: true,
      trackVisibility: true,
      child: ListView.separated(
        primary: true,
        padding: const EdgeInsets.all(16),
        itemCount: _viewModel.negocios.length,
        separatorBuilder: (_, __) => const SizedBox(height: 14),
        itemBuilder: (context, index) {
          final negocio = _viewModel.negocios[index];
          return NegocioCard(
            negocio: negocio,
            onEdit: () async {
              await Navigator.pushNamed(
                context,
                AppRoutes.negocioForm,
                arguments: negocio,
              );
              // Reload after returning from form in case data changed.
              if (_viewModel.selectedCategoria != null) {
                await _viewModel.selectCategoria(_viewModel.selectedCategoria!);
              }
            },
            onPreview: () => Navigator.pushNamed(
              context,
              AppRoutes.negocioPreview,
              arguments: negocio,
            ),
            onDelete: _viewModel.isDeleting
                ? null
                : () => _confirmDelete(negocio),
          );
        },
      ),
    );
  }
}

// ── Barra de chips de categorías ──────────────────────────────────────────────

class _CategoriaSelectorBar extends StatelessWidget {
  const _CategoriaSelectorBar({
    required this.categorias,
    required this.selected,
    required this.isLoading,
    required this.onSelected,
  });

  final List<CategoriaModel> categorias;
  final CategoriaModel? selected;
  final bool isLoading;
  final ValueChanged<CategoriaModel> onSelected;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: SizedBox(
          height: 36,
          child: Center(child: LinearProgressIndicator()),
        ),
      );
    }

    if (categorias.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 56,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        itemCount: categorias.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final categoria = categorias[index];
          final isSelected = selected?.id == categoria.id;
          return ChoiceChip(
            label: Text(categoria.titulo),
            selected: isSelected,
            onSelected: (_) => onSelected(categoria),
          );
        },
      ),
    );
  }
}
