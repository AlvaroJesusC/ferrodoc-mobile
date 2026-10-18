import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ferrodoc_app/core/navigation/main_shell_scaffold.dart';
import 'package:ferrodoc_app/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: FerrodocApp()));
}

/// Widget raíz de la aplicación Ferrodoc.
class FerrodocApp extends StatelessWidget {
  const FerrodocApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ferrodoc - Ferretería AYM',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(Brightness.light),
      darkTheme: buildAppTheme(Brightness.dark),
      themeMode: ThemeMode.system,
      home: const MainShellScaffold(),
    );
  }
}
