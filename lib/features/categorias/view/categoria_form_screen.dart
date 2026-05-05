import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mi_tianguis_admin/app/routes.dart';
import 'package:mi_tianguis_admin/data/models/categoria_model.dart';
import 'package:mi_tianguis_admin/features/categorias/viewmodel/categoria_form_viewmodel.dart';
import 'package:mi_tianguis_admin/features/categorias/widgets/categoria_form.dart';
import 'package:mi_tianguis_admin/features/negocios/widgets/image_picker_panel.dart';
import 'package:mi_tianguis_admin/features/shared/widgets/admin_scaffold.dart';
import 'package:mi_tianguis_admin/features/shared/widgets/section_card.dart';

class CategoriaFormScreen extends StatefulWidget {
  const CategoriaFormScreen({super.key});

  @override
  State<CategoriaFormScreen> createState() => _CategoriaFormScreenState();
}

class _CategoriaFormScreenState extends State<CategoriaFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _slugController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _colorController = TextEditingController(text: '#D96C3F');
  late final CategoriaFormViewModel _viewModel;
  bool _activo = true;
  bool _esPrueba = false;
  bool _seeded = false;
  String _categoriaId = '';
  String _imagenUrlActual = '';
  String _imagenLocalPath = '';
  String? _imagenNombre;

  @override
  void initState() {
    super.initState();
    _viewModel = CategoriaFormViewModel();
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _slugController.dispose();
    _descripcionController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_seeded) {
      return;
    }

    final categoria =
        ModalRoute.of(context)?.settings.arguments as CategoriaModel?;
    if (categoria != null) {
      _categoriaId = categoria.id;
      _tituloController.text = categoria.titulo;
      _slugController.text = categoria.slug;
      _descripcionController.text = categoria.descripcion;
      _colorController.text = categoria.colorHex;
      _activo = categoria.activo;
      _esPrueba = categoria.esPrueba;
      _imagenUrlActual = categoria.imagenUrl;
    }

    _seeded = true;
  }

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result == null || result.files.single.path == null) {
      return;
    }

    setState(() {
      _imagenLocalPath = result.files.single.path!;
      _imagenNombre = result.files.single.name;
    });
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _viewModel.updateCategoria(
      CategoriaModel.empty().copyWith(
        id: _categoriaId,
        titulo: _tituloController.text.trim(),
        slug: _slugController.text.trim(),
        descripcion: _descripcionController.text.trim(),
        imagenUrl: _imagenUrlActual,
        localImagePath: _imagenLocalPath,
        colorHex: _colorController.text.trim(),
        activo: _activo,
        esPrueba: _esPrueba,
      ),
    );

    try {
      await _viewModel.save();
      if (!mounted) {
        return;
      }

      Navigator.pushReplacementNamed(context, AppRoutes.categorias);
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No se pudo guardar la categoria: $error'),
          backgroundColor: Colors.red.shade700,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _viewModel,
      builder: (context, _) {
        return AdminScaffold(
          title: _categoriaId.isEmpty ? 'Nueva categoria' : 'Editar categoria',
          currentRoute: AppRoutes.categorias,
          child: Scrollbar(
            thumbVisibility: true,
            trackVisibility: true,
            child: SingleChildScrollView(
              primary: true,
              child: Align(
                alignment: Alignment.topLeft,
                child: SizedBox(
                  width: 760,
                  child: SectionCard(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Captura de categoria',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Aqui se definira el contenido base que luego usaran los negocios.',
                            style: TextStyle(color: Color(0xFF666666)),
                          ),
                          const SizedBox(height: 24),
                          ImagePickerPanel(
                            title: 'Imagen de categoria',
                            description: _imagenUrlActual.isEmpty
                                ? 'Selecciona el icono o imagen principal.'
                                : 'Ya existe una imagen guardada en Firebase.',
                            fileName: _imagenNombre,
                            previewPath: _imagenLocalPath,
                            previewUrl: _imagenUrlActual,
                            onTap: _pickImage,
                          ),
                          const SizedBox(height: 18),
                          CategoriaForm(
                            tituloController: _tituloController,
                            slugController: _slugController,
                            descripcionController: _descripcionController,
                            colorController: _colorController,
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
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              OutlinedButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancelar'),
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
        );
      },
    );
  }
}
