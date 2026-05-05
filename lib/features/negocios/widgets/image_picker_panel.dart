import 'dart:io';

import 'package:flutter/material.dart';

class ImagePickerPanel extends StatelessWidget {
  const ImagePickerPanel({
    super.key,
    required this.title,
    required this.description,
    this.fileName,
    this.previewPath,
    this.previewUrl,
    this.onTap,
    this.onClear,
  });

  final String title;
  final String description;
  final String? fileName;
  final String? previewPath;
  final String? previewUrl;
  final VoidCallback? onTap;
  final VoidCallback? onClear;

  bool get _hasLocalPreview => previewPath != null && previewPath!.trim().isNotEmpty;
  bool get _hasRemotePreview => previewUrl != null && previewUrl!.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
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
            if (_hasLocalPreview || _hasRemotePreview) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: SizedBox(
                  height: 180,
                  width: double.infinity,
                  child: _hasLocalPreview
                      ? Image.file(
                          File(previewPath!),
                          fit: BoxFit.cover,
                        )
                      : Image.network(
                          previewUrl!,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              const SizedBox(height: 14),
            ] else ...[
              const Icon(
                Icons.add_photo_alternate_outlined,
                color: Color(0xFFD96C3F),
                size: 28,
              ),
              const SizedBox(height: 12),
            ],
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              fileName?.isNotEmpty == true ? fileName! : description,
              style: const TextStyle(
                color: Color(0xFF636363),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                FilledButton.tonalIcon(
                  onPressed: onTap,
                  icon: const Icon(Icons.upload_file_outlined),
                  label: Text(
                    _hasLocalPreview || _hasRemotePreview
                        ? 'Reemplazar imagen'
                        : 'Seleccionar imagen',
                  ),
                ),
                if ((_hasLocalPreview || _hasRemotePreview) && onClear != null)
                  OutlinedButton.icon(
                    onPressed: onClear,
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Quitar'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
