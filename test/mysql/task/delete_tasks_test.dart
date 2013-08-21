import 'package:unittest/unittest.dart';
import 'package:options_file/options_file.dart';
import 'package:sqljocky/sqljocky.dart';
import 'package:sqljocky/utils.dart';
import 'dart:async';

testTasks(ConnectionPool pool) {

  test("Select all tasks", () {
    pool.query(
        'select t.code, t.projectCode, t.employeeCode, t.description '
        'from task t '
    ).then((rows) {
      print("printing all tasks");
      rows.stream.listen((row) {
        print(
            'code: ${row[0]}, '
            'project code: ${row[1]}, '
            'employee code: ${row[2]}, '
            'description: ${row[3]}'
        );
      });
    });
  });

  test("Delete some tasks", () {
    pool.query(
        'delete from task '
        'where task.projectCode="Web Components" '
    ).then((x) {
      pool.query(
          'select * '
          'from task '
      ).then((rows) {
        print("printing tasks after delete");
        rows.stream.listen((row) {
          print(
              'code: ${row[0]}, '
              'project code: ${row[1]}, '
              'employee code: ${row[2]}, '
              'description: ${row[3]}'
          );
        });
      });
    });
  });

}

Future dropTable(ConnectionPool pool) {
  print("dropping task table");
  var dropper = new TableDropper(pool, ['task']);
  return dropper.dropTables();
}

Future createTable(ConnectionPool pool) {
  print("creating task table");
  var query = new QueryRunner(pool, [
    'create table task ('
      'code varchar(128) not null, '
      'projectCode varchar(64), '
      'employeeCode varchar(64), '
      'description varchar(256), '
      'primary key (code), '
      'foreign key (projectCode) references project (code), '
      'foreign key (employeeCode) references employee (code) '
    ')'
  ]);
  return query.executeQueries();
}

Future initData(ConnectionPool pool) {
  print("initializing task data");
  var completer = new Completer();
  pool.prepare(
      "insert into task (code, projectCode, employeeCode, description) values (?, ?, ?, ?)"
  ).then((query) {
    var data = [
      ["Dart-timur.ridjanovic@gmail.com", "Dart", "timur.ridjanovic@gmail.com", "Timur is learning Dart."],
      ["Dart-ma.seyer@gmail.com", "Dart", "ma.seyer@gmail.com", "Marc-Antoine is learning Dart."],
      ["Web Components-dzenanr@gmail.com", "Web Components", "dzenanr@gmail.com", "Dzenan is learning Web Components."]
    ];
    return query.executeMulti(data);
  }).then((results) {
    completer.complete(results);
  });
  return completer.future;
}

Future clearTable(ConnectionPool pool) {
  print("clearing task table");
  var query = new QueryRunner(pool, [
    'truncate task'
  ]);
  return query.executeQueries();
}

ConnectionPool getPool(OptionsFile options) {
  print("getting connection options");
  String user = options.getString('user');
  String password = options.getString('password');
  int port = options.getInt('port', 3306);
  String db = options.getString('db');
  String host = options.getString('host', 'localhost');
  return new ConnectionPool(
      host: host, port: port, user: user, password: password, db: db);
}

main() {
  var pool = getPool(new OptionsFile('connection.options'));
  dropTable(pool).then((x) => createTable(pool))
                 .then((x) => initData(pool))
                 .then((x) => testTasks(pool));
}