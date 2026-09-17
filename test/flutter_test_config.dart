import 'dart:async';

import 'package:google_fonts/google_fonts.dart';

/// Runs before every test file: fonts come from the bundled assets only.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  GoogleFonts.config.allowRuntimeFetching = false;
  await testMain();
}
