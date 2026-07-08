import 'package:package_info_plus/package_info_plus.dart';
import 'package:version/version.dart';

extension PackageInfoX on PackageInfo {
  Version get parsedVersion {
    if (version.isEmpty) return Version(0, 0, 0);
    return Version.parse(version);
  }
}
