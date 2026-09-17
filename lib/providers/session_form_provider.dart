import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/session_params.dart';

part 'session_form_provider.g.dart';

/// State of the session setup form. Kept alive so the user's choices survive
/// a tab switch until a session is generated.
@Riverpod(keepAlive: true)
class SessionForm extends _$SessionForm {
  @override
  SessionParams build() => const SessionParams();

  void setDuration(num minutes) {
    state = state.copyWith(
      durationMinutes: SessionParams.snapDuration(minutes),
    );
  }

  void setLevel(SkillLevel level) => state = state.copyWith(level: level);

  void toggleStroke(Stroke stroke) {
    final strokes = Set<Stroke>.of(state.strokes);
    if (!strokes.remove(stroke)) strokes.add(stroke);
    state = state.copyWith(strokes: strokes);
  }

  void setGoal(TacticalGoal goal) => state = state.copyWith(goal: goal);

  void setPlayers(PlayerCount players) =>
      state = state.copyWith(players: players);

  void setPreferIndoor(bool value) =>
      state = state.copyWith(preferIndoor: value);

  void reset() => state = const SessionParams();
}
