import 'package:flutter/material.dart';
import 'package:mi_tianguis_admin/data/models/categoria_model.dart';
import 'package:mi_tianguis_admin/features/shared/widgets/section_card.dart';

class CategoriaCard extends StatelessWidget {
  const CategoriaCard({
    super.key,
    required this.categoria,
    this.onEdit,
    this.onDelete,
  });

  final CategoriaModel categoria;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Row(
        children: [
          _CategoryVisual(categoria: categoria),
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
                      categoria.titulo,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    if (categoria.esPrueba)
                      const _FlagChip(
                        label: 'Prueba',
                        backgroundColor: Color(0xFFFFF3E4),
                        foregroundColor: Color(0xFFD96C3F),
                      ),
                    _FlagChip(
                      label: categoria.activo ? 'Activa' : 'Inactiva',
                      backgroundColor: categoria.activo
                          ? const Color(0xFFE7F6ED)
                          : const Color(0xFFF3F3F3),
                      foregroundColor: categoria.activo
                          ? const Color(0xFF1F8A4C)
                          : const Color(0xFF707070),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  categoria.slug,
                  style: const TextStyle(color: Color(0xFF6A6A6A)),
                ),
                const SizedBox(height: 6),
                Text(
                  categoria.descripcion,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF555555),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Column(
            children: [
              FilledButton.tonal(
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

class _CategoryVisual extends StatelessWidget {
  const _CategoryVisual({required this.categoria});

  final CategoriaModel categoria;

  @override
  Widget build(BuildContext context) {
    final hasImage = categoria.imagenUrl.trim().isNotEmpty;

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 54,
        height: 54,
        color: _parseHex(categoria.colorHex).withValues(alpha: 0.14),
        child: hasImage
            ? Image.network(
                categoria.imagenUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _FallbackCategoryIcon(
                  color: _parseHex(categoria.colorHex),
                ),
              )
            : _FallbackCategoryIcon(
                color: _parseHex(categoria.colorHex),
              ),
      ),
    );
  }
}

class _FallbackCategoryIcon extends StatelessWidget {
  const _FallbackCategoryIcon({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.category_rounded,
      color: color,
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

Color _parseHex(String value) {
  final sanitized = value.replaceAll('#', '').trim();
  final normalized = sanitized.length == 6 ? 'FF$sanitized' : sanitized;
  final parsed = int.tryParse(normalized, radix: 16);
  return Color(parsed ?? 0xFFD96C3F);
}
