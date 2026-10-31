import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Abre una conexión física segura y durable en disco con SQLite para producción.
///
/// Si se ejecuta dentro del entorno de pruebas de Flutter (`FLUTTER_TEST`),
/// se degrada automáticamente a una base de datos en memoria para no requerir
/// plugins nativos ni tocar el disco físico del desarrollador.
LazyDatabase openConnection() {
  return LazyDatabase(() async {
    if (Platform.environment.containsKey('FLUTTER_TEST')) {
      return NativeDatabase.memory();
    }

    final dir = await getApplicationSupportDirectory();
    final file = File(p.join(dir.path, 'ferrodoc.sqlite'));

    return NativeDatabase.createInBackground(
      file,
      setup: (raw) {
        raw.execute('PRAGMA journal_mode = WAL;');
        raw.execute('PRAGMA synchronous = FULL;');
        raw.execute('PRAGMA foreign_keys = ON;');
        raw.execute('PRAGMA busy_timeout = 5000;');
      },
    );
  });
}

/// Abre una conexión SQLite pura en memoria aislada para pruebas unitarias.
QueryExecutor openMemoryConnection() {
  return NativeDatabase.memory(
    setup: (raw) {
      raw.execute('PRAGMA foreign_keys = ON;');
    },
  );
}

