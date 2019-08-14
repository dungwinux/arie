// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps
class BasicTask extends DataClass implements Insertable<BasicTask> {
  final String id;
  final int doneSubtask;
  final String name;
  final String description;
  final String creator;
  final DateTime createTime;
  final DateTime startTime;
  final DateTime endTime;
  final String checkpointList;
  BasicTask(
      {@required this.id,
      @required this.doneSubtask,
      @required this.name,
      @required this.description,
      @required this.creator,
      @required this.createTime,
      @required this.startTime,
      @required this.endTime,
      @required this.checkpointList});
  factory BasicTask.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final stringType = db.typeSystem.forDartType<String>();
    final intType = db.typeSystem.forDartType<int>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    return BasicTask(
      id: stringType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      doneSubtask: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}done_subtask']),
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
      description: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}description']),
      creator:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}creator']),
      createTime: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}create_time']),
      startTime: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}start_time']),
      endTime: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}end_time']),
      checkpointList: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}checkpoint_list']),
    );
  }
  factory BasicTask.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return BasicTask(
      id: serializer.fromJson<String>(json['id']),
      doneSubtask: serializer.fromJson<int>(json['doneSubtask']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String>(json['description']),
      creator: serializer.fromJson<String>(json['creator']),
      createTime: serializer.fromJson<DateTime>(json['createTime']),
      startTime: serializer.fromJson<DateTime>(json['startTime']),
      endTime: serializer.fromJson<DateTime>(json['endTime']),
      checkpointList: serializer.fromJson<String>(json['checkpointList']),
    );
  }
  @override
  Map<String, dynamic> toJson(
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return {
      'id': serializer.toJson<String>(id),
      'doneSubtask': serializer.toJson<int>(doneSubtask),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String>(description),
      'creator': serializer.toJson<String>(creator),
      'createTime': serializer.toJson<DateTime>(createTime),
      'startTime': serializer.toJson<DateTime>(startTime),
      'endTime': serializer.toJson<DateTime>(endTime),
      'checkpointList': serializer.toJson<String>(checkpointList),
    };
  }

  @override
  T createCompanion<T extends UpdateCompanion<BasicTask>>(bool nullToAbsent) {
    return BasicTasksCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      doneSubtask: doneSubtask == null && nullToAbsent
          ? const Value.absent()
          : Value(doneSubtask),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      creator: creator == null && nullToAbsent
          ? const Value.absent()
          : Value(creator),
      createTime: createTime == null && nullToAbsent
          ? const Value.absent()
          : Value(createTime),
      startTime: startTime == null && nullToAbsent
          ? const Value.absent()
          : Value(startTime),
      endTime: endTime == null && nullToAbsent
          ? const Value.absent()
          : Value(endTime),
      checkpointList: checkpointList == null && nullToAbsent
          ? const Value.absent()
          : Value(checkpointList),
    ) as T;
  }

  BasicTask copyWith(
          {String id,
          int doneSubtask,
          String name,
          String description,
          String creator,
          DateTime createTime,
          DateTime startTime,
          DateTime endTime,
          String checkpointList}) =>
      BasicTask(
        id: id ?? this.id,
        doneSubtask: doneSubtask ?? this.doneSubtask,
        name: name ?? this.name,
        description: description ?? this.description,
        creator: creator ?? this.creator,
        createTime: createTime ?? this.createTime,
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        checkpointList: checkpointList ?? this.checkpointList,
      );
  @override
  String toString() {
    return (StringBuffer('BasicTask(')
          ..write('id: $id, ')
          ..write('doneSubtask: $doneSubtask, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('creator: $creator, ')
          ..write('createTime: $createTime, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('checkpointList: $checkpointList')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      $mrjc(
          $mrjc(
              $mrjc(
                  $mrjc(
                      $mrjc(
                          $mrjc(
                              $mrjc(
                                  $mrjc(0, id.hashCode), doneSubtask.hashCode),
                              name.hashCode),
                          description.hashCode),
                      creator.hashCode),
                  createTime.hashCode),
              startTime.hashCode),
          endTime.hashCode),
      checkpointList.hashCode));
  @override
  bool operator ==(other) =>
      identical(this, other) ||
      (other is BasicTask &&
          other.id == id &&
          other.doneSubtask == doneSubtask &&
          other.name == name &&
          other.description == description &&
          other.creator == creator &&
          other.createTime == createTime &&
          other.startTime == startTime &&
          other.endTime == endTime &&
          other.checkpointList == checkpointList);
}

class BasicTasksCompanion extends UpdateCompanion<BasicTask> {
  final Value<String> id;
  final Value<int> doneSubtask;
  final Value<String> name;
  final Value<String> description;
  final Value<String> creator;
  final Value<DateTime> createTime;
  final Value<DateTime> startTime;
  final Value<DateTime> endTime;
  final Value<String> checkpointList;
  const BasicTasksCompanion({
    this.id = const Value.absent(),
    this.doneSubtask = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.creator = const Value.absent(),
    this.createTime = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.checkpointList = const Value.absent(),
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

  final VerificationMeta _doneSubtaskMeta =
      const VerificationMeta('doneSubtask');
  GeneratedIntColumn _doneSubtask;
  @override
  GeneratedIntColumn get doneSubtask =>
      _doneSubtask ??= _constructDoneSubtask();
  GeneratedIntColumn _constructDoneSubtask() {
    return GeneratedIntColumn('done_subtask', $tableName, false,
        defaultValue: Constant(0));
  }

  final VerificationMeta _nameMeta = const VerificationMeta('name');
  GeneratedTextColumn _name;
  @override
  GeneratedTextColumn get name => _name ??= _constructName();
  GeneratedTextColumn _constructName() {
    return GeneratedTextColumn(
      'name',
      $tableName,
      false,
    );
  }

  final VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  GeneratedTextColumn _description;
  @override
  GeneratedTextColumn get description =>
      _description ??= _constructDescription();
  GeneratedTextColumn _constructDescription() {
    return GeneratedTextColumn(
      'description',
      $tableName,
      false,
    );
  }

  final VerificationMeta _creatorMeta = const VerificationMeta('creator');
  GeneratedTextColumn _creator;
  @override
  GeneratedTextColumn get creator => _creator ??= _constructCreator();
  GeneratedTextColumn _constructCreator() {
    return GeneratedTextColumn(
      'creator',
      $tableName,
      false,
    );
  }

  final VerificationMeta _createTimeMeta = const VerificationMeta('createTime');
  GeneratedDateTimeColumn _createTime;
  @override
  GeneratedDateTimeColumn get createTime =>
      _createTime ??= _constructCreateTime();
  GeneratedDateTimeColumn _constructCreateTime() {
    return GeneratedDateTimeColumn(
      'create_time',
      $tableName,
      false,
    );
  }

  final VerificationMeta _startTimeMeta = const VerificationMeta('startTime');
  GeneratedDateTimeColumn _startTime;
  @override
  GeneratedDateTimeColumn get startTime => _startTime ??= _constructStartTime();
  GeneratedDateTimeColumn _constructStartTime() {
    return GeneratedDateTimeColumn(
      'start_time',
      $tableName,
      false,
    );
  }

  final VerificationMeta _endTimeMeta = const VerificationMeta('endTime');
  GeneratedDateTimeColumn _endTime;
  @override
  GeneratedDateTimeColumn get endTime => _endTime ??= _constructEndTime();
  GeneratedDateTimeColumn _constructEndTime() {
    return GeneratedDateTimeColumn(
      'end_time',
      $tableName,
      false,
    );
  }

  final VerificationMeta _checkpointListMeta =
      const VerificationMeta('checkpointList');
  GeneratedTextColumn _checkpointList;
  @override
  GeneratedTextColumn get checkpointList =>
      _checkpointList ??= _constructCheckpointList();
  GeneratedTextColumn _constructCheckpointList() {
    return GeneratedTextColumn(
      'checkpoint_list',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [
        id,
        doneSubtask,
        name,
        description,
        creator,
        createTime,
        startTime,
        endTime,
        checkpointList
      ];
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
    if (d.doneSubtask.present) {
      context.handle(_doneSubtaskMeta,
          doneSubtask.isAcceptableValue(d.doneSubtask.value, _doneSubtaskMeta));
    } else if (doneSubtask.isRequired && isInserting) {
      context.missing(_doneSubtaskMeta);
    }
    if (d.name.present) {
      context.handle(
          _nameMeta, name.isAcceptableValue(d.name.value, _nameMeta));
    } else if (name.isRequired && isInserting) {
      context.missing(_nameMeta);
    }
    if (d.description.present) {
      context.handle(_descriptionMeta,
          description.isAcceptableValue(d.description.value, _descriptionMeta));
    } else if (description.isRequired && isInserting) {
      context.missing(_descriptionMeta);
    }
    if (d.creator.present) {
      context.handle(_creatorMeta,
          creator.isAcceptableValue(d.creator.value, _creatorMeta));
    } else if (creator.isRequired && isInserting) {
      context.missing(_creatorMeta);
    }
    if (d.createTime.present) {
      context.handle(_createTimeMeta,
          createTime.isAcceptableValue(d.createTime.value, _createTimeMeta));
    } else if (createTime.isRequired && isInserting) {
      context.missing(_createTimeMeta);
    }
    if (d.startTime.present) {
      context.handle(_startTimeMeta,
          startTime.isAcceptableValue(d.startTime.value, _startTimeMeta));
    } else if (startTime.isRequired && isInserting) {
      context.missing(_startTimeMeta);
    }
    if (d.endTime.present) {
      context.handle(_endTimeMeta,
          endTime.isAcceptableValue(d.endTime.value, _endTimeMeta));
    } else if (endTime.isRequired && isInserting) {
      context.missing(_endTimeMeta);
    }
    if (d.checkpointList.present) {
      context.handle(
          _checkpointListMeta,
          checkpointList.isAcceptableValue(
              d.checkpointList.value, _checkpointListMeta));
    } else if (checkpointList.isRequired && isInserting) {
      context.missing(_checkpointListMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
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
    if (d.doneSubtask.present) {
      map['done_subtask'] = Variable<int, IntType>(d.doneSubtask.value);
    }
    if (d.name.present) {
      map['name'] = Variable<String, StringType>(d.name.value);
    }
    if (d.description.present) {
      map['description'] = Variable<String, StringType>(d.description.value);
    }
    if (d.creator.present) {
      map['creator'] = Variable<String, StringType>(d.creator.value);
    }
    if (d.createTime.present) {
      map['create_time'] = Variable<DateTime, DateTimeType>(d.createTime.value);
    }
    if (d.startTime.present) {
      map['start_time'] = Variable<DateTime, DateTimeType>(d.startTime.value);
    }
    if (d.endTime.present) {
      map['end_time'] = Variable<DateTime, DateTimeType>(d.endTime.value);
    }
    if (d.checkpointList.present) {
      map['checkpoint_list'] =
          Variable<String, StringType>(d.checkpointList.value);
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
