class NegocioModel {
  const NegocioModel({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.productosServicios,
    required this.categoriaId,
    required this.categoriaSlug,
    required this.categoriaTitulo,
    required this.activo,
    required this.direccion,
    required this.whatsapp,
    required this.facebook,
    required this.instagram,
    required this.imagenUrl,
    required this.imagenLocalPath,
    required this.galeriaUrls,
    required this.galeriaLocalPaths,
    required this.latitud,
    required this.longitud,
    required this.esPrueba,
  });

  final String id;
  final String nombre;
  final String descripcion;
  final List<String> productosServicios;
  final String categoriaId;
  final String categoriaSlug;
  final String categoriaTitulo;
  final bool activo;
  final String direccion;
  final String whatsapp;
  final String facebook;
  final String instagram;
  final String imagenUrl;
  final String imagenLocalPath;
  final List<String> galeriaUrls;
  final List<String> galeriaLocalPaths;
  final double? latitud;
  final double? longitud;
  final bool esPrueba;

  factory NegocioModel.empty() {
    return const NegocioModel(
      id: '',
      nombre: '',
      descripcion: '',
      productosServicios: [],
      categoriaId: '',
      categoriaSlug: '',
      categoriaTitulo: '',
      activo: true,
      direccion: '',
      whatsapp: '',
      facebook: '',
      instagram: '',
      imagenUrl: '',
      imagenLocalPath: '',
      galeriaUrls: [],
      galeriaLocalPaths: [],
      latitud: null,
      longitud: null,
      esPrueba: false,
    );
  }

  NegocioModel copyWith({
    String? id,
    String? nombre,
    String? descripcion,
    List<String>? productosServicios,
    String? categoriaId,
    String? categoriaSlug,
    String? categoriaTitulo,
    bool? activo,
    String? direccion,
    String? whatsapp,
    String? facebook,
    String? instagram,
    String? imagenUrl,
    String? imagenLocalPath,
    List<String>? galeriaUrls,
    List<String>? galeriaLocalPaths,
    double? latitud,
    double? longitud,
    bool? esPrueba,
  }) {
    return NegocioModel(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      productosServicios: productosServicios ?? this.productosServicios,
      categoriaId: categoriaId ?? this.categoriaId,
      categoriaSlug: categoriaSlug ?? this.categoriaSlug,
      categoriaTitulo: categoriaTitulo ?? this.categoriaTitulo,
      activo: activo ?? this.activo,
      direccion: direccion ?? this.direccion,
      whatsapp: whatsapp ?? this.whatsapp,
      facebook: facebook ?? this.facebook,
      instagram: instagram ?? this.instagram,
      imagenUrl: imagenUrl ?? this.imagenUrl,
      imagenLocalPath: imagenLocalPath ?? this.imagenLocalPath,
      galeriaUrls: galeriaUrls ?? this.galeriaUrls,
      galeriaLocalPaths: galeriaLocalPaths ?? this.galeriaLocalPaths,
      latitud: latitud ?? this.latitud,
      longitud: longitud ?? this.longitud,
      esPrueba: esPrueba ?? this.esPrueba,
    );
  }
}
