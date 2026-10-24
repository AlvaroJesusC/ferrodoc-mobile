import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ferrodoc_app/core/navigation/main_shell_scaffold.dart';
import 'package:ferrodoc_app/theme/app_theme.dart';

import 'package:ferrodoc_app/theme/theme_mode_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: FerrodocApp()));
}

/// Widget raíz de la aplicación Ferrodoc con soporte para tema claro/oscuro y modo demo.
class FerrodocApp extends ConsumerWidget {
  const FerrodocApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'Ferrodoc - Ferretería AYM',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(Brightness.light),
      darkTheme: buildAppTheme(Brightness.dark),
      themeMode: themeMode,
      home: const MainShellScaffold(),
    );
  }
}
