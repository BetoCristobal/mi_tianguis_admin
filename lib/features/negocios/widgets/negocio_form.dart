import 'package:flutter/material.dart';
import 'package:mi_tianguis_admin/data/models/galeria_item_model.dart';
import 'package:mi_tianguis_admin/features/negocios/widgets/galeria_picker_panel.dart';
import 'package:mi_tianguis_admin/features/negocios/widgets/image_picker_panel.dart';
import 'package:mi_tianguis_admin/features/negocios/widgets/productos_servicios_editor.dart';

class NegocioForm extends StatelessWidget {
  const NegocioForm({
    super.key,
    required this.nombreController,
    required this.descripcionController,
    required this.direccionController,
    required this.whatsappController,
    required this.facebookController,
    required this.instagramController,
    required this.latitudController,
    required this.longitudController,
    required this.categoriaId,
    required this.categoriaItems,
    required this.onCategoriaChanged,
    required this.activo,
    required this.onActivoChanged,
    required this.esPrueba,
    required this.onEsPruebaChanged,
    required this.productosServicios,
    required this.onProductosServiciosChanged,
    required this.imagenPrincipalNombre,
    required this.imagenPrincipalPreviewPath,
    required this.imagenPrincipalPreviewUrl,
    required this.onImagenPrincipalTap,
    required this.onImagenPrincipalClear,
    required this.galeriaItems,
    required this.onGaleriaPickAt,
    required this.onGaleriaRemoveAt,
  });

  final TextEditingController nombreController;
  final TextEditingController descripcionController;
  final TextEditingController direccionController;
  final TextEditingController whatsappController;
  final TextEditingController facebookController;
  final TextEditingController instagramController;
  final TextEditingController latitudController;
  final TextEditingController longitudController;
  final String categoriaId;
  final List<DropdownMenuItem<String>> categoriaItems;
  final ValueChanged<String?> onCategoriaChanged;
  final bool activo;
  final ValueChanged<bool> onActivoChanged;
  final bool esPrueba;
  final ValueChanged<bool> onEsPruebaChanged;
  final List<String> productosServicios;
  final ValueChanged<List<String>> onProductosServiciosChanged;
  final String? imagenPrincipalNombre;
  final String? imagenPrincipalPreviewPath;
  final String? imagenPrincipalPreviewUrl;
  final VoidCallback onImagenPrincipalTap;
  final VoidCallback onImagenPrincipalClear;
  final List<GaleriaItemModel> galeriaItems;
  final ValueChanged<int> onGaleriaPickAt;
  final ValueChanged<int> onGaleriaRemoveAt;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: nombreController,
          validator: (value) =>
              value == null || value.trim().isEmpty ? 'Ingresa el nombre.' : null,
          decoration: const InputDecoration(labelText: 'Nombre del negocio'),
        ),
        const SizedBox(height: 14),
        DropdownButtonFormField<String>(
          value: categoriaId.isEmpty ? null : categoriaId,
          items: categoriaItems,
          onChanged: onCategoriaChanged,
          decoration: const InputDecoration(labelText: 'Categoria'),
        ),
        const SizedBox(height: 14),
        TextFormField(
          controller: descripcionController,
          maxLines: 4,
          decoration: const InputDecoration(labelText: 'Descripcion'),
        ),
        const SizedBox(height: 14),
        TextFormField(
          controller: direccionController,
          decoration: const InputDecoration(labelText: 'Direccion'),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: whatsappController,
                decoration: const InputDecoration(labelText: 'WhatsApp'),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: TextFormField(
                controller: facebookController,
                decoration: const InputDecoration(labelText: 'Facebook'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: instagramController,
                decoration: const InputDecoration(labelText: 'Instagram'),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Activo'),
                value: activo,
                onChanged: onActivoChanged,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Dato de prueba'),
                value: esPrueba,
                onChanged: onEsPruebaChanged,
              ),
            ),
            const Expanded(child: SizedBox.shrink()),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: latitudController,
                decoration: const InputDecoration(labelText: 'Latitud'),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: TextFormField(
                controller: longitudController,
                decoration: const InputDecoration(labelText: 'Longitud'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        ProductosServiciosEditor(
          items: productosServicios,
          onChanged: onProductosServiciosChanged,
        ),
        const SizedBox(height: 18),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ImagePickerPanel(
                title: 'Imagen principal',
                description: 'Selecciona la portada del negocio.',
                fileName: imagenPrincipalNombre,
                previewPath: imagenPrincipalPreviewPath,
                previewUrl: imagenPrincipalPreviewUrl,
                onTap: onImagenPrincipalTap,
                onClear: onImagenPrincipalClear,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: GaleriaPickerPanel(
                items: galeriaItems,
                onPickAt: onGaleriaPickAt,
                onRemoveAt: onGaleriaRemoveAt,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
