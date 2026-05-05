import 'package:flutter/material.dart';
import 'package:mi_tianguis_admin/features/categorias/view/categoria_form_screen.dart';
import 'package:mi_tianguis_admin/features/categorias/view/categorias_list_screen.dart';
import 'package:mi_tianguis_admin/features/dashboard/view/dashboard_screen.dart';
import 'package:mi_tianguis_admin/features/negocios/view/negocio_detail_preview_screen.dart';
import 'package:mi_tianguis_admin/features/negocios/view/negocio_form_screen.dart';
import 'package:mi_tianguis_admin/features/negocios/view/negocios_list_screen.dart';

class AppRoutes {
  static const login = '/login';
  static const dashboard = '/';
  static const categorias = '/categorias';
  static const categoriaForm = '/categorias/form';
  static const negocios = '/negocios';
  static const negocioForm = '/negocios/form';
  static const negocioPreview = '/negocios/preview';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute<void>(
          builder: (_) => const DashboardScreen(),
          settings: settings,
        );
      case dashboard:
        return MaterialPageRoute<void>(
          builder: (_) => const DashboardScreen(),
          settings: settings,
        );
      case categorias:
        return MaterialPageRoute<void>(
          builder: (_) => const CategoriasListScreen(),
          settings: settings,
        );
      case categoriaForm:
        return MaterialPageRoute<void>(
          builder: (_) => const CategoriaFormScreen(),
          settings: settings,
        );
      case negocios:
        return MaterialPageRoute<void>(
          builder: (_) => const NegociosListScreen(),
          settings: settings,
        );
      case negocioForm:
        return MaterialPageRoute<void>(
          builder: (_) => const NegocioFormScreen(),
          settings: settings,
        );
      case negocioPreview:
        return MaterialPageRoute<void>(
          builder: (_) => const NegocioDetailPreviewScreen(),
          settings: settings,
        );
      default:
        return MaterialPageRoute<void>(
          builder: (_) => const DashboardScreen(),
          settings: settings,
        );
    }
  }
}
