import 'package:bloomix_mobile_app/core/app_colors.dart';
import 'package:bloomix_mobile_app/views/authentication_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bloomix',
      theme: ThemeData(
        colorScheme: .fromSeed(
          seedColor: AppColors.primaryGreen,

          primary: AppColors.primaryGreen,
          secondary: AppColors.darkGreen,

          surface: AppColors.background,

          onPrimary: AppColors.white,
          onSecondary: AppColors.white,

          onSurface: AppColors.textDark,
        ),
      ),
      home: const AuthenticationScreen(),
    );
  }
}
