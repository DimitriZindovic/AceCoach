import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';

/// The racket-and-ball mark from the design, drawn with a [CustomPainter] so
/// it scales crisply at any size.
class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.size = 62,
    this.strokeColor = AppColors.surface,
    this.ballColor = AppColors.lime,
    this.seamColor = AppColors.primaryDark,
  });

  final double size;
  final Color strokeColor;
  final Color ballColor;
  final Color seamColor;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'AceCoach logo',
      child: CustomPaint(
        size: Size.square(size),
        painter: _LogoPainter(
          strokeColor: strokeColor,
          ballColor: ballColor,
          seamColor: seamColor,
        ),
      ),
    );
  }
}

/// The logo inside a soft rounded square, as on the login screen.
class AppLogoBadge extends StatelessWidget {
  const AppLogoBadge({super.key, this.size = 48});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
        borderRadius: AppRadius.circular(AppRadius.lg),
      ),
      alignment: Alignment.center,
      child: AppLogo(size: size * 0.54, strokeColor: AppColors.primaryDark),
    );
  }
}

class _LogoPainter extends CustomPainter {
  const _LogoPainter({
    required this.strokeColor,
    required this.ballColor,
    required this.seamColor,
  });

  final Color strokeColor;
  final Color ballColor;
  final Color seamColor;

  @override
  void paint(Canvas canvas, Size size) {
    // The design is drawn on a 64 × 64 grid.
    final scale = size.width / 64;
    canvas.scale(scale);

    final stroke = Paint()
      ..color = strokeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    // Racket head, rotated -28°.
    canvas
      ..save()
      ..translate(24, 22)
      ..rotate(-28 * math.pi / 180)
      ..drawOval(
        Rect.fromCenter(center: Offset.zero, width: 30, height: 36),
        stroke,
      )
      ..restore();

    // Handle and grip end.
    canvas
      ..drawLine(const Offset(14, 34), const Offset(8, 52), stroke)
      ..drawLine(const Offset(6, 56), const Offset(11, 50), stroke);

    // Ball with two seams.
    canvas.drawCircle(const Offset(47, 45), 10, Paint()..color = ballColor);
    final seam = Paint()
      ..color = seamColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    canvas
      ..drawPath(
        Path()
          ..moveTo(40, 39)
          ..quadraticBezierTo(47, 45, 40, 51),
        seam,
      )
      ..drawPath(
        Path()
          ..moveTo(54, 39)
          ..quadraticBezierTo(47, 45, 54, 51),
        seam,
      );
  }

  @override
  bool shouldRepaint(covariant _LogoPainter oldDelegate) =>
      oldDelegate.strokeColor != strokeColor ||
      oldDelegate.ballColor != ballColor ||
      oldDelegate.seamColor != seamColor;
}
