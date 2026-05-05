import 'package:mi_tianguis_admin/data/datasources/firestore_datasource.dart';
import 'package:mi_tianguis_admin/data/datasources/storage_datasource.dart';
import 'package:mi_tianguis_admin/data/models/galeria_item_model.dart';
import 'package:mi_tianguis_admin/data/models/negocio_model.dart';

class NegocioRepository {
  NegocioRepository({
    FirestoreDatasource? firestoreDatasource,
    StorageDatasource? storageDatasource,
  })  : _firestoreDatasource =
            firestoreDatasource ?? FirestoreDatasource(),
        _storageDatasource = storageDatasource ?? StorageDatasource();

  final FirestoreDatasource _firestoreDatasource;
  final StorageDatasource _storageDatasource;

  Future<List<NegocioModel>> fetchNegocios() async {
    return _firestoreDatasource.fetchNegocios();
  }

  Future<void> saveNegocio({
    required NegocioModel negocio,
    required List<GaleriaItemModel> galeriaItems,
    List<String> originalGalleryUrls = const [],
    String originalMainImageUrl = '',
  }) async {
    final negocioId = negocio.id.isNotEmpty ? negocio.id : _slugify(negocio.nombre);
    var mainImageUrl = negocio.imagenUrl;
    final previousMainImageUrl = originalMainImageUrl.trim().isNotEmpty
        ? originalMainImageUrl
        : negocio.imagenUrl;
    final previousGalleryUrls = originalGalleryUrls.isNotEmpty
        ? List<String>.from(originalGalleryUrls)
        : List<String>.from(negocio.galeriaUrls);
    final galleryUrls = <String>[];

    // Borrar imagen principal si se reemplazó por una local
    if (negocio.imagenLocalPath.trim().isNotEmpty) {
      await _storageDatasource.deleteFileByUrl(previousMainImageUrl);
      mainImageUrl = await _storageDatasource.uploadBusinessMainImage(
        categoriaSlug: negocio.categoriaSlug,
        negocioId: negocioId,
        localPath: negocio.imagenLocalPath,
      );
    }

    final normalizedItems = galeriaItems
        .where((item) => item.hasImage)
        .take(5)
        .toList(growable: false);

    for (var index = 0; index < normalizedItems.length; index++) {
      final item = normalizedItems[index];
      if (item.hasLocal) {
        final uploadedUrl = await _storageDatasource.uploadBusinessGalleryImage(
          categoriaSlug: negocio.categoriaSlug,
          negocioId: negocioId,
          slotIndex: index + 1,
          localPath: item.localPath,
        );
        galleryUrls.add(uploadedUrl);
      } else if (item.hasRemote) {
        galleryUrls.add(item.remoteUrl);
      }
    }

    // Borrar del Storage las URLs de galería que ya no están en la lista nueva
    final removedUrls = previousGalleryUrls
        .where((url) => !galleryUrls.contains(url))
        .toList();
    for (final url in removedUrls) {
      await _storageDatasource.deleteFileByUrl(url);
    }

    await _firestoreDatasource.saveNegocio(
      negocio.copyWith(
        id: negocioId,
        imagenUrl: mainImageUrl,
        galeriaUrls: galleryUrls,
      ),
    );
  }

  Future<void> deleteNegocio(NegocioModel negocio) async {
    await _firestoreDatasource.deleteNegocio(negocio);
    await _storageDatasource.deleteBusinessAssets(
      categoriaSlug: negocio.categoriaSlug,
      negocioId: negocio.id,
      mainImageUrl: negocio.imagenUrl,
      galleryUrls: negocio.galeriaUrls,
    );
  }
}

String _slugify(String value) {
  return value
      .trim()
      .toLowerCase()
      .replaceAll(RegExp(r'[^\w\s-]'), '')
      .replaceAll(RegExp(r'\s+'), '_');
}
