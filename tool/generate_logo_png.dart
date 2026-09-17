import 'dart:io';
import 'dart:ui' as ui;

import 'package:ace_coach/widgets/app_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('writes assets/icons/logo_badge.png at 1x, 2x and 3x', (
    tester,
  ) async {
    const key = ValueKey('logo');

    await tester.pumpWidget(
      const MaterialApp(
        home: Center(
          child: RepaintBoundary(key: key, child: AppLogoBadge()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final boundary =
        tester.renderObject(find.byKey(key)) as RenderRepaintBoundary;

    for (final ratio in [1.0, 2.0, 3.0]) {
      final image = await boundary.toImage(pixelRatio: ratio);
      final data = await image.toByteData(format: ui.ImageByteFormat.png);
      final dir = ratio == 1.0 ? '' : '${ratio}x/';
      final file = File('assets/icons/${dir}logo_badge.png');
      file.parent.createSync(recursive: true);
      file.writeAsBytesSync(data!.buffer.asUint8List());
      debugPrint('wrote ${file.path} (${image.width}x${image.height})');
    }
  });
}
