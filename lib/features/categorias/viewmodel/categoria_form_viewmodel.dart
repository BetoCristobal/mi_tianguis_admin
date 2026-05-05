import 'package:flutter/foundation.dart';
import 'package:mi_tianguis_admin/data/models/categoria_model.dart';
import 'package:mi_tianguis_admin/data/repositories/categoria_repository.dart';

class CategoriaFormViewModel extends ChangeNotifier {
  CategoriaFormViewModel({
    CategoriaRepository? repository,
  }) : _repository = repository ?? CategoriaRepository();

  final CategoriaRepository _repository;
  CategoriaModel _categoria = CategoriaModel.empty();
  bool _isSaving = false;

  CategoriaModel get categoria => _categoria;
  bool get isSaving => _isSaving;

  void updateCategoria(CategoriaModel categoria) {
    _categoria = categoria;
    notifyListeners();
  }

  Future<void> save() async {
    _isSaving = true;
    notifyListeners();
    await _repository.saveCategoria(_categoria);
    _isSaving = false;
    notifyListeners();
  }
}
