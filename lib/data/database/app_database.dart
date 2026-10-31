import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:ferrodoc_app/data/database/connection/connection.dart';
import 'package:ferrodoc_app/data/database/tables/productos_table.dart';
import 'package:ferrodoc_app/data/database/tables/ventas_table.dart';
import 'package:ferrodoc_app/data/database/tables/documentos_table.dart';
import 'package:ferrodoc_app/data/database/tables/configuracion_table.dart';
import 'package:ferrodoc_app/data/database/tables/cierre_caja_table.dart';
import 'package:ferrodoc_app/data/database/daos/productos_dao.dart';
import 'package:ferrodoc_app/data/database/daos/ventas_dao.dart';
import 'package:ferrodoc_app/data/database/daos/documentos_dao.dart';
import 'package:ferrodoc_app/data/database/daos/configuracion_dao.dart';
import 'package:ferrodoc_app/data/database/daos/cierre_caja_dao.dart';

part 'app_database.g.dart';

/// Base de datos SQLite física y reactiva principal de ferrodoc_app.
///
/// Configurada conforme a `ferrodoc-production-roadmap` y `persistence-drift`.
@DriftDatabase(
  tables: [
    ProductosTable,
    VentasTable,
    LineasVentaTable,
    DocumentosTable,
    HojasDocumentoTable,
    ConfiguracionNegocioTable,
    CierresCajaTable,
  ],
  daos: [
    ProductosDao,
    VentasDao,
    DocumentosDao,
    ConfiguracionDao,
    CierreCajaDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? openConnection());

  /// Constructor para testing unitario y de widgets en memoria aislada.
  AppDatabase.memory([QueryExecutor? executor])
      : super(executor ?? openMemoryConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        beforeOpen: (details) async {
          // Activar pragmas de SQLite en cada conexión abierta
          await customStatement('PRAGMA foreign_keys = ON;');
          await customStatement('PRAGMA journal_mode = WAL;');

          // Seed inicial por defecto para Ferretería AYM
          if (details.wasCreated) {
            final configCount = await configuracionDao.countConfiguracion();
            if (configCount == 0) {
              await configuracionDao.saveConfiguracion(
                ConfiguracionNegocioTableCompanion.insert(
                  nombre: 'Ferretería AYM',
                  ruc: '10456789012',
                  direccion: 'Av. Principal 123, Lima',
                  telefono: '987654321',
                  mensajePie: '¡Gracias por su compra en Ferretería AYM!',
                  metodosPagoJson: jsonEncode(const [
                    'Efectivo',
                    'Yape',
                    'Plin',
                    'Tarjeta',
                    'Transferencia',
                  ]),
                ),
              );
            }
          }
        },
      );
}

