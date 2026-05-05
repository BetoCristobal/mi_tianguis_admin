import 'package:flutter/material.dart';

class ProductosServiciosEditor extends StatelessWidget {
  const ProductosServiciosEditor({
    super.key,
    required this.items,
    required this.onChanged,
  });

  final List<String> items;
  final ValueChanged<List<String>> onChanged;

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();

    return StatefulBuilder(
      builder: (context, setLocalState) {
        final currentItems = List<String>.from(items);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      labelText: 'Agregar producto o servicio',
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                FilledButton(
                  onPressed: () {
                    final value = controller.text.trim();
                    if (value.isEmpty) {
                      return;
                    }
                    currentItems.add(value);
                    controller.clear();
                    onChanged(currentItems);
                    setLocalState(() {});
                  },
                  child: const Text('Agregar'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: currentItems
                  .map(
                    (item) => InputChip(
                      label: Text(item),
                      onDeleted: () {
                        currentItems.remove(item);
                        onChanged(currentItems);
                        setLocalState(() {});
                      },
                    ),
                  )
                  .toList(),
            ),
          ],
        );
      },
    );
  }
}
