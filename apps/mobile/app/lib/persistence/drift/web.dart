import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';
import 'package:logger/logger.dart';
import 'package:sqlite3/wasm.dart';

import 'local_database.dart';

LocalDatabase createPersistentDb({required Logger logger}) {
  return LocalDatabase(_connectOnWeb(logger: logger));
}

Future<LocalDatabase> createInMemoryDb() async {
  final connect = await _connectInMemory();
  return LocalDatabase(connect);
}

Future<WasmDatabase> _connectInMemory() async {
  final sqlite3 = await WasmSqlite3.loadFromUrl(Uri.parse('/sqlite3.wasm'));
  sqlite3.registerVirtualFileSystem(InMemoryFileSystem(), makeDefault: true);
  return WasmDatabase.inMemory(sqlite3);
}

DatabaseConnection _connectOnWeb({required Logger logger}) {
  return DatabaseConnection.delayed(
    Future(() async {
      final result = await WasmDatabase.open(
        databaseName: 'lumy_db', // prefer to only use valid identifiers here
        sqlite3Uri: Uri.parse('sqlite3.wasm'),
        driftWorkerUri: Uri.parse('drift_worker.js'),
      );

      if (result.missingFeatures.isNotEmpty) {
        // Depending how central local persistence is to your app, you may want
        // to show a warning to the user if only unreliable implementations
        // are available.
        logger.i(
          'Using ${result.chosenImplementation} due to missing browser '
          'features: ${result.missingFeatures}',
        );
      }

      return result.resolvedExecutor;
    }),
  );
}
