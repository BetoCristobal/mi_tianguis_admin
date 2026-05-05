import 'package:flutter/foundation.dart';
import 'package:mi_tianguis_admin/data/models/categoria_model.dart';
import 'package:mi_tianguis_admin/data/models/negocio_model.dart';
import 'package:mi_tianguis_admin/data/repositories/negocio_repository.dart';

class NegociosListViewModel extends ChangeNotifier {
  NegociosListViewModel({
    NegocioRepository? repository,
  }) : _repository = repository ?? NegocioRepository();

  final NegocioRepository _repository;

  final List<CategoriaModel> _categorias = [];
  CategoriaModel? _selectedCategoria;

  final List<NegocioModel> _negocios = [];
  bool _isLoadingCategorias = false;
  bool _isLoadingNegocios = false;
  bool _isDeleting = false;

  List<CategoriaModel> get categorias => List.unmodifiable(_categorias);
  CategoriaModel? get selectedCategoria => _selectedCategoria;
  List<NegocioModel> get negocios => List.unmodifiable(_negocios);
  bool get isLoadingCategorias => _isLoadingCategorias;
  bool get isLoadingNegocios => _isLoadingNegocios;
  bool get isDeleting => _isDeleting;

  Future<void> loadCategorias() async {
    _isLoadingCategorias = true;
    notifyListeners();

    final items = await _repository.fetchCategorias();
    _categorias
      ..clear()
      ..addAll(items.where((c) => c.activo));

    _isLoadingCategorias = false;
    notifyListeners();
  }

  Future<void> selectCategoria(CategoriaModel categoria) async {
    _selectedCategoria = categoria;
    _negocios.clear();
    _isLoadingNegocios = true;
    notifyListeners();

    final items = await _repository.fetchNegociosByCategoria(categoria);
    _negocios
      ..clear()
      ..addAll(items);

    _isLoadingNegocios = false;
    notifyListeners();
  }

  Future<void> deleteNegocio(NegocioModel negocio) async {
    _isDeleting = true;
    notifyListeners();

    await _repository.deleteNegocio(negocio);
    _negocios.removeWhere((item) => item.id == negocio.id);

    _isDeleting = false;
    notifyListeners();
  }
}
