import 'package:flutter/foundation.dart';
import 'package:mi_tianguis_admin/data/models/negocio_model.dart';
import 'package:mi_tianguis_admin/data/repositories/negocio_repository.dart';

class NegociosListViewModel extends ChangeNotifier {
  NegociosListViewModel({
    NegocioRepository? repository,
  }) : _repository = repository ?? NegocioRepository();

  final NegocioRepository _repository;
  final List<NegocioModel> _negocios = [];
  bool _isLoading = false;
  bool _isDeleting = false;

  List<NegocioModel> get negocios => List.unmodifiable(_negocios);
  bool get isLoading => _isLoading;
  bool get isDeleting => _isDeleting;

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();

    final items = await _repository.fetchNegocios();
    _negocios
      ..clear()
      ..addAll(items);

    _isLoading = false;
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
