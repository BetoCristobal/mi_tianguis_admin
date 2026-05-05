import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class StorageDatasource {
  StorageDatasource({
    FirebaseStorage? storage,
  }) : _storage = storage ?? FirebaseStorage.instance;

  final FirebaseStorage _storage;

  File _validatedLocalFile(String localPath) {
    final file = File(localPath);
    if (!file.existsSync()) {
      throw StateError('No existe el archivo seleccionado: $localPath');
    }
    return file;
  }

  Future<String> uploadCategoryImage(String categorySlug, String localPath) async {
    final extension = path.extension(localPath).trim().isEmpty
        ? '.png'
        : path.extension(localPath).toLowerCase();
    final ref = _storage.ref().child(
      'categorias/$categorySlug/icono$extension',
    );

    await ref.putFile(_validatedLocalFile(localPath));
    return ref.getDownloadURL();
  }

  Future<String> uploadBusinessMainImage({
    required String categoriaSlug,
    required String negocioId,
    required String localPath,
  }) async {
    final extension = path.extension(localPath).trim().isEmpty
        ? '.png'
        : path.extension(localPath).toLowerCase();
    final ref = _storage.ref().child(
      'negocios/$categoriaSlug/$negocioId/principal$extension',
    );

    await ref.putFile(_validatedLocalFile(localPath));
    return ref.getDownloadURL();
  }

  Future<String> uploadBusinessGalleryImage({
    required String categoriaSlug,
    required String negocioId,
    required int slotIndex,
    required String localPath,
  }) async {
    final extension = path.extension(localPath).trim().isEmpty
        ? '.png'
        : path.extension(localPath).toLowerCase();
    final ref = _storage.ref().child(
      'negocios/$categoriaSlug/$negocioId/$slotIndex$extension',
    );

    await ref.putFile(_validatedLocalFile(localPath));
    return ref.getDownloadURL();
  }

  Future<void> deleteCategoryAssets({
    required String categorySlug,
    String? imageUrl,
  }) async {
    await _deleteByUrlIfPresent(imageUrl);
  }

  Future<void> deleteBusinessAssets({
    required String categoriaSlug,
    required String negocioId,
    String? mainImageUrl,
    List<String> galleryUrls = const [],
  }) async {
    await _deleteByUrlIfPresent(mainImageUrl);
    for (final url in galleryUrls) {
      await _deleteByUrlIfPresent(url);
    }
  }

  Future<void> _deleteByUrlIfPresent(String? url) async {
    if (url == null || url.trim().isEmpty) {
      return;
    }

    try {
      // Usamos REST API directamente para evitar el bug de "non-platform thread"
      // del plugin firebase_storage en Windows en operaciones de borrado.
      final deleteUrl = _buildDeleteRestUrl(url);
      if (deleteUrl == null) return;

      final response = await http.delete(Uri.parse(deleteUrl));
      if (response.statusCode != 200 && response.statusCode != 204) {
        // ignore: avoid_print
        print('[StorageDatasource] Error al borrar (${response.statusCode}): ${response.body}');
      }
    } catch (e) {
      // ignore: avoid_print
      print('[StorageDatasource] Excepción al borrar $url → $e');
    }
  }

  Future<void> deleteFileByUrl(String? url) async {
    await _deleteByUrlIfPresent(url);
  }
}

String? _buildDeleteRestUrl(String downloadUrl) {
  // La URL de descarga tiene formato:
  // https://firebasestorage.googleapis.com/v0/b/{bucket}/o/{encodedPath}?alt=media&token=...
  // La REST API de borrado es exactamente la misma URL sin los query params.
  final uri = Uri.tryParse(downloadUrl);
  if (uri == null) return null;

  final markerIndex = downloadUrl.indexOf('/o/');
  if (markerIndex == -1) return null;

  final base = downloadUrl.substring(0, markerIndex + 3);
  final encodedPath = downloadUrl.substring(markerIndex + 3).split('?').first;
  if (encodedPath.isEmpty) return null;

  return '$base$encodedPath';
}

String? _extractStoragePathFromUrl(String url) {
  final uri = Uri.tryParse(url);
  if (uri == null) {
    return null;
  }

  final fullUrl = uri.toString();
  final markerIndex = fullUrl.indexOf('/o/');
  if (markerIndex == -1) {
    return null;
  }

  final encodedPath = fullUrl.substring(markerIndex + 3).split('?').first;
  if (encodedPath.isEmpty) {
    return null;
  }

  return Uri.decodeFull(encodedPath);
}
