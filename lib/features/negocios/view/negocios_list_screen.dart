import 'package:flutter/material.dart';
import 'package:mi_tianguis_admin/app/routes.dart';
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
    _viewModel = NegociosListViewModel()..load();
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
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Negocio eliminado.')),
      );
    } catch (_) {
      if (!mounted) {
        return;
      }
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
          child: _viewModel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Scrollbar(
                  thumbVisibility: true,
                  trackVisibility: true,
                  child: ListView.separated(
                    primary: true,
                    itemCount: _viewModel.negocios.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 14),
                    itemBuilder: (context, index) {
                      final negocio = _viewModel.negocios[index];
                      return NegocioCard(
                        negocio: negocio,
                        onEdit: () => Navigator.pushNamed(
                          context,
                          AppRoutes.negocioForm,
                          arguments: negocio,
                        ),
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
                ),
        );
      },
    );
  }
}
