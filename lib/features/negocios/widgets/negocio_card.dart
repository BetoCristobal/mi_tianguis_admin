import 'package:flutter/material.dart';
import 'package:mi_tianguis_admin/data/models/negocio_model.dart';
import 'package:mi_tianguis_admin/features/shared/widgets/section_card.dart';

class NegocioCard extends StatelessWidget {
  const NegocioCard({
    super.key,
    required this.negocio,
    this.onEdit,
    this.onPreview,
    this.onDelete,
  });

  final NegocioModel negocio;
  final VoidCallback? onEdit;
  final VoidCallback? onPreview;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFFF4E6D8),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.storefront_rounded,
              color: Color(0xFFD96C3F),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      negocio.nombre,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    if (negocio.esPrueba)
                      const _FlagChip(
                        label: 'Prueba',
                        backgroundColor: Color(0xFFFFF3E4),
                        foregroundColor: Color(0xFFD96C3F),
                      ),
                    _FlagChip(
                      label: negocio.activo ? 'Activo' : 'Inactivo',
                      backgroundColor: negocio.activo
                          ? const Color(0xFFE7F6ED)
                          : const Color(0xFFF3F3F3),
                      foregroundColor: negocio.activo
                          ? const Color(0xFF1F8A4C)
                          : const Color(0xFF707070),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  negocio.categoriaTitulo.isEmpty
                      ? negocio.categoriaId
                      : negocio.categoriaTitulo,
                  style: const TextStyle(color: Color(0xFF6A6A6A)),
                ),
                const SizedBox(height: 8),
                Text(
                  negocio.descripcion,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF555555),
                    height: 1.4,
                  ),
                ),
                if (negocio.productosServicios.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: negocio.productosServicios
                        .take(3)
                        .map(
                          (item) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8F4EC),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              item,
                              style: const TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 16),
          Column(
            children: [
              FilledButton.tonal(
                onPressed: onPreview,
                child: const Text('Vista previa'),
              ),
              const SizedBox(height: 10),
              FilledButton(
                onPressed: onEdit,
                child: const Text('Editar'),
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline),
                label: const Text('Eliminar'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FlagChip extends StatelessWidget {
  const _FlagChip({
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  final String label;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: foregroundColor,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
