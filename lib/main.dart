import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mi_tianguis_admin/app/app.dart';
import 'package:mi_tianguis_admin/core/services/auth_service.dart';
import 'package:mi_tianguis_admin/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: false,
  );

  // Force fresh login on each app launch.
  try {
    await AuthService.instance.signOut();
  } catch (_) {
    // Ignore startup sign-out failures.
  }

  runApp(const MiTianguisAdminApp());
}
