import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_user.freezed.dart';

/// The signed-in user, decoupled from the Firebase `User` type.
@freezed
abstract class AppUser with _$AppUser {
  const AppUser._();

  const factory AppUser({
    required String uid,
    required String email,
    String? displayName,
    String? photoUrl,
    DateTime? createdAt,
  }) = _AppUser;

  /// First name, falling back to the email local part.
  String get firstName {
    final name = displayName?.trim();
    if (name != null && name.isNotEmpty) return name.split(' ').first;
    return email.split('@').first;
  }

  /// Up to two initials for the avatar badge, e.g. "MD".
  String get initials {
    final name = displayName?.trim();
    if (name == null || name.isEmpty) {
      return email.isEmpty ? '?' : email[0].toUpperCase();
    }
    final parts = name.split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
    return parts.take(2).map((p) => p[0].toUpperCase()).join();
  }
}
