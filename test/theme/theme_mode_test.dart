import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ferrodoc_app/theme/app_theme.dart';
import 'package:ferrodoc_app/theme/theme_mode_provider.dart';
import 'package:ferrodoc_app/theme/widgets/theme_selector_card.dart';

void main() {
  group('ThemeMode & ThemeSelectorCard Tests', () {
    test('arranca por defecto en ThemeMode.system y permite cambiar', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(themeModeProvider), ThemeMode.system);

      container.read(themeModeProvider.notifier).setThemeMode(ThemeMode.dark);
      expect(container.read(themeModeProvider), ThemeMode.dark);

      container.read(themeModeProvider.notifier).setThemeMode(ThemeMode.light);
      expect(container.read(themeModeProvider), ThemeMode.light);

      container.read(themeModeProvider.notifier).toggleTheme();
      expect(container.read(themeModeProvider), ThemeMode.dark);
    });

    testWidgets('ThemeSelectorCard renderiza los tres modos y reacciona al toque', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            theme: buildAppTheme(Brightness.light),
            darkTheme: buildAppTheme(Brightness.dark),
            home: const Scaffold(
              body: ThemeSelectorCard(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Tema y Apariencia'), findsOneWidget);
      expect(find.text('Claro'), findsOneWidget);
      expect(find.text('Oscuro'), findsOneWidget);
      expect(find.text('Sistema'), findsOneWidget);

      // Tocar Modo Oscuro
      await tester.tap(find.text('Oscuro'));
      await tester.pumpAndSettle();

      expect(container.read(themeModeProvider), ThemeMode.dark);

      // Tocar Modo Claro
      await tester.tap(find.text('Claro'));
      await tester.pumpAndSettle();

      expect(container.read(themeModeProvider), ThemeMode.light);
    });
  });
}
