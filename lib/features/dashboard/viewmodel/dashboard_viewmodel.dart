import 'package:flutter/foundation.dart';
import 'package:mi_tianguis_admin/data/datasources/firestore_datasource.dart';
import 'package:mi_tianguis_admin/data/models/sync_meta_model.dart';

class DashboardViewModel extends ChangeNotifier {
  DashboardViewModel({FirestoreDatasource? datasource})
      : _datasource = datasource ?? FirestoreDatasource();

  final FirestoreDatasource _datasource;

  int _categoriasCount = 0;
  int _negociosCount = 0;
  SyncMetaModel _syncMeta = const SyncMetaModel(
    categoriasUpdatedAt: null,
    negociosUpdatedAt: null,
  );
  bool _isLoading = false;
  String? _error;

  int get categoriasCount => _categoriasCount;
  int get negociosCount => _negociosCount;
  SyncMetaModel get syncMeta => _syncMeta;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> load() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final stats = await _datasource.fetchDashboardStats();
      _categoriasCount = stats.categoriasCount;
      _negociosCount = stats.negociosCount;
      _syncMeta = stats.syncMeta;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
