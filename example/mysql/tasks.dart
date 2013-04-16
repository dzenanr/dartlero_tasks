import 'package:sqljocky/sqljocky.dart';
import 'package:sqljocky/utils.dart';
import 'package:options_file/options_file.dart';
import 'dart:async';

/*
 * This example drops the task table if it exists, before recreating it.
 * It then stores several tasks in the database and reads them back.
 * You must have a connection.options file in order for this to connect.
 */

class Example {
  ConnectionPool pool;

  Example(this.pool);

  Future run() {
    var completer = new Completer();
    // drop the tables if they already exist
    dropTables().then((x) {
      print("dropped tables");
      // then recreate the tables
      return createTables();
    }).then((x) {
      print("created tables");
      // add some data
      return addData();
    }).then((x) {
      // and read it back out
      return readData();
    }).then((x) {
      completer.complete(null);
    });
    return completer.future;
  }

  Future dropTables() {
    print("dropping tables");
    var dropper = new TableDropper(pool, ['task']);
    return dropper.dropTables();
  }

  Future createTables() {
    print("creating tables");
    var querier = new QueryRunner(pool,
        [
         'create table task '
         '('
           'code varchar(128) not null, '
           'projectCode varchar(64), '
           'employeeCode varchar(64), '
           'description varchar(256), '
           'primary key (code), '
           'foreign key (projectCode) references project (code), '
           'foreign key (employeeCode) references employee (code) '
         ')'
        ]);
    print("executing queries");
    return querier.executeQueries();
  }

  Future addData() {
    var completer = new Completer();
    pool.prepare(
        "insert into task (code, projectCode, employeeCode, description) values (?, ?, ?, ?)"
        ).then((query) {
      print("prepared query insert into task");
      var parameters = [
          ["Dart-timur.ridjanovic@gmail.com", "Dart", "timur.ridjanovic@gmail.com", "Timur is learning Dart."],
          ["Dart-ma.seyer@gmail.com", "Dart", "ma.seyer@gmail.com", "Marc-Antoine is learning Dart."],
          ["Web Components-dzenanr@gmail.com", "Web Components", "dzenanr@gmail.com", "Dzenan is learning Web Components."]
        ];
      return query.executeMulti(parameters);
    }).then((results) {
      print("executed query insert into project");
      completer.complete(null);
    });
    return completer.future;
  }

  Future readData() {
    var completer = new Completer();
    print("querying tasks");
    pool.query(
        'select t.projectCode, t.employeeCode, t.description '
        'from task t '
        ).then((result) {
      print("got results");
      for (var row in result) {
        print("Project Code: ${row[0]}, Employee Code: ${row[1]}, Description: ${row[2]}");
      }
      completer.complete(null);
    });
    return completer.future;
  }

}

void main() {
  OptionsFile options = new OptionsFile('connection.options');
  String user = options.getString('user');
  String password = options.getString('password');
  int port = options.getInt('port', 3306);
  String db = options.getString('db');
  String host = options.getString('host', 'localhost');

  // create a connection
  print("opening connection");
  var pool = new ConnectionPool(host: host, port: port, user: user, password: password, db: db);
  print("connection open");
  // create an example class
  var example = new Example(pool);
  // run the example
  print("running example");
  example.run().then((x) {
    // finally, close the connection
    print("bye");
    pool.close();
  });
}

