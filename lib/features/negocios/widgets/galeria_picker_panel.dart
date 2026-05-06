import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mi_tianguis_admin/data/models/galeria_item_model.dart';

const int _kMaxGaleriaSlots = 10;

class GaleriaPickerPanel extends StatelessWidget {
  const GaleriaPickerPanel({
    super.key,
    required this.items,
    required this.onPickAt,
    required this.onRemoveAt,
    required this.onAddSlot,
  });

  final List<GaleriaItemModel> items;
  final ValueChanged<int> onPickAt;
  final ValueChanged<int> onRemoveAt;
  final VoidCallback onAddSlot;

  @override
  Widget build(BuildContext context) {
    final canAddMore = items.length < _kMaxGaleriaSlots;
    final primary = Theme.of(context).colorScheme.primary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5DBCE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.collections_outlined, color: primary, size: 28),
          const SizedBox(height: 12),
          const Text(
            'Galeria del negocio',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(
            'Agrega hasta $_kMaxGaleriaSlots fotos. Puedes reemplazar o quitar cada una.',
            style: const TextStyle(color: Color(0xFF636363), height: 1.4),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              for (var i = 0; i < items.length; i++)
                _GallerySlot(
                  index: i,
                  item: items[i],
                  onPick: () => onPickAt(i),
                  onRemove: () => onRemoveAt(i),
                ),
              if (canAddMore)
                _AddSlotButton(onTap: onAddSlot, primary: primary),
            ],
          ),
        ],
      ),
    );
  }
}

class _AddSlotButton extends StatelessWidget {
  const _AddSlotButton({required this.onTap, required this.primary});

  final VoidCallback onTap;
  final Color primary;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 170,
        height: 188,
        decoration: BoxDecoration(
          color: const Color(0xFFF9F6F1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE5DBCE), style: BorderStyle.solid),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_photo_alternate_outlined, color: primary, size: 34),
            const SizedBox(height: 8),
            Text(
              'Agregar foto',
              style: TextStyle(color: primary, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}

class _GallerySlot extends StatelessWidget {
  const _GallerySlot({
    required this.index,
    required this.item,
    required this.onPick,
    required this.onRemove,
  });

  final int index;
  final GaleriaItemModel item;
  final VoidCallback onPick;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final hasImage = item.hasImage;
    final label = item.fileName.isNotEmpty ? item.fileName : 'Imagen ${index + 1}';

    return Container(
      width: 170,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F6F1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5DBCE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: double.infinity,
              height: 110,
              child: hasImage
                  ? item.hasLocal
                      ? Image.file(File(item.localPath), fit: BoxFit.cover)
                      : Image.network(
                          item.remoteUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _EmptyGalleryPreview(index: index),
                        )
                  : _EmptyGalleryPreview(index: index),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: FilledButton.tonalIcon(
              onPressed: onPick,
              icon: const Icon(Icons.upload_file_outlined),
              label: Text(hasImage ? 'Reemplazar' : 'Subir'),
            ),
          ),
          if (hasImage) ...[
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: onRemove,
                icon: const Icon(Icons.delete_outline),
                label: const Text('Eliminar'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _EmptyGalleryPreview extends StatelessWidget {
  const _EmptyGalleryPreview({required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF1E8DA),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.add_photo_alternate_outlined,
              color: Color(0xFFD96C3F),
              size: 28,
            ),
            const SizedBox(height: 6),
            Text(
              'Foto ${index + 1}',
              style: const TextStyle(
                color: Color(0xFF866D58),
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}



