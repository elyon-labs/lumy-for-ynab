import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

import 'local_database.dart';

LocalDatabase createPersistentDb({required Logger logger}) {
  return LocalDatabase(_openConnection(logger: logger));
}

Future<LocalDatabase> createInMemoryDb() async {
  return LocalDatabase(NativeDatabase.memory());
}

LazyDatabase _openConnection({required Logger logger}) {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    logger.i('Opening native database at ${file.path}');

    // Also work around limitations on old Android versions
    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }

    // Make sqlite3 pick a more suitable location for temporary files - the
    // one from the system may be inaccessible due to sand-boxing.
    final cacheBase = (await getTemporaryDirectory()).path;
    // We can't access /tmp on Android, which sqlite3 would try by default.
    // Explicitly tell it about the correct temporary directory.
    sqlite3.tempDirectory = cacheBase;

    return NativeDatabase.createInBackground(file).interceptWith(TimingInterceptor(logger: logger));
  });
}

class TimingInterceptor extends QueryInterceptor {
  TimingInterceptor({required this.logger});

  int request = 0;
  final Logger logger;

  @override
  Future<List<Map<String, Object?>>> runSelect(
    QueryExecutor executor,
    String statement,
    List<Object?> args,
  ) async {
    final sw = Stopwatch()..start();
    final rows = await super.runSelect(executor, statement, args);
    sw.stop();

    if (sw.elapsed > 500.milliseconds) {
      logger.w(
        'Slow query (${sw.elapsedMilliseconds}ms, ${rows.length} rows)! '
        '$statement args=$args',
      );
    }
    return rows;
  }
}
