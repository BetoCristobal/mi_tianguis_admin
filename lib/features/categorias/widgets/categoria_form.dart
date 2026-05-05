import 'package:flutter/material.dart';

class CategoriaForm extends StatelessWidget {
  const CategoriaForm({
    super.key,
    required this.tituloController,
    required this.slugController,
    required this.descripcionController,
    required this.colorController,
    required this.activo,
    required this.onActivoChanged,
    required this.esPrueba,
    required this.onEsPruebaChanged,
  });

  final TextEditingController tituloController;
  final TextEditingController slugController;
  final TextEditingController descripcionController;
  final TextEditingController colorController;
  final bool activo;
  final ValueChanged<bool> onActivoChanged;
  final bool esPrueba;
  final ValueChanged<bool> onEsPruebaChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: tituloController,
          decoration: const InputDecoration(labelText: 'Titulo'),
        ),
        const SizedBox(height: 14),
        TextFormField(
          controller: slugController,
          decoration: const InputDecoration(labelText: 'Slug'),
        ),
        const SizedBox(height: 14),
        TextFormField(
          controller: descripcionController,
          maxLines: 4,
          decoration: const InputDecoration(labelText: 'Descripcion'),
        ),
        const SizedBox(height: 14),
        TextFormField(
          controller: colorController,
          decoration: const InputDecoration(labelText: 'Color hexadecimal'),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Activa'),
                value: activo,
                onChanged: onActivoChanged,
              ),
            ),
            Expanded(
              child: SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Dato de prueba'),
                value: esPrueba,
                onChanged: onEsPruebaChanged,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
