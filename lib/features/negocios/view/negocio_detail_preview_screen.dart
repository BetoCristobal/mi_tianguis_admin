import 'package:flutter/material.dart';
import 'package:mi_tianguis_admin/app/routes.dart';
import 'package:mi_tianguis_admin/data/models/negocio_model.dart';
import 'package:mi_tianguis_admin/features/shared/widgets/admin_scaffold.dart';
import 'package:mi_tianguis_admin/features/shared/widgets/section_card.dart';

class NegocioDetailPreviewScreen extends StatelessWidget {
  const NegocioDetailPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final negocio =
        ModalRoute.of(context)?.settings.arguments as NegocioModel?;

    return AdminScaffold(
      title: 'Vista previa del negocio',
      currentRoute: AppRoutes.negocios,
      child: Scrollbar(
        thumbVisibility: true,
        trackVisibility: true,
        child: ListView(
          primary: true,
          children: [
            SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Vista previa',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Aqui se mostrara como se vera el negocio antes de guardar.',
                    style: TextStyle(color: Color(0xFF666666)),
                  ),
                  if (negocio != null) ...[
                    const SizedBox(height: 20),
                    Text(
                      negocio.nombre.isEmpty ? 'Sin nombre' : negocio.nombre,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      negocio.categoriaTitulo.isEmpty
                          ? negocio.categoriaId
                          : negocio.categoriaTitulo,
                      style: const TextStyle(color: Color(0xFF6A6A6A)),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      negocio.descripcion.isEmpty
                          ? 'Sin descripcion'
                          : negocio.descripcion,
                      style: const TextStyle(height: 1.5),
                    ),
                    if (negocio.productosServicios.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: negocio.productosServicios
                            .map(
                              (item) => Chip(
                                label: Text(item),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
