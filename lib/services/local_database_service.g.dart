// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_database_service.dart';

// ignore_for_file: type=lint
class $TrainingSessionsTable extends TrainingSessions
    with TableInfo<$TrainingSessionsTable, TrainingSessionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TrainingSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _summaryMeta = const VerificationMeta(
    'summary',
  );
  @override
  late final GeneratedColumn<String> summary = GeneratedColumn<String>(
    'summary',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationMinutesMeta = const VerificationMeta(
    'durationMinutes',
  );
  @override
  late final GeneratedColumn<int> durationMinutes = GeneratedColumn<int>(
    'duration_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<SkillLevel, String> level =
      GeneratedColumn<String>(
        'level',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<SkillLevel>($TrainingSessionsTable.$converterlevel);
  @override
  late final GeneratedColumnWithTypeConverter<TacticalGoal, String> goal =
      GeneratedColumn<String>(
        'goal',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<TacticalGoal>($TrainingSessionsTable.$convertergoal);
  @override
  late final GeneratedColumnWithTypeConverter<PlayerCount, String> players =
      GeneratedColumn<String>(
        'players',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<PlayerCount>($TrainingSessionsTable.$converterplayers);
  static const VerificationMeta _strokesMeta = const VerificationMeta(
    'strokes',
  );
  @override
  late final GeneratedColumn<String> strokes = GeneratedColumn<String>(
    'strokes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _preferIndoorMeta = const VerificationMeta(
    'preferIndoor',
  );
  @override
  late final GeneratedColumn<bool> preferIndoor = GeneratedColumn<bool>(
    'prefer_indoor',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("prefer_indoor" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _weatherJsonMeta = const VerificationMeta(
    'weatherJson',
  );
  @override
  late final GeneratedColumn<String> weatherJson = GeneratedColumn<String>(
    'weather_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _weatherUsedMeta = const VerificationMeta(
    'weatherUsed',
  );
  @override
  late final GeneratedColumn<bool> weatherUsed = GeneratedColumn<bool>(
    'weather_used',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("weather_used" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _weatherAdviceMeta = const VerificationMeta(
    'weatherAdvice',
  );
  @override
  late final GeneratedColumn<String> weatherAdvice = GeneratedColumn<String>(
    'weather_advice',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    title,
    summary,
    createdAt,
    durationMinutes,
    level,
    goal,
    players,
    strokes,
    preferIndoor,
    weatherJson,
    weatherUsed,
    weatherAdvice,
    completedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'training_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<TrainingSessionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('summary')) {
      context.handle(
        _summaryMeta,
        summary.isAcceptableOrUnknown(data['summary']!, _summaryMeta),
      );
    } else if (isInserting) {
      context.missing(_summaryMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('duration_minutes')) {
      context.handle(
        _durationMinutesMeta,
        durationMinutes.isAcceptableOrUnknown(
          data['duration_minutes']!,
          _durationMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_durationMinutesMeta);
    }
    if (data.containsKey('strokes')) {
      context.handle(
        _strokesMeta,
        strokes.isAcceptableOrUnknown(data['strokes']!, _strokesMeta),
      );
    } else if (isInserting) {
      context.missing(_strokesMeta);
    }
    if (data.containsKey('prefer_indoor')) {
      context.handle(
        _preferIndoorMeta,
        preferIndoor.isAcceptableOrUnknown(
          data['prefer_indoor']!,
          _preferIndoorMeta,
        ),
      );
    }
    if (data.containsKey('weather_json')) {
      context.handle(
        _weatherJsonMeta,
        weatherJson.isAcceptableOrUnknown(
          data['weather_json']!,
          _weatherJsonMeta,
        ),
      );
    }
    if (data.containsKey('weather_used')) {
      context.handle(
        _weatherUsedMeta,
        weatherUsed.isAcceptableOrUnknown(
          data['weather_used']!,
          _weatherUsedMeta,
        ),
      );
    }
    if (data.containsKey('weather_advice')) {
      context.handle(
        _weatherAdviceMeta,
        weatherAdvice.isAcceptableOrUnknown(
          data['weather_advice']!,
          _weatherAdviceMeta,
        ),
      );
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TrainingSessionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TrainingSessionRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      summary: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}summary'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      durationMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_minutes'],
      )!,
      level: $TrainingSessionsTable.$converterlevel.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}level'],
        )!,
      ),
      goal: $TrainingSessionsTable.$convertergoal.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}goal'],
        )!,
      ),
      players: $TrainingSessionsTable.$converterplayers.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}players'],
        )!,
      ),
      strokes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}strokes'],
      )!,
      preferIndoor: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}prefer_indoor'],
      )!,
      weatherJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}weather_json'],
      ),
      weatherUsed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}weather_used'],
      )!,
      weatherAdvice: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}weather_advice'],
      ),
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
    );
  }

  @override
  $TrainingSessionsTable createAlias(String alias) {
    return $TrainingSessionsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SkillLevel, String, String> $converterlevel =
      const EnumNameConverter<SkillLevel>(SkillLevel.values);
  static JsonTypeConverter2<TacticalGoal, String, String> $convertergoal =
      const EnumNameConverter<TacticalGoal>(TacticalGoal.values);
  static JsonTypeConverter2<PlayerCount, String, String> $converterplayers =
      const EnumNameConverter<PlayerCount>(PlayerCount.values);
}

class TrainingSessionRow extends DataClass
    implements Insertable<TrainingSessionRow> {
  final String id;
  final String userId;
  final String title;
  final String summary;
  final DateTime createdAt;
  final int durationMinutes;
  final SkillLevel level;
  final TacticalGoal goal;
  final PlayerCount players;
  final String strokes;
  final bool preferIndoor;
  final String? weatherJson;
  final bool weatherUsed;
  final String? weatherAdvice;
  final DateTime? completedAt;
  const TrainingSessionRow({
    required this.id,
    required this.userId,
    required this.title,
    required this.summary,
    required this.createdAt,
    required this.durationMinutes,
    required this.level,
    required this.goal,
    required this.players,
    required this.strokes,
    required this.preferIndoor,
    this.weatherJson,
    required this.weatherUsed,
    this.weatherAdvice,
    this.completedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['title'] = Variable<String>(title);
    map['summary'] = Variable<String>(summary);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['duration_minutes'] = Variable<int>(durationMinutes);
    {
      map['level'] = Variable<String>(
        $TrainingSessionsTable.$converterlevel.toSql(level),
      );
    }
    {
      map['goal'] = Variable<String>(
        $TrainingSessionsTable.$convertergoal.toSql(goal),
      );
    }
    {
      map['players'] = Variable<String>(
        $TrainingSessionsTable.$converterplayers.toSql(players),
      );
    }
    map['strokes'] = Variable<String>(strokes);
    map['prefer_indoor'] = Variable<bool>(preferIndoor);
    if (!nullToAbsent || weatherJson != null) {
      map['weather_json'] = Variable<String>(weatherJson);
    }
    map['weather_used'] = Variable<bool>(weatherUsed);
    if (!nullToAbsent || weatherAdvice != null) {
      map['weather_advice'] = Variable<String>(weatherAdvice);
    }
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    return map;
  }

  TrainingSessionsCompanion toCompanion(bool nullToAbsent) {
    return TrainingSessionsCompanion(
      id: Value(id),
      userId: Value(userId),
      title: Value(title),
      summary: Value(summary),
      createdAt: Value(createdAt),
      durationMinutes: Value(durationMinutes),
      level: Value(level),
      goal: Value(goal),
      players: Value(players),
      strokes: Value(strokes),
      preferIndoor: Value(preferIndoor),
      weatherJson: weatherJson == null && nullToAbsent
          ? const Value.absent()
          : Value(weatherJson),
      weatherUsed: Value(weatherUsed),
      weatherAdvice: weatherAdvice == null && nullToAbsent
          ? const Value.absent()
          : Value(weatherAdvice),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
    );
  }

  factory TrainingSessionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TrainingSessionRow(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      title: serializer.fromJson<String>(json['title']),
      summary: serializer.fromJson<String>(json['summary']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      durationMinutes: serializer.fromJson<int>(json['durationMinutes']),
      level: $TrainingSessionsTable.$converterlevel.fromJson(
        serializer.fromJson<String>(json['level']),
      ),
      goal: $TrainingSessionsTable.$convertergoal.fromJson(
        serializer.fromJson<String>(json['goal']),
      ),
      players: $TrainingSessionsTable.$converterplayers.fromJson(
        serializer.fromJson<String>(json['players']),
      ),
      strokes: serializer.fromJson<String>(json['strokes']),
      preferIndoor: serializer.fromJson<bool>(json['preferIndoor']),
      weatherJson: serializer.fromJson<String?>(json['weatherJson']),
      weatherUsed: serializer.fromJson<bool>(json['weatherUsed']),
      weatherAdvice: serializer.fromJson<String?>(json['weatherAdvice']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'title': serializer.toJson<String>(title),
      'summary': serializer.toJson<String>(summary),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'durationMinutes': serializer.toJson<int>(durationMinutes),
      'level': serializer.toJson<String>(
        $TrainingSessionsTable.$converterlevel.toJson(level),
      ),
      'goal': serializer.toJson<String>(
        $TrainingSessionsTable.$convertergoal.toJson(goal),
      ),
      'players': serializer.toJson<String>(
        $TrainingSessionsTable.$converterplayers.toJson(players),
      ),
      'strokes': serializer.toJson<String>(strokes),
      'preferIndoor': serializer.toJson<bool>(preferIndoor),
      'weatherJson': serializer.toJson<String?>(weatherJson),
      'weatherUsed': serializer.toJson<bool>(weatherUsed),
      'weatherAdvice': serializer.toJson<String?>(weatherAdvice),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
    };
  }

  TrainingSessionRow copyWith({
    String? id,
    String? userId,
    String? title,
    String? summary,
    DateTime? createdAt,
    int? durationMinutes,
    SkillLevel? level,
    TacticalGoal? goal,
    PlayerCount? players,
    String? strokes,
    bool? preferIndoor,
    Value<String?> weatherJson = const Value.absent(),
    bool? weatherUsed,
    Value<String?> weatherAdvice = const Value.absent(),
    Value<DateTime?> completedAt = const Value.absent(),
  }) => TrainingSessionRow(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    title: title ?? this.title,
    summary: summary ?? this.summary,
    createdAt: createdAt ?? this.createdAt,
    durationMinutes: durationMinutes ?? this.durationMinutes,
    level: level ?? this.level,
    goal: goal ?? this.goal,
    players: players ?? this.players,
    strokes: strokes ?? this.strokes,
    preferIndoor: preferIndoor ?? this.preferIndoor,
    weatherJson: weatherJson.present ? weatherJson.value : this.weatherJson,
    weatherUsed: weatherUsed ?? this.weatherUsed,
    weatherAdvice: weatherAdvice.present
        ? weatherAdvice.value
        : this.weatherAdvice,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
  );
  TrainingSessionRow copyWithCompanion(TrainingSessionsCompanion data) {
    return TrainingSessionRow(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      title: data.title.present ? data.title.value : this.title,
      summary: data.summary.present ? data.summary.value : this.summary,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      durationMinutes: data.durationMinutes.present
          ? data.durationMinutes.value
          : this.durationMinutes,
      level: data.level.present ? data.level.value : this.level,
      goal: data.goal.present ? data.goal.value : this.goal,
      players: data.players.present ? data.players.value : this.players,
      strokes: data.strokes.present ? data.strokes.value : this.strokes,
      preferIndoor: data.preferIndoor.present
          ? data.preferIndoor.value
          : this.preferIndoor,
      weatherJson: data.weatherJson.present
          ? data.weatherJson.value
          : this.weatherJson,
      weatherUsed: data.weatherUsed.present
          ? data.weatherUsed.value
          : this.weatherUsed,
      weatherAdvice: data.weatherAdvice.present
          ? data.weatherAdvice.value
          : this.weatherAdvice,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TrainingSessionRow(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('title: $title, ')
          ..write('summary: $summary, ')
          ..write('createdAt: $createdAt, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('level: $level, ')
          ..write('goal: $goal, ')
          ..write('players: $players, ')
          ..write('strokes: $strokes, ')
          ..write('preferIndoor: $preferIndoor, ')
          ..write('weatherJson: $weatherJson, ')
          ..write('weatherUsed: $weatherUsed, ')
          ..write('weatherAdvice: $weatherAdvice, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    title,
    summary,
    createdAt,
    durationMinutes,
    level,
    goal,
    players,
    strokes,
    preferIndoor,
    weatherJson,
    weatherUsed,
    weatherAdvice,
    completedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TrainingSessionRow &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.title == this.title &&
          other.summary == this.summary &&
          other.createdAt == this.createdAt &&
          other.durationMinutes == this.durationMinutes &&
          other.level == this.level &&
          other.goal == this.goal &&
          other.players == this.players &&
          other.strokes == this.strokes &&
          other.preferIndoor == this.preferIndoor &&
          other.weatherJson == this.weatherJson &&
          other.weatherUsed == this.weatherUsed &&
          other.weatherAdvice == this.weatherAdvice &&
          other.completedAt == this.completedAt);
}

class TrainingSessionsCompanion extends UpdateCompanion<TrainingSessionRow> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> title;
  final Value<String> summary;
  final Value<DateTime> createdAt;
  final Value<int> durationMinutes;
  final Value<SkillLevel> level;
  final Value<TacticalGoal> goal;
  final Value<PlayerCount> players;
  final Value<String> strokes;
  final Value<bool> preferIndoor;
  final Value<String?> weatherJson;
  final Value<bool> weatherUsed;
  final Value<String?> weatherAdvice;
  final Value<DateTime?> completedAt;
  final Value<int> rowid;
  const TrainingSessionsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.title = const Value.absent(),
    this.summary = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.durationMinutes = const Value.absent(),
    this.level = const Value.absent(),
    this.goal = const Value.absent(),
    this.players = const Value.absent(),
    this.strokes = const Value.absent(),
    this.preferIndoor = const Value.absent(),
    this.weatherJson = const Value.absent(),
    this.weatherUsed = const Value.absent(),
    this.weatherAdvice = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TrainingSessionsCompanion.insert({
    required String id,
    required String userId,
    required String title,
    required String summary,
    required DateTime createdAt,
    required int durationMinutes,
    required SkillLevel level,
    required TacticalGoal goal,
    required PlayerCount players,
    required String strokes,
    this.preferIndoor = const Value.absent(),
    this.weatherJson = const Value.absent(),
    this.weatherUsed = const Value.absent(),
    this.weatherAdvice = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       title = Value(title),
       summary = Value(summary),
       createdAt = Value(createdAt),
       durationMinutes = Value(durationMinutes),
       level = Value(level),
       goal = Value(goal),
       players = Value(players),
       strokes = Value(strokes);
  static Insertable<TrainingSessionRow> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? title,
    Expression<String>? summary,
    Expression<DateTime>? createdAt,
    Expression<int>? durationMinutes,
    Expression<String>? level,
    Expression<String>? goal,
    Expression<String>? players,
    Expression<String>? strokes,
    Expression<bool>? preferIndoor,
    Expression<String>? weatherJson,
    Expression<bool>? weatherUsed,
    Expression<String>? weatherAdvice,
    Expression<DateTime>? completedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (title != null) 'title': title,
      if (summary != null) 'summary': summary,
      if (createdAt != null) 'created_at': createdAt,
      if (durationMinutes != null) 'duration_minutes': durationMinutes,
      if (level != null) 'level': level,
      if (goal != null) 'goal': goal,
      if (players != null) 'players': players,
      if (strokes != null) 'strokes': strokes,
      if (preferIndoor != null) 'prefer_indoor': preferIndoor,
      if (weatherJson != null) 'weather_json': weatherJson,
      if (weatherUsed != null) 'weather_used': weatherUsed,
      if (weatherAdvice != null) 'weather_advice': weatherAdvice,
      if (completedAt != null) 'completed_at': completedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TrainingSessionsCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? title,
    Value<String>? summary,
    Value<DateTime>? createdAt,
    Value<int>? durationMinutes,
    Value<SkillLevel>? level,
    Value<TacticalGoal>? goal,
    Value<PlayerCount>? players,
    Value<String>? strokes,
    Value<bool>? preferIndoor,
    Value<String?>? weatherJson,
    Value<bool>? weatherUsed,
    Value<String?>? weatherAdvice,
    Value<DateTime?>? completedAt,
    Value<int>? rowid,
  }) {
    return TrainingSessionsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      summary: summary ?? this.summary,
      createdAt: createdAt ?? this.createdAt,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      level: level ?? this.level,
      goal: goal ?? this.goal,
      players: players ?? this.players,
      strokes: strokes ?? this.strokes,
      preferIndoor: preferIndoor ?? this.preferIndoor,
      weatherJson: weatherJson ?? this.weatherJson,
      weatherUsed: weatherUsed ?? this.weatherUsed,
      weatherAdvice: weatherAdvice ?? this.weatherAdvice,
      completedAt: completedAt ?? this.completedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (summary.present) {
      map['summary'] = Variable<String>(summary.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (durationMinutes.present) {
      map['duration_minutes'] = Variable<int>(durationMinutes.value);
    }
    if (level.present) {
      map['level'] = Variable<String>(
        $TrainingSessionsTable.$converterlevel.toSql(level.value),
      );
    }
    if (goal.present) {
      map['goal'] = Variable<String>(
        $TrainingSessionsTable.$convertergoal.toSql(goal.value),
      );
    }
    if (players.present) {
      map['players'] = Variable<String>(
        $TrainingSessionsTable.$converterplayers.toSql(players.value),
      );
    }
    if (strokes.present) {
      map['strokes'] = Variable<String>(strokes.value);
    }
    if (preferIndoor.present) {
      map['prefer_indoor'] = Variable<bool>(preferIndoor.value);
    }
    if (weatherJson.present) {
      map['weather_json'] = Variable<String>(weatherJson.value);
    }
    if (weatherUsed.present) {
      map['weather_used'] = Variable<bool>(weatherUsed.value);
    }
    if (weatherAdvice.present) {
      map['weather_advice'] = Variable<String>(weatherAdvice.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TrainingSessionsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('title: $title, ')
          ..write('summary: $summary, ')
          ..write('createdAt: $createdAt, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('level: $level, ')
          ..write('goal: $goal, ')
          ..write('players: $players, ')
          ..write('strokes: $strokes, ')
          ..write('preferIndoor: $preferIndoor, ')
          ..write('weatherJson: $weatherJson, ')
          ..write('weatherUsed: $weatherUsed, ')
          ..write('weatherAdvice: $weatherAdvice, ')
          ..write('completedAt: $completedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExercisesTable extends Exercises
    with TableInfo<$ExercisesTable, ExerciseRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExercisesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES training_sessions (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _estimatedMinutesMeta = const VerificationMeta(
    'estimatedMinutes',
  );
  @override
  late final GeneratedColumn<int> estimatedMinutes = GeneratedColumn<int>(
    'estimated_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _technicalTipMeta = const VerificationMeta(
    'technicalTip',
  );
  @override
  late final GeneratedColumn<String> technicalTip = GeneratedColumn<String>(
    'technical_tip',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<ExercisePhase, String> phase =
      GeneratedColumn<String>(
        'phase',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<ExercisePhase>($ExercisesTable.$converterphase);
  static const VerificationMeta _indoorFriendlyMeta = const VerificationMeta(
    'indoorFriendly',
  );
  @override
  late final GeneratedColumn<bool> indoorFriendly = GeneratedColumn<bool>(
    'indoor_friendly',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("indoor_friendly" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    sessionId,
    position,
    title,
    description,
    estimatedMinutes,
    technicalTip,
    phase,
    indoorFriendly,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exercises';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExerciseRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('estimated_minutes')) {
      context.handle(
        _estimatedMinutesMeta,
        estimatedMinutes.isAcceptableOrUnknown(
          data['estimated_minutes']!,
          _estimatedMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_estimatedMinutesMeta);
    }
    if (data.containsKey('technical_tip')) {
      context.handle(
        _technicalTipMeta,
        technicalTip.isAcceptableOrUnknown(
          data['technical_tip']!,
          _technicalTipMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_technicalTipMeta);
    }
    if (data.containsKey('indoor_friendly')) {
      context.handle(
        _indoorFriendlyMeta,
        indoorFriendly.isAcceptableOrUnknown(
          data['indoor_friendly']!,
          _indoorFriendlyMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {sessionId, position};
  @override
  ExerciseRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExerciseRow(
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      estimatedMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}estimated_minutes'],
      )!,
      technicalTip: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}technical_tip'],
      )!,
      phase: $ExercisesTable.$converterphase.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}phase'],
        )!,
      ),
      indoorFriendly: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}indoor_friendly'],
      )!,
    );
  }

  @override
  $ExercisesTable createAlias(String alias) {
    return $ExercisesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ExercisePhase, String, String> $converterphase =
      const EnumNameConverter<ExercisePhase>(ExercisePhase.values);
}

class ExerciseRow extends DataClass implements Insertable<ExerciseRow> {
  final String sessionId;
  final int position;
  final String title;
  final String description;
  final int estimatedMinutes;
  final String technicalTip;
  final ExercisePhase phase;
  final bool indoorFriendly;
  const ExerciseRow({
    required this.sessionId,
    required this.position,
    required this.title,
    required this.description,
    required this.estimatedMinutes,
    required this.technicalTip,
    required this.phase,
    required this.indoorFriendly,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['session_id'] = Variable<String>(sessionId);
    map['position'] = Variable<int>(position);
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    map['estimated_minutes'] = Variable<int>(estimatedMinutes);
    map['technical_tip'] = Variable<String>(technicalTip);
    {
      map['phase'] = Variable<String>(
        $ExercisesTable.$converterphase.toSql(phase),
      );
    }
    map['indoor_friendly'] = Variable<bool>(indoorFriendly);
    return map;
  }

  ExercisesCompanion toCompanion(bool nullToAbsent) {
    return ExercisesCompanion(
      sessionId: Value(sessionId),
      position: Value(position),
      title: Value(title),
      description: Value(description),
      estimatedMinutes: Value(estimatedMinutes),
      technicalTip: Value(technicalTip),
      phase: Value(phase),
      indoorFriendly: Value(indoorFriendly),
    );
  }

  factory ExerciseRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExerciseRow(
      sessionId: serializer.fromJson<String>(json['sessionId']),
      position: serializer.fromJson<int>(json['position']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      estimatedMinutes: serializer.fromJson<int>(json['estimatedMinutes']),
      technicalTip: serializer.fromJson<String>(json['technicalTip']),
      phase: $ExercisesTable.$converterphase.fromJson(
        serializer.fromJson<String>(json['phase']),
      ),
      indoorFriendly: serializer.fromJson<bool>(json['indoorFriendly']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'sessionId': serializer.toJson<String>(sessionId),
      'position': serializer.toJson<int>(position),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'estimatedMinutes': serializer.toJson<int>(estimatedMinutes),
      'technicalTip': serializer.toJson<String>(technicalTip),
      'phase': serializer.toJson<String>(
        $ExercisesTable.$converterphase.toJson(phase),
      ),
      'indoorFriendly': serializer.toJson<bool>(indoorFriendly),
    };
  }

  ExerciseRow copyWith({
    String? sessionId,
    int? position,
    String? title,
    String? description,
    int? estimatedMinutes,
    String? technicalTip,
    ExercisePhase? phase,
    bool? indoorFriendly,
  }) => ExerciseRow(
    sessionId: sessionId ?? this.sessionId,
    position: position ?? this.position,
    title: title ?? this.title,
    description: description ?? this.description,
    estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
    technicalTip: technicalTip ?? this.technicalTip,
    phase: phase ?? this.phase,
    indoorFriendly: indoorFriendly ?? this.indoorFriendly,
  );
  ExerciseRow copyWithCompanion(ExercisesCompanion data) {
    return ExerciseRow(
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      position: data.position.present ? data.position.value : this.position,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      estimatedMinutes: data.estimatedMinutes.present
          ? data.estimatedMinutes.value
          : this.estimatedMinutes,
      technicalTip: data.technicalTip.present
          ? data.technicalTip.value
          : this.technicalTip,
      phase: data.phase.present ? data.phase.value : this.phase,
      indoorFriendly: data.indoorFriendly.present
          ? data.indoorFriendly.value
          : this.indoorFriendly,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExerciseRow(')
          ..write('sessionId: $sessionId, ')
          ..write('position: $position, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('estimatedMinutes: $estimatedMinutes, ')
          ..write('technicalTip: $technicalTip, ')
          ..write('phase: $phase, ')
          ..write('indoorFriendly: $indoorFriendly')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    sessionId,
    position,
    title,
    description,
    estimatedMinutes,
    technicalTip,
    phase,
    indoorFriendly,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExerciseRow &&
          other.sessionId == this.sessionId &&
          other.position == this.position &&
          other.title == this.title &&
          other.description == this.description &&
          other.estimatedMinutes == this.estimatedMinutes &&
          other.technicalTip == this.technicalTip &&
          other.phase == this.phase &&
          other.indoorFriendly == this.indoorFriendly);
}

class ExercisesCompanion extends UpdateCompanion<ExerciseRow> {
  final Value<String> sessionId;
  final Value<int> position;
  final Value<String> title;
  final Value<String> description;
  final Value<int> estimatedMinutes;
  final Value<String> technicalTip;
  final Value<ExercisePhase> phase;
  final Value<bool> indoorFriendly;
  final Value<int> rowid;
  const ExercisesCompanion({
    this.sessionId = const Value.absent(),
    this.position = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.estimatedMinutes = const Value.absent(),
    this.technicalTip = const Value.absent(),
    this.phase = const Value.absent(),
    this.indoorFriendly = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExercisesCompanion.insert({
    required String sessionId,
    required int position,
    required String title,
    required String description,
    required int estimatedMinutes,
    required String technicalTip,
    required ExercisePhase phase,
    this.indoorFriendly = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : sessionId = Value(sessionId),
       position = Value(position),
       title = Value(title),
       description = Value(description),
       estimatedMinutes = Value(estimatedMinutes),
       technicalTip = Value(technicalTip),
       phase = Value(phase);
  static Insertable<ExerciseRow> custom({
    Expression<String>? sessionId,
    Expression<int>? position,
    Expression<String>? title,
    Expression<String>? description,
    Expression<int>? estimatedMinutes,
    Expression<String>? technicalTip,
    Expression<String>? phase,
    Expression<bool>? indoorFriendly,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (sessionId != null) 'session_id': sessionId,
      if (position != null) 'position': position,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (estimatedMinutes != null) 'estimated_minutes': estimatedMinutes,
      if (technicalTip != null) 'technical_tip': technicalTip,
      if (phase != null) 'phase': phase,
      if (indoorFriendly != null) 'indoor_friendly': indoorFriendly,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExercisesCompanion copyWith({
    Value<String>? sessionId,
    Value<int>? position,
    Value<String>? title,
    Value<String>? description,
    Value<int>? estimatedMinutes,
    Value<String>? technicalTip,
    Value<ExercisePhase>? phase,
    Value<bool>? indoorFriendly,
    Value<int>? rowid,
  }) {
    return ExercisesCompanion(
      sessionId: sessionId ?? this.sessionId,
      position: position ?? this.position,
      title: title ?? this.title,
      description: description ?? this.description,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      technicalTip: technicalTip ?? this.technicalTip,
      phase: phase ?? this.phase,
      indoorFriendly: indoorFriendly ?? this.indoorFriendly,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (estimatedMinutes.present) {
      map['estimated_minutes'] = Variable<int>(estimatedMinutes.value);
    }
    if (technicalTip.present) {
      map['technical_tip'] = Variable<String>(technicalTip.value);
    }
    if (phase.present) {
      map['phase'] = Variable<String>(
        $ExercisesTable.$converterphase.toSql(phase.value),
      );
    }
    if (indoorFriendly.present) {
      map['indoor_friendly'] = Variable<bool>(indoorFriendly.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExercisesCompanion(')
          ..write('sessionId: $sessionId, ')
          ..write('position: $position, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('estimatedMinutes: $estimatedMinutes, ')
          ..write('technicalTip: $technicalTip, ')
          ..write('phase: $phase, ')
          ..write('indoorFriendly: $indoorFriendly, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSettingRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSettingRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppSettingRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSettingRow(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSettingRow extends DataClass implements Insertable<AppSettingRow> {
  final String key;
  final String value;
  const AppSettingRow({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(key: Value(key), value: Value(value));
  }

  factory AppSettingRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSettingRow(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  AppSettingRow copyWith({String? key, String? value}) =>
      AppSettingRow(key: key ?? this.key, value: value ?? this.value);
  AppSettingRow copyWithCompanion(AppSettingsCompanion data) {
    return AppSettingRow(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingRow(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSettingRow &&
          other.key == this.key &&
          other.value == this.value);
}

class AppSettingsCompanion extends UpdateCompanion<AppSettingRow> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const AppSettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<AppSettingRow> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return AppSettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$LocalDatabaseService extends GeneratedDatabase {
  _$LocalDatabaseService(QueryExecutor e) : super(e);
  $LocalDatabaseServiceManager get managers =>
      $LocalDatabaseServiceManager(this);
  late final $TrainingSessionsTable trainingSessions = $TrainingSessionsTable(
    this,
  );
  late final $ExercisesTable exercises = $ExercisesTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    trainingSessions,
    exercises,
    appSettings,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'training_sessions',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('exercises', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$TrainingSessionsTableCreateCompanionBuilder =
    TrainingSessionsCompanion Function({
      required String id,
      required String userId,
      required String title,
      required String summary,
      required DateTime createdAt,
      required int durationMinutes,
      required SkillLevel level,
      required TacticalGoal goal,
      required PlayerCount players,
      required String strokes,
      Value<bool> preferIndoor,
      Value<String?> weatherJson,
      Value<bool> weatherUsed,
      Value<String?> weatherAdvice,
      Value<DateTime?> completedAt,
      Value<int> rowid,
    });
typedef $$TrainingSessionsTableUpdateCompanionBuilder =
    TrainingSessionsCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> title,
      Value<String> summary,
      Value<DateTime> createdAt,
      Value<int> durationMinutes,
      Value<SkillLevel> level,
      Value<TacticalGoal> goal,
      Value<PlayerCount> players,
      Value<String> strokes,
      Value<bool> preferIndoor,
      Value<String?> weatherJson,
      Value<bool> weatherUsed,
      Value<String?> weatherAdvice,
      Value<DateTime?> completedAt,
      Value<int> rowid,
    });

final class $$TrainingSessionsTableReferences
    extends
        BaseReferences<
          _$LocalDatabaseService,
          $TrainingSessionsTable,
          TrainingSessionRow
        > {
  $$TrainingSessionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$ExercisesTable, List<ExerciseRow>>
  _exercisesRefsTable(_$LocalDatabaseService db) =>
      MultiTypedResultKey.fromTable(
        db.exercises,
        aliasName: 'training_sessions__id__exercises__session_id',
      );

  $$ExercisesTableProcessedTableManager get exercisesRefs {
    final manager = $$ExercisesTableTableManager(
      $_db,
      $_db.exercises,
    ).filter((f) => f.sessionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_exercisesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TrainingSessionsTableFilterComposer
    extends Composer<_$LocalDatabaseService, $TrainingSessionsTable> {
  $$TrainingSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SkillLevel, SkillLevel, String> get level =>
      $composableBuilder(
        column: $table.level,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<TacticalGoal, TacticalGoal, String> get goal =>
      $composableBuilder(
        column: $table.goal,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<PlayerCount, PlayerCount, String>
  get players => $composableBuilder(
    column: $table.players,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get strokes => $composableBuilder(
    column: $table.strokes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get preferIndoor => $composableBuilder(
    column: $table.preferIndoor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get weatherJson => $composableBuilder(
    column: $table.weatherJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get weatherUsed => $composableBuilder(
    column: $table.weatherUsed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get weatherAdvice => $composableBuilder(
    column: $table.weatherAdvice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> exercisesRefs(
    Expression<bool> Function($$ExercisesTableFilterComposer f) f,
  ) {
    final $$ExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableFilterComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TrainingSessionsTableOrderingComposer
    extends Composer<_$LocalDatabaseService, $TrainingSessionsTable> {
  $$TrainingSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get goal => $composableBuilder(
    column: $table.goal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get players => $composableBuilder(
    column: $table.players,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get strokes => $composableBuilder(
    column: $table.strokes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get preferIndoor => $composableBuilder(
    column: $table.preferIndoor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get weatherJson => $composableBuilder(
    column: $table.weatherJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get weatherUsed => $composableBuilder(
    column: $table.weatherUsed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get weatherAdvice => $composableBuilder(
    column: $table.weatherAdvice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TrainingSessionsTableAnnotationComposer
    extends Composer<_$LocalDatabaseService, $TrainingSessionsTable> {
  $$TrainingSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get summary =>
      $composableBuilder(column: $table.summary, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<SkillLevel, String> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TacticalGoal, String> get goal =>
      $composableBuilder(column: $table.goal, builder: (column) => column);

  GeneratedColumnWithTypeConverter<PlayerCount, String> get players =>
      $composableBuilder(column: $table.players, builder: (column) => column);

  GeneratedColumn<String> get strokes =>
      $composableBuilder(column: $table.strokes, builder: (column) => column);

  GeneratedColumn<bool> get preferIndoor => $composableBuilder(
    column: $table.preferIndoor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get weatherJson => $composableBuilder(
    column: $table.weatherJson,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get weatherUsed => $composableBuilder(
    column: $table.weatherUsed,
    builder: (column) => column,
  );

  GeneratedColumn<String> get weatherAdvice => $composableBuilder(
    column: $table.weatherAdvice,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  Expression<T> exercisesRefs<T extends Object>(
    Expression<T> Function($$ExercisesTableAnnotationComposer a) f,
  ) {
    final $$ExercisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableAnnotationComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TrainingSessionsTableTableManager
    extends
        RootTableManager<
          _$LocalDatabaseService,
          $TrainingSessionsTable,
          TrainingSessionRow,
          $$TrainingSessionsTableFilterComposer,
          $$TrainingSessionsTableOrderingComposer,
          $$TrainingSessionsTableAnnotationComposer,
          $$TrainingSessionsTableCreateCompanionBuilder,
          $$TrainingSessionsTableUpdateCompanionBuilder,
          (TrainingSessionRow, $$TrainingSessionsTableReferences),
          TrainingSessionRow,
          PrefetchHooks Function({bool exercisesRefs})
        > {
  $$TrainingSessionsTableTableManager(
    _$LocalDatabaseService db,
    $TrainingSessionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TrainingSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TrainingSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TrainingSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> summary = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> durationMinutes = const Value.absent(),
                Value<SkillLevel> level = const Value.absent(),
                Value<TacticalGoal> goal = const Value.absent(),
                Value<PlayerCount> players = const Value.absent(),
                Value<String> strokes = const Value.absent(),
                Value<bool> preferIndoor = const Value.absent(),
                Value<String?> weatherJson = const Value.absent(),
                Value<bool> weatherUsed = const Value.absent(),
                Value<String?> weatherAdvice = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TrainingSessionsCompanion(
                id: id,
                userId: userId,
                title: title,
                summary: summary,
                createdAt: createdAt,
                durationMinutes: durationMinutes,
                level: level,
                goal: goal,
                players: players,
                strokes: strokes,
                preferIndoor: preferIndoor,
                weatherJson: weatherJson,
                weatherUsed: weatherUsed,
                weatherAdvice: weatherAdvice,
                completedAt: completedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required String title,
                required String summary,
                required DateTime createdAt,
                required int durationMinutes,
                required SkillLevel level,
                required TacticalGoal goal,
                required PlayerCount players,
                required String strokes,
                Value<bool> preferIndoor = const Value.absent(),
                Value<String?> weatherJson = const Value.absent(),
                Value<bool> weatherUsed = const Value.absent(),
                Value<String?> weatherAdvice = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TrainingSessionsCompanion.insert(
                id: id,
                userId: userId,
                title: title,
                summary: summary,
                createdAt: createdAt,
                durationMinutes: durationMinutes,
                level: level,
                goal: goal,
                players: players,
                strokes: strokes,
                preferIndoor: preferIndoor,
                weatherJson: weatherJson,
                weatherUsed: weatherUsed,
                weatherAdvice: weatherAdvice,
                completedAt: completedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TrainingSessionsTable, TrainingSessionRow>(
                    table,
                  ),
                  $$TrainingSessionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({exercisesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (exercisesRefs) db.exercises],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (exercisesRefs)
                    await $_getPrefetchedData<
                      TrainingSessionRow,
                      $TrainingSessionsTable,
                      ExerciseRow
                    >(
                      currentTable: table,
                      referencedTable: $$TrainingSessionsTableReferences
                          ._exercisesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$TrainingSessionsTableReferences(
                            db,
                            table,
                            p0,
                          ).exercisesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.sessionId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$TrainingSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabaseService,
      $TrainingSessionsTable,
      TrainingSessionRow,
      $$TrainingSessionsTableFilterComposer,
      $$TrainingSessionsTableOrderingComposer,
      $$TrainingSessionsTableAnnotationComposer,
      $$TrainingSessionsTableCreateCompanionBuilder,
      $$TrainingSessionsTableUpdateCompanionBuilder,
      (TrainingSessionRow, $$TrainingSessionsTableReferences),
      TrainingSessionRow,
      PrefetchHooks Function({bool exercisesRefs})
    >;
typedef $$ExercisesTableCreateCompanionBuilder = ExercisesCompanion Function({
  required String sessionId,
  required int position,
  required String title,
  required String description,
  required int estimatedMinutes,
  required String technicalTip,
  required ExercisePhase phase,
  Value<bool> indoorFriendly,
  Value<int> rowid,
});
typedef $$ExercisesTableUpdateCompanionBuilder = ExercisesCompanion Function({
  Value<String> sessionId,
  Value<int> position,
  Value<String> title,
  Value<String> description,
  Value<int> estimatedMinutes,
  Value<String> technicalTip,
  Value<ExercisePhase> phase,
  Value<bool> indoorFriendly,
  Value<int> rowid,
});

final class $$ExercisesTableReferences
    extends
        BaseReferences<_$LocalDatabaseService, $ExercisesTable, ExerciseRow> {
  $$ExercisesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TrainingSessionsTable _sessionIdTable(_$LocalDatabaseService db) => db
      .trainingSessions
      .createAlias('exercises__session_id__training_sessions__id');

  $$TrainingSessionsTableProcessedTableManager get sessionId {
    final $_column = $_itemColumn<String>('session_id')!;

    final manager = $$TrainingSessionsTableTableManager(
      $_db,
      $_db.trainingSessions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ExercisesTableFilterComposer
    extends Composer<_$LocalDatabaseService, $ExercisesTable> {
  $$ExercisesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get estimatedMinutes => $composableBuilder(
    column: $table.estimatedMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get technicalTip => $composableBuilder(
    column: $table.technicalTip,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ExercisePhase, ExercisePhase, String>
  get phase => $composableBuilder(
    column: $table.phase,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<bool> get indoorFriendly => $composableBuilder(
    column: $table.indoorFriendly,
    builder: (column) => ColumnFilters(column),
  );

  $$TrainingSessionsTableFilterComposer get sessionId {
    final $$TrainingSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.trainingSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrainingSessionsTableFilterComposer(
            $db: $db,
            $table: $db.trainingSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExercisesTableOrderingComposer
    extends Composer<_$LocalDatabaseService, $ExercisesTable> {
  $$ExercisesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get estimatedMinutes => $composableBuilder(
    column: $table.estimatedMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get technicalTip => $composableBuilder(
    column: $table.technicalTip,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phase => $composableBuilder(
    column: $table.phase,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get indoorFriendly => $composableBuilder(
    column: $table.indoorFriendly,
    builder: (column) => ColumnOrderings(column),
  );

  $$TrainingSessionsTableOrderingComposer get sessionId {
    final $$TrainingSessionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.trainingSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrainingSessionsTableOrderingComposer(
            $db: $db,
            $table: $db.trainingSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExercisesTableAnnotationComposer
    extends Composer<_$LocalDatabaseService, $ExercisesTable> {
  $$ExercisesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<int> get estimatedMinutes => $composableBuilder(
    column: $table.estimatedMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get technicalTip => $composableBuilder(
    column: $table.technicalTip,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<ExercisePhase, String> get phase =>
      $composableBuilder(column: $table.phase, builder: (column) => column);

  GeneratedColumn<bool> get indoorFriendly => $composableBuilder(
    column: $table.indoorFriendly,
    builder: (column) => column,
  );

  $$TrainingSessionsTableAnnotationComposer get sessionId {
    final $$TrainingSessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.trainingSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrainingSessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.trainingSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExercisesTableTableManager
    extends
        RootTableManager<
          _$LocalDatabaseService,
          $ExercisesTable,
          ExerciseRow,
          $$ExercisesTableFilterComposer,
          $$ExercisesTableOrderingComposer,
          $$ExercisesTableAnnotationComposer,
          $$ExercisesTableCreateCompanionBuilder,
          $$ExercisesTableUpdateCompanionBuilder,
          (ExerciseRow, $$ExercisesTableReferences),
          ExerciseRow,
          PrefetchHooks Function({bool sessionId})
        > {
  $$ExercisesTableTableManager(_$LocalDatabaseService db, $ExercisesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExercisesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExercisesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExercisesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> sessionId = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<int> estimatedMinutes = const Value.absent(),
                Value<String> technicalTip = const Value.absent(),
                Value<ExercisePhase> phase = const Value.absent(),
                Value<bool> indoorFriendly = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExercisesCompanion(
                sessionId: sessionId,
                position: position,
                title: title,
                description: description,
                estimatedMinutes: estimatedMinutes,
                technicalTip: technicalTip,
                phase: phase,
                indoorFriendly: indoorFriendly,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String sessionId,
                required int position,
                required String title,
                required String description,
                required int estimatedMinutes,
                required String technicalTip,
                required ExercisePhase phase,
                Value<bool> indoorFriendly = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExercisesCompanion.insert(
                sessionId: sessionId,
                position: position,
                title: title,
                description: description,
                estimatedMinutes: estimatedMinutes,
                technicalTip: technicalTip,
                phase: phase,
                indoorFriendly: indoorFriendly,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ExercisesTable, ExerciseRow>(table),
                  $$ExercisesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sessionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (sessionId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.sessionId,
                        referencedTable: $$ExercisesTableReferences
                            ._sessionIdTable(db),
                        referencedColumn: $$ExercisesTableReferences
                            ._sessionIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ExercisesTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabaseService,
      $ExercisesTable,
      ExerciseRow,
      $$ExercisesTableFilterComposer,
      $$ExercisesTableOrderingComposer,
      $$ExercisesTableAnnotationComposer,
      $$ExercisesTableCreateCompanionBuilder,
      $$ExercisesTableUpdateCompanionBuilder,
      (ExerciseRow, $$ExercisesTableReferences),
      ExerciseRow,
      PrefetchHooks Function({bool sessionId})
    >;
typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$AppSettingsTableFilterComposer
    extends Composer<_$LocalDatabaseService, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$LocalDatabaseService, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$LocalDatabaseService, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$AppSettingsTableTableManager
    extends
        RootTableManager<
          _$LocalDatabaseService,
          $AppSettingsTable,
          AppSettingRow,
          $$AppSettingsTableFilterComposer,
          $$AppSettingsTableOrderingComposer,
          $$AppSettingsTableAnnotationComposer,
          $$AppSettingsTableCreateCompanionBuilder,
          $$AppSettingsTableUpdateCompanionBuilder,
          (
            AppSettingRow,
            BaseReferences<
              _$LocalDatabaseService,
              $AppSettingsTable,
              AppSettingRow
            >,
          ),
          AppSettingRow,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableManager(
    _$LocalDatabaseService db,
    $AppSettingsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => AppSettingsCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AppSettingsTable, AppSettingRow>(table),
                  BaseReferences<
                    _$LocalDatabaseService,
                    $AppSettingsTable,
                    AppSettingRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabaseService,
      $AppSettingsTable,
      AppSettingRow,
      $$AppSettingsTableFilterComposer,
      $$AppSettingsTableOrderingComposer,
      $$AppSettingsTableAnnotationComposer,
      $$AppSettingsTableCreateCompanionBuilder,
      $$AppSettingsTableUpdateCompanionBuilder,
      (
        AppSettingRow,
        BaseReferences<
          _$LocalDatabaseService,
          $AppSettingsTable,
          AppSettingRow
        >,
      ),
      AppSettingRow,
      PrefetchHooks Function()
    >;

class $LocalDatabaseServiceManager {
  final _$LocalDatabaseService _db;
  $LocalDatabaseServiceManager(this._db);
  $$TrainingSessionsTableTableManager get trainingSessions =>
      $$TrainingSessionsTableTableManager(_db, _db.trainingSessions);
  $$ExercisesTableTableManager get exercises =>
      $$ExercisesTableTableManager(_db, _db.exercises);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
}
