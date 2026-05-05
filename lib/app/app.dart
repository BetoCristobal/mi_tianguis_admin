import 'package:flutter/material.dart';
import 'package:mi_tianguis_admin/app/app_gate.dart';
import 'package:mi_tianguis_admin/app/routes.dart';
import 'package:mi_tianguis_admin/app/theme.dart';

class MiTianguisAdminApp extends StatelessWidget {
  const MiTianguisAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mi Tianguis Admin',
      debugShowCheckedModeBanner: false,
      theme: buildAdminTheme(),
      home: const AppGate(),
      onGenerateRoute: AppRoutes.onGenerateRoute,
    );
  }
}
