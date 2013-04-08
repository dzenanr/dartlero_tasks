import 'package:unittest/unittest.dart';
import 'package:options_file/options_file.dart';
import 'package:sqljocky/sqljocky.dart';
import 'package:sqljocky/utils.dart';
import 'dart:async';

testProjects(ConnectionPool pool) {
  group("Testing projects", () {
    setUp(() {
      dropTables(pool).then((x) {
        print("dropped tables");
        createTable(pool).then((x) {
          print("created project table");
          initData(pool).then((x) {
            print("initialized data");
          });
        });
      });
    });
    tearDown(() {

    });
    test("Select all", () {
      pool.query(
        'select p.code, p.name, p.description '
        'from project p '
      ).then((result) {
        print("selected all projects");
        for (var row in result) {
          print("code: ${row[0]}, name: ${row[1]}, description: ${row[2]}");
        }
      });
    });
  });
}

Future dropTables(ConnectionPool pool) {
  print("dropping tables");
  var dropper = new TableDropper(pool, ['task', 'project']);
  return dropper.dropTables();
}

Future createTable(ConnectionPool pool) {
  print("creating project table");
  var query = new QueryRunner(pool, [
    'create table project ('
      'code varchar(64) not null, '
      'name varchar(64) not null, '
      'description varchar(256), '
      'primary key (code) '
    ')',
  ]);
  return query.executeQueries();
}

Future initData(ConnectionPool pool) {
  print("initializing project data");
  var completer = new Completer();
  pool.prepare(
    "insert into project (code, name, description) values (?, ?, ?)"
  ).then((query) {
    print("prepared query insert into project");
    var data = [
      ["Dart", "Dart", "Learning Dart."],
      ["Web Components", "Web Components", "Learning web components."],
      ["MySql", "MySql", "Figuring out MySql driver for Dart."]
    ];
    return query.executeMulti(data);
  }).then((results) {
    print("executed query insert into project");
    completer.complete(results);
  });
  return completer.future;
}

ConnectionPool getPool(OptionsFile options) {
  String user = options.getString('user');
  String password = options.getString('password');
  int port = options.getInt('port', 3306);
  String db = options.getString('db');
  String host = options.getString('host', 'localhost');
  return new ConnectionPool(
      host: host, port: port, user: user, password: password, db: db);
}

main() {
  testProjects(getPool(new OptionsFile('connection.options')));
}