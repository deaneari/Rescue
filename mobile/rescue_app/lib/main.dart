import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rescue_app/constants/app_colors.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
  const env = String.fromEnvironment('ENV', defaultValue: 'staging');
  await dotenv.load(fileName: '.env.$env');
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
        theme: ThemeData(
          useMaterial3: true,
          // colorScheme: ColorScheme.fromSeed(
          //   seedColor: Colors.blue,
          // ).copyWith(
          //   surface: Colors.grey[100], // 👈 THIS controls background
          // ),
          scaffoldBackgroundColor: AppColors.screenBackground,
          appBarTheme: AppBarTheme(
            backgroundColor:
                AppColors.appBarBackground, // Sets the background color
            foregroundColor:
                AppColors.appBarForeground, // Sets the text and icon color
          ),
          filledButtonTheme: FilledButtonThemeData(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.buttonBackground,
              foregroundColor: AppColors.buttonForeground,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.buttonBackground,
              foregroundColor: AppColors.buttonForeground,
            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.buttonBackground,
              side: BorderSide(color: AppColors.buttonBackground),
            ),
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: Colors.blue,
            ),
          ),
        ),
        routerConfig: appRouter,
        locale: const Locale('he'),
        supportedLocales: const [
          Locale('he', ''),
          Locale('en', ''),
        ],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          VTranslation.delegate,
        ],
      ),
    );
  }
}
