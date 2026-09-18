import 'package:flutter/material.dart';

class AppLogoBadge extends StatelessWidget {
  const AppLogoBadge({super.key, this.size = 48});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/icons/logo_badge.png',
      width: size,
      height: size,
      semanticLabel: 'AceCoach logo',
    );
  }
}
