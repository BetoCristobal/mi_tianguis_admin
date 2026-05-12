import 'package:mi_tianguis_admin/data/models/categoria_model.dart';
import 'package:mi_tianguis_admin/data/datasources/firestore_datasource.dart';
import 'package:mi_tianguis_admin/data/datasources/storage_datasource.dart';

class CategoriaRepository {
  CategoriaRepository({
    FirestoreDatasource? firestoreDatasource,
    StorageDatasource? storageDatasource,
  })  : _firestoreDatasource =
            firestoreDatasource ?? FirestoreDatasource(),
        _storageDatasource = storageDatasource ?? StorageDatasource();

  final FirestoreDatasource _firestoreDatasource;
  final StorageDatasource _storageDatasource;

  Future<List<CategoriaModel>> fetchCategorias() async {
    return _firestoreDatasource.fetchCategorias();
  }

  Future<void> saveCategoria(CategoriaModel categoria) async {
    var imageUrl = categoria.imagenUrl;

    if (categoria.localImagePath.trim().isNotEmpty) {
      imageUrl = await _storageDatasource.uploadCategoryImage(
        categoria.slug,
        categoria.localImagePath,
      );
    }

    await _firestoreDatasource.saveCategoria(
      categoria.copyWith(imagenUrl: imageUrl),
    );
  }

  Future<void> deleteCategoria(CategoriaModel categoria) async {
    try {
      // Primero borrar de Firestore
      await _firestoreDatasource.deleteCategoria(categoria);
      
      // Luego borrar assets de Storage (que no crítico si falla en Windows)
      await _storageDatasource.deleteCategoryAssets(
        categorySlug: categoria.slug,
        imageUrl: categoria.imagenUrl,
      );
    } catch (e) {
      // Re-lanzar para que la UI lo maneje
      rethrow;
    }
  }
}
