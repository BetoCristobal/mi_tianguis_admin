class CategoriaModel {
  const CategoriaModel({
    required this.id,
    required this.titulo,
    required this.slug,
    required this.descripcion,
    required this.imagenUrl,
    required this.localImagePath,
    required this.colorHex,
    required this.activo,
    required this.esPrueba,
  });

  final String id;
  final String titulo;
  final String slug;
  final String descripcion;
  final String imagenUrl;
  final String localImagePath;
  final String colorHex;
  final bool activo;
  final bool esPrueba;

  factory CategoriaModel.empty() {
    return const CategoriaModel(
      id: '',
      titulo: '',
      slug: '',
      descripcion: '',
      imagenUrl: '',
      localImagePath: '',
      colorHex: '#D96C3F',
      activo: true,
      esPrueba: false,
    );
  }

  CategoriaModel copyWith({
    String? id,
    String? titulo,
    String? slug,
    String? descripcion,
    String? imagenUrl,
    String? localImagePath,
    String? colorHex,
    bool? activo,
    bool? esPrueba,
  }) {
    return CategoriaModel(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      slug: slug ?? this.slug,
      descripcion: descripcion ?? this.descripcion,
      imagenUrl: imagenUrl ?? this.imagenUrl,
      localImagePath: localImagePath ?? this.localImagePath,
      colorHex: colorHex ?? this.colorHex,
      activo: activo ?? this.activo,
      esPrueba: esPrueba ?? this.esPrueba,
    );
  }
}
