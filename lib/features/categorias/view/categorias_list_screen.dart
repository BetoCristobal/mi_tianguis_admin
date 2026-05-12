import 'package:flutter/material.dart';
import 'package:mi_tianguis_admin/app/routes.dart';
import 'package:mi_tianguis_admin/data/models/categoria_model.dart';
import 'package:mi_tianguis_admin/features/categorias/viewmodel/categorias_list_viewmodel.dart';
import 'package:mi_tianguis_admin/features/categorias/widgets/categoria_card.dart';
import 'package:mi_tianguis_admin/features/shared/widgets/admin_scaffold.dart';

class CategoriasListScreen extends StatefulWidget {
  const CategoriasListScreen({super.key});

  @override
  State<CategoriasListScreen> createState() => _CategoriasListScreenState();
}

class _CategoriasListScreenState extends State<CategoriasListScreen> {
  late final CategoriasListViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = CategoriasListViewModel()..load();
  }

  Future<void> _confirmDelete(CategoriaModel categoria) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Eliminar categoria'),
          content: Text(
            'Se eliminara "${categoria.titulo}" en Firestore y su imagen de Storage. '
            'Usa esto solo cuando de verdad quieras limpiar datos de prueba.',
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
      await _viewModel.deleteCategoria(categoria);
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Categoria eliminada.')),
      );
    } on StateError catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message ?? error.toString())),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }
      final errorMsg = error.toString();
      final displayMsg = errorMsg.length > 100
          ? '${errorMsg.substring(0, 100)}...'
          : errorMsg;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al eliminar: $displayMsg'),
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _viewModel,
      builder: (context, _) {
        return AdminScaffold(
          title: 'Categorias',
          currentRoute: AppRoutes.categorias,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: FilledButton.icon(
                onPressed: () => Navigator.pushNamed(
                  context,
                  AppRoutes.categoriaForm,
                ),
                icon: const Icon(Icons.add),
                label: const Text('Nueva categoria'),
              ),
            ),
          ],
          child: _viewModel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Scrollbar(
                  thumbVisibility: true,
                  trackVisibility: true,
                  child: ListView.separated(
                    primary: true,
                    itemCount: _viewModel.categorias.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 14),
                    itemBuilder: (context, index) {
                      final categoria = _viewModel.categorias[index];
                      return CategoriaCard(
                        categoria: categoria,
                        onEdit: () => Navigator.pushNamed(
                          context,
                          AppRoutes.categoriaForm,
                          arguments: categoria,
                        ),
                        onDelete: _viewModel.isDeleting
                            ? null
                            : () => _confirmDelete(categoria),
                      );
                    },
                  ),
                ),
        );
      },
    );
  }
}
