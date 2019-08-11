// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps
class BasicTask extends DataClass implements Insertable<BasicTask> {
  final String id;
  final int progress;
  BasicTask({@required this.id, @required this.progress});
  factory BasicTask.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final stringType = db.typeSystem.forDartType<String>();
    final intType = db.typeSystem.forDartType<int>();
    return BasicTask(
      id: stringType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      progress:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}progress']),
    );
  }
  factory BasicTask.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return BasicTask(
      id: serializer.fromJson<String>(json['id']),
      progress: serializer.fromJson<int>(json['progress']),
    );
  }
  @override
  Map<String, dynamic> toJson(
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return {
      'id': serializer.toJson<String>(id),
      'progress': serializer.toJson<int>(progress),
    };
  }

  @override
  T createCompanion<T extends UpdateCompanion<BasicTask>>(bool nullToAbsent) {
    return BasicTasksCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      progress: progress == null && nullToAbsent
          ? const Value.absent()
          : Value(progress),
    ) as T;
  }

  BasicTask copyWith({String id, int progress}) => BasicTask(
        id: id ?? this.id,
        progress: progress ?? this.progress,
      );
  @override
  String toString() {
    return (StringBuffer('BasicTask(')
          ..write('id: $id, ')
          ..write('progress: $progress')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc($mrjc(0, id.hashCode), progress.hashCode));
  @override
  bool operator ==(other) =>
      identical(this, other) ||
      (other is BasicTask && other.id == id && other.progress == progress);
}

class BasicTasksCompanion extends UpdateCompanion<BasicTask> {
  final Value<String> id;
  final Value<int> progress;
  const BasicTasksCompanion({
    this.id = const Value.absent(),
    this.progress = const Value.absent(),
  });
}

class $BasicTasksTable extends BasicTasks
    with TableInfo<$BasicTasksTable, BasicTask> {
  final GeneratedDatabase _db;
  final String _alias;
  $BasicTasksTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedTextColumn _id;
  @override
  GeneratedTextColumn get id => _id ??= _constructId();
  GeneratedTextColumn _constructId() {
    return GeneratedTextColumn('id', $tableName, false,
        minTextLength: 24, maxTextLength: 24, $customConstraints: 'UNIQUE');
  }

  final VerificationMeta _progressMeta = const VerificationMeta('progress');
  GeneratedIntColumn _progress;
  @override
  GeneratedIntColumn get progress => _progress ??= _constructProgress();
  GeneratedIntColumn _constructProgress() {
    return GeneratedIntColumn('progress', $tableName, false,
        defaultValue: Constant(0));
  }

  @override
  List<GeneratedColumn> get $columns => [id, progress];
  @override
  $BasicTasksTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'basic_tasks';
  @override
  final String actualTableName = 'basic_tasks';
  @override
  VerificationContext validateIntegrity(BasicTasksCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.id.present) {
      context.handle(_idMeta, id.isAcceptableValue(d.id.value, _idMeta));
    } else if (id.isRequired && isInserting) {
      context.missing(_idMeta);
    }
    if (d.progress.present) {
      context.handle(_progressMeta,
          progress.isAcceptableValue(d.progress.value, _progressMeta));
    } else if (progress.isRequired && isInserting) {
      context.missing(_progressMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => <GeneratedColumn>{};
  @override
  BasicTask map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return BasicTask.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(BasicTasksCompanion d) {
    final map = <String, Variable>{};
    if (d.id.present) {
      map['id'] = Variable<String, StringType>(d.id.value);
    }
    if (d.progress.present) {
      map['progress'] = Variable<int, IntType>(d.progress.value);
    }
    return map;
  }

  @override
  $BasicTasksTable createAlias(String alias) {
    return $BasicTasksTable(_db, alias);
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(const SqlTypeSystem.withDefaults(), e);
  $BasicTasksTable _basicTasks;
  $BasicTasksTable get basicTasks => _basicTasks ??= $BasicTasksTable(this);
  @override
  List<TableInfo> get allTables => [basicTasks];
}
