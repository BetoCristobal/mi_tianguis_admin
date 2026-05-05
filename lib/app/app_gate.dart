import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mi_tianguis_admin/app/routes.dart';
import 'package:mi_tianguis_admin/core/services/auth_service.dart';
import 'package:mi_tianguis_admin/features/auth/view/login_screen.dart';
import 'package:mi_tianguis_admin/features/dashboard/view/dashboard_screen.dart';

class AppGate extends StatelessWidget {
  const AppGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthService.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.data == null || !AuthService.instance.isAllowedUser) {
          return const LoginScreen();
        }

        return const DashboardScreen();
      },
    );
  }
}
