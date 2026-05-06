import 'package:flutter/material.dart';
import 'package:mi_tianguis_admin/app/app_gate.dart';
import 'package:mi_tianguis_admin/app/routes.dart';
import 'package:mi_tianguis_admin/app/theme.dart';
import 'package:mi_tianguis_admin/core/services/theme_service.dart';

class MiTianguisAdminApp extends StatelessWidget {
  const MiTianguisAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: ThemeService.instance,
      builder: (context, _) {
        return MaterialApp(
          title: 'Mi Tianguis Admin',
          debugShowCheckedModeBanner: false,
          theme: buildAdminTheme(ThemeService.instance.palette),
          home: const AppGate(),
          onGenerateRoute: AppRoutes.onGenerateRoute,
        );
      },
    );
  }
}
