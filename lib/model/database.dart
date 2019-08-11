import 'package:moor_flutter/moor_flutter.dart';
part 'database.g.dart';

class BasicTasks extends Table {
  TextColumn get id => text().withLength()();
  IntColumn get progress => integer().withDefault(Constant(0))();
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

  @override
  int get schemaVersion => 1;
}
