import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:mi_tianguis_admin/data/models/categoria_model.dart';
import 'package:mi_tianguis_admin/data/models/negocio_model.dart';
import 'package:mi_tianguis_admin/data/models/sync_meta_model.dart';

/// Estadísticas rápidas para el dashboard.
class DashboardStats {
  const DashboardStats({
    required this.categoriasCount,
    required this.negociosCount,
    required this.syncMeta,
  });

  final int categoriasCount;
  final int negociosCount;
  final SyncMetaModel syncMeta;
}

class FirestoreDatasource {
  FirestoreDatasource({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Future<DashboardStats> fetchDashboardStats() async {
    final results = await Future.wait([
      _firestore.collection('categorias').count().get(),
      _firestore.collection('negocios').count().get(),
      _firestore.collection('app_meta').doc('sync').get(),
    ]);

    final categoriasSnap = results[0] as AggregateQuerySnapshot;
    final negociosSnap = results[1] as AggregateQuerySnapshot;
    final syncSnap = results[2] as DocumentSnapshot<Map<String, dynamic>>;

    final syncData = syncSnap.data();
    final categoriasTs = syncData?['categoriasUpdatedAt'] as Timestamp?;
    final negociosTs = syncData?['negociosUpdatedAt'] as Timestamp?;

    return DashboardStats(
      categoriasCount: categoriasSnap.count ?? 0,
      negociosCount: negociosSnap.count ?? 0,
      syncMeta: SyncMetaModel(
        categoriasUpdatedAt: categoriasTs?.toDate(),
        negociosUpdatedAt: negociosTs?.toDate(),
      ),
    );
  }

  Future<List<CategoriaModel>> fetchCategorias() async {
    final snapshot = await _firestore.collection('categorias').get();
    final items = snapshot.docs
        .map((doc) {
          final data = doc.data();
          return CategoriaModel(
            id: doc.id,
            titulo: (data['titulo'] ?? '') as String,
            slug: (data['slug'] ?? doc.id) as String,
            descripcion: (data['descripcion'] ?? '') as String,
            imagenUrl: ((data['image'] ?? data['imagen']) ?? '') as String,
            localImagePath: '',
            colorHex: (data['color'] ?? '#D96C3F') as String,
            activo: (data['activo'] ?? true) as bool,
            esPrueba: (data['es_prueba'] ?? false) as bool,
          );
        })
        .toList(growable: false)
      ..sort((a, b) => a.titulo.compareTo(b.titulo));

    return items;
  }

  Future<void> saveCategoria(CategoriaModel categoria) async {
    final now = Timestamp.now();
    final docId = categoria.id.isNotEmpty ? categoria.id : categoria.slug;

    await _firestore.collection('categorias').doc(docId).set({
      'titulo': categoria.titulo,
      'slug': categoria.slug,
      'descripcion': categoria.descripcion,
      'imagen': categoria.imagenUrl,
      'color': categoria.colorHex,
      'activo': categoria.activo,
      'es_prueba': categoria.esPrueba,
      'actualizado': now,
    }, SetOptions(merge: true));

    await _firestore.collection('app_meta').doc('sync').set({
      'categoriasUpdatedAt': now,
    }, SetOptions(merge: true));
  }

  NegocioModel _mapDocToNegocio(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
    Map<String, CategoriaModel> categoriasById,
    Map<String, CategoriaModel> categoriasByPath,
  ) {
    final data = doc.data();
    final categoriaRef =
        data['categoria'] as DocumentReference<Map<String, dynamic>>?;
    final categoriaIdFromField = (data['categoria_id'] ?? '').toString();
    final categoria =
        categoriasByPath[categoriaRef?.path ?? ''] ??
        categoriasById[categoriaIdFromField];
    final productosServicios =
        ((data['productos_servicios'] as List<dynamic>?) ?? [])
            .map((item) => item.toString().trim())
            .where((item) => item.isNotEmpty)
            .toList(growable: false);
    final galeria =
        ((data['galeria'] as List<dynamic>?) ?? [])
            .map((item) => item.toString().trim())
            .where((item) => item.isNotEmpty)
            .take(5)
            .toList(growable: false);
    final geoPoint = data['coordenadas'] as GeoPoint?;

    return NegocioModel(
      id: doc.id,
      nombre: (data['nombre'] ?? '') as String,
      descripcion: (data['descripcion'] ?? '') as String,
      productosServicios: productosServicios,
      categoriaId: categoria?.id ?? '',
      categoriaSlug: categoria?.slug ?? '',
      categoriaTitulo: categoria?.titulo ?? '',
      activo: (data['activo'] ?? true) as bool,
      direccion: (data['direccion'] ?? '') as String,
      whatsapp: (data['whatsapp'] ?? '') as String,
      facebook: (data['facebook'] ?? '') as String,
      instagram: (data['instagram'] ?? '') as String,
      imagenUrl: ((data['image'] ?? data['imagen']) ?? '') as String,
      imagenLocalPath: '',
      galeriaUrls: galeria,
      galeriaLocalPaths: const [],
      latitud: geoPoint?.latitude,
      longitud: geoPoint?.longitude,
      esPrueba: (data['es_prueba'] ?? false) as bool,
    );
  }

  Future<List<NegocioModel>> fetchNegocios() async {
    final categorias = await fetchCategorias();
    final categoriasById = {
      for (final categoria in categorias) categoria.id: categoria,
    };
    final categoriasByPath = {
      for (final categoria in categorias) 'categorias/${categoria.id}': categoria,
    };

    final snapshot = await _firestore.collection('negocios').get();
    final items = snapshot.docs
        .map((doc) => _mapDocToNegocio(doc, categoriasById, categoriasByPath))
        .toList(growable: false)
      ..sort((a, b) => a.nombre.compareTo(b.nombre));

    return items;
  }

  Future<List<NegocioModel>> fetchNegociosByCategoria(CategoriaModel categoria) async {
    final categoriasById = {categoria.id: categoria};
    final categoriasByPath = {'categorias/${categoria.id}': categoria};

    // Query by new field first; also fetch docs with old DocumentReference format
    // by matching the categoria path.
    final snapshot = await _firestore
        .collection('negocios')
        .where('categoria_id', isEqualTo: categoria.id)
        .get();

    final items = snapshot.docs
        .map((doc) => _mapDocToNegocio(doc, categoriasById, categoriasByPath))
        .toList(growable: false)
      ..sort((a, b) => a.nombre.compareTo(b.nombre));

    return items;
  }

  Future<void> saveNegocio(NegocioModel negocio) async {
    final now = Timestamp.now();
    final docId = negocio.id.isNotEmpty ? negocio.id : _slugify(negocio.nombre);

    if (docId.trim().isEmpty) {
      throw StateError('No se pudo generar un id para el negocio.');
    }

    if (negocio.categoriaId.trim().isEmpty) {
      throw StateError('Debes seleccionar una categoria valida.');
    }

    final payload = <String, dynamic>{
      'nombre': negocio.nombre,
      'descripcion': negocio.descripcion,
      'productos_servicios': negocio.productosServicios,
      'categoria_id': negocio.categoriaId,
      'categoria_slug': negocio.categoriaSlug,
      'categoria_titulo': negocio.categoriaTitulo,
      'activo': negocio.activo,
      'direccion': negocio.direccion,
      'whatsapp': negocio.whatsapp,
      'facebook': negocio.facebook,
      'instagram': negocio.instagram,
      'imagen': negocio.imagenUrl,
      'galeria': negocio.galeriaUrls,
      'es_prueba': negocio.esPrueba,
      'coordenadas':
          negocio.latitud == null || negocio.longitud == null
              ? null
              : GeoPoint(negocio.latitud!, negocio.longitud!),
      'actualizado': now,
    };

    // On Windows desktop, writing a DocumentReference has caused native
    // runtime aborts on some Firebase SDK combinations.
    if (defaultTargetPlatform != TargetPlatform.windows) {
      payload['categoria'] = _firestore
          .collection('categorias')
          .doc(negocio.categoriaId);
    }

    if (negocio.id.isEmpty) {
      payload['creado'] = now;
    }

    await _firestore
        .collection('negocios')
        .doc(docId)
        .set(payload, SetOptions(merge: true));

    await _firestore.collection('app_meta').doc('sync').set({
      'negociosUpdatedAt': now,
    }, SetOptions(merge: true));
  }

  Future<void> deleteCategoria(CategoriaModel categoria) async {
    final categoriaRef = _firestore.collection('categorias').doc(categoria.id);
    final negociosRelacionados = await _firestore
        .collection('negocios')
        .where('categoria', isEqualTo: categoriaRef)
        .limit(1)
        .get();

    final negociosRelacionadosPorId = await _firestore
        .collection('negocios')
        .where('categoria_id', isEqualTo: categoria.id)
        .limit(1)
        .get();

    if (negociosRelacionados.docs.isNotEmpty ||
        negociosRelacionadosPorId.docs.isNotEmpty) {
      throw StateError(
        'No puedes eliminar esta categoria porque todavia tiene negocios asociados.',
      );
    }

    await categoriaRef.delete();
    await _firestore.collection('app_meta').doc('sync').set({
      'categoriasUpdatedAt': Timestamp.now(),
    }, SetOptions(merge: true));
  }

  Future<void> deleteNegocio(NegocioModel negocio) async {
    await _firestore.collection('negocios').doc(negocio.id).delete();
    await _firestore.collection('app_meta').doc('sync').set({
      'negociosUpdatedAt': Timestamp.now(),
    }, SetOptions(merge: true));
  }
}

String _slugify(String value) {
  return value
      .trim()
      .toLowerCase()
      .replaceAll(RegExp(r'[^\w\s-]'), '')
      .replaceAll(RegExp(r'\s+'), '_');
}
