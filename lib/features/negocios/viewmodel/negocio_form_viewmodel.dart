import 'package:flutter/foundation.dart';
import 'package:mi_tianguis_admin/data/models/galeria_item_model.dart';
import 'package:mi_tianguis_admin/data/models/negocio_model.dart';
import 'package:mi_tianguis_admin/data/repositories/negocio_repository.dart';

class NegocioFormViewModel extends ChangeNotifier {
  NegocioFormViewModel({
    NegocioRepository? repository,
  }) : _repository = repository ?? NegocioRepository();

  final NegocioRepository _repository;
  NegocioModel _negocio = NegocioModel.empty();
  bool _isSaving = false;

  NegocioModel get negocio => _negocio;
  bool get isSaving => _isSaving;

  void updateNegocio(NegocioModel negocio) {
    _negocio = negocio;
    notifyListeners();
  }

  Future<void> save({
    required List<GaleriaItemModel> galeriaItems,
    List<String> originalGalleryUrls = const [],
    String originalMainImageUrl = '',
  }) async {
    _isSaving = true;
    notifyListeners();
    await _repository.saveNegocio(
      negocio: _negocio,
      galeriaItems: galeriaItems,
      originalGalleryUrls: originalGalleryUrls,
      originalMainImageUrl: originalMainImageUrl,
    );
    _isSaving = false;
    notifyListeners();
  }
}
