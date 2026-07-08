import 'dart:io';

bool isRunningOnCi() {
  return Platform.environment['CI'] == 'true';
}
