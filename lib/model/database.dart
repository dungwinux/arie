import 'package:moor_flutter/moor_flutter.dart';
part 'database.g.dart';

class BasicTasks extends Table {
  TextColumn get id =>
      text().customConstraint('UNIQUE').withLength(max: 24, min: 24)();
  IntColumn get doneSubtask => integer().withDefault(Constant(0))();
  TextColumn get name => text()();
  TextColumn get description => text()();
  TextColumn get creator => text()();
  DateTimeColumn get createTime => dateTime()();
  DateTimeColumn get startTime => dateTime()();
  DateTimeColumn get endTime => dateTime()();
  TextColumn get checkpointList => text()();

  @override
  Set<TextColumn> get primaryKey => {id};
}

@UseMoor(tables: [BasicTasks])
class AppDatabase extends _$AppDatabase {
  AppDatabase()
      : super(FlutterQueryExecutor.inDatabaseFolder(
            path: 'db.sqlite', logStatements: true));

  Future<List<BasicTask>> getAllTasks() => select(basicTasks).get();
  Stream<List<BasicTask>> watchAllTasks() => select(basicTasks).watch();

  Future insertTask(BasicTask task) => into(basicTasks).insert(task);
  Future updateTask(BasicTask task) => update(basicTasks).replace(task);
  Future deleteTask(BasicTask task) => delete(basicTasks).delete(task);

  Future getTask(String id) async {
    final output = await select(basicTasks).get();
    return output.firstWhere((x) => x.id == id);
  }

  Future isTaskExist(String id) async {
    final output = await select(basicTasks).get();
    return output.any((BasicTask t) => t.id == id);
  }

  @override
  int get schemaVersion => 1;
}
