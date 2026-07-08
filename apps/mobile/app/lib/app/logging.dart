import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

import '../utils/flutter.dart';
import 'environment/environment.dart';

extension LoggerEnvironmentX on Environment {
  Logger get logger {
    final level = Level.values.byName(logLevel);

    return Logger(
      output: DataSinkOutput(),
      filter: ProductionFilter(),
      printer: PrettyPrinter(methodCount: 1),
      level: level,
    );
  }
}

class DataSinkOutput extends LogOutput {
  DataSinkOutput();

  @override
  Future<void> output(OutputEvent event) async {
    if (kDebugMode && !isFlutterTestMode()) {
      final message = event.lines.join('\n');
      debugPrint(message);
      log(message);
    }
  }
}
