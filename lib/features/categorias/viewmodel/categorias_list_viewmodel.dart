import 'package:flutter/foundation.dart';
import 'package:mi_tianguis_admin/data/models/categoria_model.dart';
import 'package:mi_tianguis_admin/data/repositories/categoria_repository.dart';

class CategoriasListViewModel extends ChangeNotifier {
  CategoriasListViewModel({
    CategoriaRepository? repository,
  }) : _repository = repository ?? CategoriaRepository();

  final CategoriaRepository _repository;

  final List<CategoriaModel> _categorias = [];
  bool _isLoading = false;
  bool _isDeleting = false;

  List<CategoriaModel> get categorias => List.unmodifiable(_categorias);
  bool get isLoading => _isLoading;
  bool get isDeleting => _isDeleting;

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();

    final items = await _repository.fetchCategorias();
    _categorias
      ..clear()
      ..addAll(items);

    _isLoading = false;
    notifyListeners();
  }

  Future<void> deleteCategoria(CategoriaModel categoria) async {
    _isDeleting = true;
    notifyListeners();

    try {
      await _repository.deleteCategoria(categoria);
      _categorias.removeWhere((item) => item.id == categoria.id);
    } finally {
      _isDeleting = false;
      notifyListeners();
    }
  }
}
