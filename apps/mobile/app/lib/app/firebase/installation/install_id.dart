import 'package:firebase_app_installations/firebase_app_installations.dart';

Stream<String> firebaseInstallId() {
  // ignore: discarded_futures
  return Stream.fromFuture(FirebaseInstallations.instance.getId());
}
