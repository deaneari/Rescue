import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'localization/language_constants.dart';
import 'managers/storage_manager.dart';
import 'presentation/router/app_router.dart';

Future<void> _startFirebaseTokenSync() async {
  final User? currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser != null) {
    await StorageManager.instance.syncFirebaseUser(currentUser);
  }

  FirebaseAuth.instance.idTokenChanges().listen((user) async {
    if (user == null) {
      await StorageManager.instance.logout();
    } else {
      await StorageManager.instance.syncFirebaseUser(user);
    }
  });
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await _startFirebaseTokenSync();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'אפליקציית הצלה',
        routerConfig: appRouter,
        supportedLocales: [
          const Locale('en', ''), // English
          const Locale('ar', ''), // Arabic
        ],
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          VTranslation.delegate,
        ],
      ),
    );
  }
}
