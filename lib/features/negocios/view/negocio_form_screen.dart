import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mi_tianguis_admin/app/routes.dart';
import 'package:mi_tianguis_admin/data/models/categoria_model.dart';
import 'package:mi_tianguis_admin/data/models/galeria_item_model.dart';
import 'package:mi_tianguis_admin/data/models/negocio_model.dart';
import 'package:mi_tianguis_admin/data/repositories/categoria_repository.dart';
import 'package:mi_tianguis_admin/features/negocios/viewmodel/negocio_form_viewmodel.dart';
import 'package:mi_tianguis_admin/features/negocios/widgets/negocio_form.dart';
import 'package:mi_tianguis_admin/features/shared/widgets/admin_scaffold.dart';
import 'package:mi_tianguis_admin/features/shared/widgets/section_card.dart';

class NegocioFormScreen extends StatefulWidget {
  const NegocioFormScreen({super.key});

  @override
  State<NegocioFormScreen> createState() => _NegocioFormScreenState();
}

class _NegocioFormScreenState extends State<NegocioFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _direccionController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _facebookController = TextEditingController();
  final _instagramController = TextEditingController();
  final _latitudController = TextEditingController();
  final _longitudController = TextEditingController();
  final _categoriaRepository = CategoriaRepository();
  late final NegocioFormViewModel _viewModel;

  String _negocioId = '';
  String _categoriaId = '';
  String _categoriaSlug = '';
  String _categoriaTitulo = '';
  bool _activo = true;
  bool _esPrueba = false;
  bool _seeded = false;
  bool _isLoadingCategorias = true;
  List<String> _productosServicios = [];
  String _imagenUrlActual = '';
  String _imagenUrlOriginal = '';
  String _imagenPrincipalLocalPath = '';
  String? _imagenPrincipalNombre;
  List<GaleriaItemModel> _galeriaItems = [GaleriaItemModel.empty()];
  List<CategoriaModel> _categorias = [];
  List<String> _galeriaUrlsOriginales = const [];

  @override
  void initState() {
    super.initState();
    _viewModel = NegocioFormViewModel();
    _loadCategorias();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_seeded) {
      return;
    }

    final negocio = ModalRoute.of(context)?.settings.arguments as NegocioModel?;
    if (negocio != null) {
      _negocioId = negocio.id;
      _nombreController.text = negocio.nombre;
      _descripcionController.text = negocio.descripcion;
      _direccionController.text = negocio.direccion;
      _whatsappController.text = negocio.whatsapp;
      _facebookController.text = negocio.facebook;
      _instagramController.text = negocio.instagram;
      _latitudController.text = negocio.latitud?.toString() ?? '';
      _longitudController.text = negocio.longitud?.toString() ?? '';
      _categoriaId = negocio.categoriaId;
      _categoriaSlug = negocio.categoriaSlug;
      _categoriaTitulo = negocio.categoriaTitulo;
      _activo = negocio.activo;
      _esPrueba = negocio.esPrueba;
      _productosServicios = List<String>.from(negocio.productosServicios);
      _imagenUrlActual = negocio.imagenUrl;
      _imagenUrlOriginal = negocio.imagenUrl;
      _galeriaUrlsOriginales = List<String>.from(negocio.galeriaUrls);
      _imagenPrincipalNombre = _fileNameFromUrl(negocio.imagenUrl);
      _galeriaItems = [
        ...negocio.galeriaUrls.map(
          (url) => GaleriaItemModel(
            remoteUrl: url,
            localPath: '',
            fileName: _fileNameFromUrl(url),
          ),
        ),
        GaleriaItemModel.empty(), // slot vacío para agregar más
      ];
    }

    _seeded = true;
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    _direccionController.dispose();
    _whatsappController.dispose();
    _facebookController.dispose();
    _instagramController.dispose();
    _latitudController.dispose();
    _longitudController.dispose();
    super.dispose();
  }

  Future<void> _loadCategorias() async {
    final categorias = await _categoriaRepository.fetchCategorias();
    if (!mounted) {
      return;
    }

    setState(() {
      _categorias = categorias.where((item) => item.activo).toList(growable: false);
      _isLoadingCategorias = false;
      if (_categoriaId.isNotEmpty) {
        _syncSelectedCategoryMetadata(_categoriaId);
      }
    });
  }

  void _syncSelectedCategoryMetadata(String categoriaId) {
    for (final categoria in _categorias) {
      if (categoria.id == categoriaId) {
        _categoriaSlug = categoria.slug;
        _categoriaTitulo = categoria.titulo;
        return;
      }
    }

    _categoriaSlug = '';
    _categoriaTitulo = '';
  }

  Future<void> _pickMainImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result == null || result.files.single.path == null) {
      return;
    }

    setState(() {
      _imagenPrincipalLocalPath = result.files.single.path!;
      _imagenPrincipalNombre = result.files.single.name;
    });
  }

  void _clearMainImage() {
    setState(() {
      _imagenPrincipalLocalPath = '';
      _imagenPrincipalNombre = null;
      _imagenUrlActual = '';
    });
  }

  Future<void> _pickGalleryImageAt(int index) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result == null || result.files.single.path == null) {
      return;
    }

    final selectedFile = result.files.single;
    setState(() {
      _galeriaItems[index] = _galeriaItems[index].copyWith(
        localPath: selectedFile.path!,
        fileName: selectedFile.name,
      );
    });
  }

  void _addGallerySlot() {
    setState(() {
      _galeriaItems = [..._galeriaItems, GaleriaItemModel.empty()];
    });
  }

  void _removeGalleryImageAt(int index) {
    setState(() {
      _galeriaItems = List.from(_galeriaItems)..removeAt(index);
      // Siempre dejar al menos un slot vacío al final
      if (_galeriaItems.isEmpty || _galeriaItems.last.hasImage) {
        _galeriaItems = [..._galeriaItems, GaleriaItemModel.empty()];
      }
    });
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_categoriaId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona una categoria.')),
      );
      return;
    }

    _viewModel.updateNegocio(_buildDraftNegocio());

    try {
      await _viewModel.save(
        galeriaItems: _galeriaItems,
        originalGalleryUrls: _galeriaUrlsOriginales,
        originalMainImageUrl: _imagenUrlOriginal,
      );
      if (!mounted) {
        return;
      }

      Navigator.pushReplacementNamed(context, AppRoutes.negocios);
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No se pudo guardar el negocio: $error'),
          backgroundColor: Colors.red.shade700,
        ),
      );
    }
  }

  NegocioModel _buildDraftNegocio() {
    return NegocioModel.empty().copyWith(
      id: _negocioId,
      nombre: _nombreController.text.trim(),
      descripcion: _descripcionController.text.trim(),
      direccion: _direccionController.text.trim(),
      whatsapp: _whatsappController.text.trim(),
      facebook: _facebookController.text.trim(),
      instagram: _instagramController.text.trim(),
      categoriaId: _categoriaId,
      categoriaSlug: _categoriaSlug,
      categoriaTitulo: _categoriaTitulo,
      activo: _activo,
      esPrueba: _esPrueba,
      productosServicios: _productosServicios,
      imagenUrl: _imagenUrlActual,
      imagenLocalPath: _imagenPrincipalLocalPath,
      galeriaUrls: _galeriaItems
          .where((item) => item.hasRemote)
          .map((item) => item.remoteUrl)
          .toList(growable: false),
      galeriaLocalPaths: _galeriaItems
          .where((item) => item.hasLocal)
          .map((item) => item.localPath)
          .toList(growable: false),
      latitud: double.tryParse(_latitudController.text.trim()),
      longitud: double.tryParse(_longitudController.text.trim()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _viewModel,
      builder: (context, _) {
        return Stack(
          children: [
            AdminScaffold(
          title: _negocioId.isEmpty ? 'Nuevo negocio' : 'Editar negocio',
          currentRoute: AppRoutes.negocios,
          child: Scrollbar(
            thumbVisibility: true,
            trackVisibility: true,
            child: SingleChildScrollView(
              primary: true,
              child: Align(
                alignment: Alignment.topLeft,
                child: SizedBox(
                  width: 920,
                  child: SectionCard(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Captura de negocio',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Aqui se capturara la informacion general, imagen principal y galeria.',
                            style: TextStyle(color: Color(0xFF666666)),
                          ),
                          const SizedBox(height: 24),
                          if (_isLoadingCategorias)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: Center(child: CircularProgressIndicator()),
                            )
                          else
                            NegocioForm(
                              nombreController: _nombreController,
                              descripcionController: _descripcionController,
                              direccionController: _direccionController,
                              whatsappController: _whatsappController,
                              facebookController: _facebookController,
                              instagramController: _instagramController,
                              latitudController: _latitudController,
                              longitudController: _longitudController,
                              categoriaId: _categoriaId,
                              categoriaItems: _categorias
                                  .map(
                                    (categoria) => DropdownMenuItem<String>(
                                      value: categoria.id,
                                      child: Text(categoria.titulo),
                                    ),
                                  )
                                  .toList(growable: false),
                              onCategoriaChanged: (value) {
                                setState(() {
                                  _categoriaId = value ?? '';
                                  _syncSelectedCategoryMetadata(_categoriaId);
                                });
                              },
                              activo: _activo,
                              onActivoChanged: (value) {
                                setState(() {
                                  _activo = value;
                                });
                              },
                              esPrueba: _esPrueba,
                              onEsPruebaChanged: (value) {
                                setState(() {
                                  _esPrueba = value;
                                });
                              },
                              productosServicios: _productosServicios,
                              onProductosServiciosChanged: (items) {
                                setState(() {
                                  _productosServicios = items;
                                });
                              },
                              imagenPrincipalNombre: _imagenPrincipalNombre,
                              imagenPrincipalPreviewPath: _imagenPrincipalLocalPath,
                              imagenPrincipalPreviewUrl: _imagenUrlActual,
                              onImagenPrincipalTap: _pickMainImage,
                              onImagenPrincipalClear: _clearMainImage,
                              galeriaItems: _galeriaItems,
                              onGaleriaPickAt: _pickGalleryImageAt,
                              onGaleriaRemoveAt: _removeGalleryImageAt,
                              onGaleriaAddSlot: _addGallerySlot,
                            ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              OutlinedButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancelar'),
                              ),
                              const SizedBox(width: 12),
                              FilledButton.tonal(
                                onPressed: () => Navigator.pushNamed(
                                  context,
                                  AppRoutes.negocioPreview,
                                  arguments: _buildDraftNegocio(),
                                ),
                                child: const Text('Vista previa'),
                              ),
                              const SizedBox(width: 12),
                              FilledButton(
                                onPressed: _viewModel.isSaving ? null : _handleSave,
                                child: Text(
                                  _viewModel.isSaving ? 'Guardando...' : 'Guardar',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        if (_viewModel.isSaving)
          Positioned.fill(
            child: Container(
              color: Colors.black38,
              child: const Center(
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Guardando negocio...'),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
      },
    );
  }
}

String _fileNameFromUrl(String url) {
  if (url.trim().isEmpty) {
    return '';
  }

  final parsed = Uri.tryParse(url);
  final pathSegments = parsed?.pathSegments ?? const <String>[];
  final fileSegment = pathSegments.isNotEmpty ? pathSegments.last : url;
  return fileSegment.split('?').first;
}
