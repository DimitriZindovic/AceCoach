import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_spacing.dart';
import '../../constants/app_themes.dart';

/// Field validators shared by the login and register forms.
abstract final class AuthValidators {
  static final RegExp _email = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]{2,}$');

  static String? email(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Enter your email address.';
    if (!_email.hasMatch(v)) return 'Enter a valid email address.';
    return null;
  }

  static String? password(String? value, {bool strict = false}) {
    final v = value ?? '';
    if (v.isEmpty) return 'Enter your password.';
    if (strict && v.length < 8) return 'Use at least 8 characters.';
    return null;
  }

  static String? name(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Enter your name.';
    if (v.length < 2) return 'Your name looks too short.';
    return null;
  }

  static String? confirm(String? value, String original) {
    if ((value ?? '').isEmpty) return 'Confirm your password.';
    if (value != original) return 'Passwords do not match.';
    return null;
  }
}

/// Label above a text field, as in the design.
class LabeledField extends StatelessWidget {
  const LabeledField({super.key, required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.fieldLabel),
        const SizedBox(height: 5),
        child,
      ],
    );
  }
}

/// Inline error shown above the form actions.
class AuthErrorBanner extends StatelessWidget {
  const AuthErrorBanner({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Semantics(
      liveRegion: true,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md + 2,
          vertical: AppSpacing.sm + 2,
        ),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.error.withValues(alpha: 0.25)
              : AppColors.errorContainer.withValues(alpha: 0.5),
          borderRadius: AppRadius.circular(AppRadius.md),
          border: Border.all(color: AppColors.errorContainer),
        ),
        child: Row(
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 18,
              color: isDark ? AppColors.errorContainer : AppColors.error,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                message,
                style: Theme.of(context).textTheme.caption.copyWith(
                  color: isDark ? AppColors.errorContainer : AppColors.error,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// "or continue with" divider.
class OrDivider extends StatelessWidget {
  const OrDivider({super.key, this.label = 'or continue with'});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w500,
              color: AppColors.textTertiary,
            ),
          ),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }
}

/// The four-colour Google "G" used on the sign-in button.
class GoogleGlyph extends StatelessWidget {
  const GoogleGlyph({super.key, this.size = 18});

  final double size;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: const _GooglePainter(),
    );
  }
}

class _GooglePainter extends CustomPainter {
  const _GooglePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final stroke = size.width * 0.22;
    final arcRect = rect.deflate(stroke / 2);
    Paint paint(Color color) => Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke;

    // Four arcs, starting on the right and going clockwise like the logo.
    canvas
      ..drawArc(arcRect, -0.35, 1.4, false, paint(AppColors.googleBlue))
      ..drawArc(arcRect, 1.05, 1.35, false, paint(AppColors.googleGreen))
      ..drawArc(arcRect, 2.4, 1.15, false, paint(AppColors.googleYellow))
      ..drawArc(arcRect, 3.55, 1.5, false, paint(AppColors.googleRed));

    // Horizontal bar of the "G".
    final center = rect.center;
    canvas.drawLine(
      Offset(center.dx, center.dy),
      Offset(rect.right - stroke / 2, center.dy),
      Paint()
        ..color = AppColors.googleBlue
        ..strokeWidth = stroke,
    );
  }

  @override
  bool shouldRepaint(covariant _GooglePainter oldDelegate) => false;
}
