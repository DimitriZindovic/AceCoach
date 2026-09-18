// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_database_service.dart';

// ignore_for_file: type=lint
class $SessionsTable extends Sessions with TableInfo<$SessionsTable, Session> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessionsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _paramsJsonMeta = const VerificationMeta(
    'paramsJson',
  );
  @override
  late final GeneratedColumn<String> paramsJson = GeneratedColumn<String>(
    'params_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _exercisesJsonMeta = const VerificationMeta(
    'exercisesJson',
  );
  @override
  late final GeneratedColumn<String> exercisesJson = GeneratedColumn<String>(
    'exercises_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    title,
    summary,
    createdAt,
    completedAt,
    paramsJson,
    exercisesJson,
    weatherJson,
    weatherUsed,
    weatherAdvice,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<Session> instance, {
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
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    if (data.containsKey('params_json')) {
      context.handle(
        _paramsJsonMeta,
        paramsJson.isAcceptableOrUnknown(data['params_json']!, _paramsJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_paramsJsonMeta);
    }
    if (data.containsKey('exercises_json')) {
      context.handle(
        _exercisesJsonMeta,
        exercisesJson.isAcceptableOrUnknown(
          data['exercises_json']!,
          _exercisesJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_exercisesJsonMeta);
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Session map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Session(
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
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
      paramsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}params_json'],
      )!,
      exercisesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercises_json'],
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
    );
  }

  @override
  $SessionsTable createAlias(String alias) {
    return $SessionsTable(attachedDatabase, alias);
  }
}

class Session extends DataClass implements Insertable<Session> {
  final String id;
  final String userId;
  final String title;
  final String summary;
  final DateTime createdAt;
  final DateTime? completedAt;
  final String paramsJson;
  final String exercisesJson;
  final String? weatherJson;
  final bool weatherUsed;
  final String? weatherAdvice;
  const Session({
    required this.id,
    required this.userId,
    required this.title,
    required this.summary,
    required this.createdAt,
    this.completedAt,
    required this.paramsJson,
    required this.exercisesJson,
    this.weatherJson,
    required this.weatherUsed,
    this.weatherAdvice,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['title'] = Variable<String>(title);
    map['summary'] = Variable<String>(summary);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    map['params_json'] = Variable<String>(paramsJson);
    map['exercises_json'] = Variable<String>(exercisesJson);
    if (!nullToAbsent || weatherJson != null) {
      map['weather_json'] = Variable<String>(weatherJson);
    }
    map['weather_used'] = Variable<bool>(weatherUsed);
    if (!nullToAbsent || weatherAdvice != null) {
      map['weather_advice'] = Variable<String>(weatherAdvice);
    }
    return map;
  }

  SessionsCompanion toCompanion(bool nullToAbsent) {
    return SessionsCompanion(
      id: Value(id),
      userId: Value(userId),
      title: Value(title),
      summary: Value(summary),
      createdAt: Value(createdAt),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      paramsJson: Value(paramsJson),
      exercisesJson: Value(exercisesJson),
      weatherJson: weatherJson == null && nullToAbsent
          ? const Value.absent()
          : Value(weatherJson),
      weatherUsed: Value(weatherUsed),
      weatherAdvice: weatherAdvice == null && nullToAbsent
          ? const Value.absent()
          : Value(weatherAdvice),
    );
  }

  factory Session.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Session(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      title: serializer.fromJson<String>(json['title']),
      summary: serializer.fromJson<String>(json['summary']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      paramsJson: serializer.fromJson<String>(json['paramsJson']),
      exercisesJson: serializer.fromJson<String>(json['exercisesJson']),
      weatherJson: serializer.fromJson<String?>(json['weatherJson']),
      weatherUsed: serializer.fromJson<bool>(json['weatherUsed']),
      weatherAdvice: serializer.fromJson<String?>(json['weatherAdvice']),
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
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'paramsJson': serializer.toJson<String>(paramsJson),
      'exercisesJson': serializer.toJson<String>(exercisesJson),
      'weatherJson': serializer.toJson<String?>(weatherJson),
      'weatherUsed': serializer.toJson<bool>(weatherUsed),
      'weatherAdvice': serializer.toJson<String?>(weatherAdvice),
    };
  }

  Session copyWith({
    String? id,
    String? userId,
    String? title,
    String? summary,
    DateTime? createdAt,
    Value<DateTime?> completedAt = const Value.absent(),
    String? paramsJson,
    String? exercisesJson,
    Value<String?> weatherJson = const Value.absent(),
    bool? weatherUsed,
    Value<String?> weatherAdvice = const Value.absent(),
  }) => Session(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    title: title ?? this.title,
    summary: summary ?? this.summary,
    createdAt: createdAt ?? this.createdAt,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
    paramsJson: paramsJson ?? this.paramsJson,
    exercisesJson: exercisesJson ?? this.exercisesJson,
    weatherJson: weatherJson.present ? weatherJson.value : this.weatherJson,
    weatherUsed: weatherUsed ?? this.weatherUsed,
    weatherAdvice: weatherAdvice.present
        ? weatherAdvice.value
        : this.weatherAdvice,
  );
  Session copyWithCompanion(SessionsCompanion data) {
    return Session(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      title: data.title.present ? data.title.value : this.title,
      summary: data.summary.present ? data.summary.value : this.summary,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      paramsJson: data.paramsJson.present
          ? data.paramsJson.value
          : this.paramsJson,
      exercisesJson: data.exercisesJson.present
          ? data.exercisesJson.value
          : this.exercisesJson,
      weatherJson: data.weatherJson.present
          ? data.weatherJson.value
          : this.weatherJson,
      weatherUsed: data.weatherUsed.present
          ? data.weatherUsed.value
          : this.weatherUsed,
      weatherAdvice: data.weatherAdvice.present
          ? data.weatherAdvice.value
          : this.weatherAdvice,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Session(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('title: $title, ')
          ..write('summary: $summary, ')
          ..write('createdAt: $createdAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('paramsJson: $paramsJson, ')
          ..write('exercisesJson: $exercisesJson, ')
          ..write('weatherJson: $weatherJson, ')
          ..write('weatherUsed: $weatherUsed, ')
          ..write('weatherAdvice: $weatherAdvice')
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
    completedAt,
    paramsJson,
    exercisesJson,
    weatherJson,
    weatherUsed,
    weatherAdvice,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Session &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.title == this.title &&
          other.summary == this.summary &&
          other.createdAt == this.createdAt &&
          other.completedAt == this.completedAt &&
          other.paramsJson == this.paramsJson &&
          other.exercisesJson == this.exercisesJson &&
          other.weatherJson == this.weatherJson &&
          other.weatherUsed == this.weatherUsed &&
          other.weatherAdvice == this.weatherAdvice);
}

class SessionsCompanion extends UpdateCompanion<Session> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> title;
  final Value<String> summary;
  final Value<DateTime> createdAt;
  final Value<DateTime?> completedAt;
  final Value<String> paramsJson;
  final Value<String> exercisesJson;
  final Value<String?> weatherJson;
  final Value<bool> weatherUsed;
  final Value<String?> weatherAdvice;
  final Value<int> rowid;
  const SessionsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.title = const Value.absent(),
    this.summary = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.paramsJson = const Value.absent(),
    this.exercisesJson = const Value.absent(),
    this.weatherJson = const Value.absent(),
    this.weatherUsed = const Value.absent(),
    this.weatherAdvice = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SessionsCompanion.insert({
    required String id,
    required String userId,
    required String title,
    required String summary,
    required DateTime createdAt,
    this.completedAt = const Value.absent(),
    required String paramsJson,
    required String exercisesJson,
    this.weatherJson = const Value.absent(),
    this.weatherUsed = const Value.absent(),
    this.weatherAdvice = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       title = Value(title),
       summary = Value(summary),
       createdAt = Value(createdAt),
       paramsJson = Value(paramsJson),
       exercisesJson = Value(exercisesJson);
  static Insertable<Session> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? title,
    Expression<String>? summary,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? completedAt,
    Expression<String>? paramsJson,
    Expression<String>? exercisesJson,
    Expression<String>? weatherJson,
    Expression<bool>? weatherUsed,
    Expression<String>? weatherAdvice,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (title != null) 'title': title,
      if (summary != null) 'summary': summary,
      if (createdAt != null) 'created_at': createdAt,
      if (completedAt != null) 'completed_at': completedAt,
      if (paramsJson != null) 'params_json': paramsJson,
      if (exercisesJson != null) 'exercises_json': exercisesJson,
      if (weatherJson != null) 'weather_json': weatherJson,
      if (weatherUsed != null) 'weather_used': weatherUsed,
      if (weatherAdvice != null) 'weather_advice': weatherAdvice,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SessionsCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? title,
    Value<String>? summary,
    Value<DateTime>? createdAt,
    Value<DateTime?>? completedAt,
    Value<String>? paramsJson,
    Value<String>? exercisesJson,
    Value<String?>? weatherJson,
    Value<bool>? weatherUsed,
    Value<String?>? weatherAdvice,
    Value<int>? rowid,
  }) {
    return SessionsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      summary: summary ?? this.summary,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      paramsJson: paramsJson ?? this.paramsJson,
      exercisesJson: exercisesJson ?? this.exercisesJson,
      weatherJson: weatherJson ?? this.weatherJson,
      weatherUsed: weatherUsed ?? this.weatherUsed,
      weatherAdvice: weatherAdvice ?? this.weatherAdvice,
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
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (paramsJson.present) {
      map['params_json'] = Variable<String>(paramsJson.value);
    }
    if (exercisesJson.present) {
      map['exercises_json'] = Variable<String>(exercisesJson.value);
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
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessionsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('title: $title, ')
          ..write('summary: $summary, ')
          ..write('createdAt: $createdAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('paramsJson: $paramsJson, ')
          ..write('exercisesJson: $exercisesJson, ')
          ..write('weatherJson: $weatherJson, ')
          ..write('weatherUsed: $weatherUsed, ')
          ..write('weatherAdvice: $weatherAdvice, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$LocalDatabaseService extends GeneratedDatabase {
  _$LocalDatabaseService(QueryExecutor e) : super(e);
  late final $SessionsTable sessions = $SessionsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [sessions];
}
