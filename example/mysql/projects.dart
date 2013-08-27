import 'package:sqljocky/sqljocky.dart';
import 'package:sqljocky/utils.dart';
import 'package:options_file/options_file.dart';
import 'dart:async';

/*
 * This example drops the project table if it exists, before recreating it.
 * It then stores several projects in the database and reads them back.
 * You must have a connection.options file in order for this to connect.
 */

class Example {
  ConnectionPool pool;

  Example(this.pool);

  Future run() {
    var completer = new Completer();
    dropTables()
      .then((_) => createTables())
      .then((_) => addData())
      .then((_) => readData())
      .then((_) => completer.complete());
    return completer.future;
  }

  Future dropTables() {
    print('dropping tables');
    var dropper = new TableDropper(pool, ['task', 'project']);
    return dropper.dropTables();
  }

  Future createTables() {
    print('creating tables');
    var querier = new QueryRunner(pool,
        [
         'create table project '
         '('
           'code varchar(64) not null, '
           'name varchar(64) not null, '
           'description varchar(256), '
           'primary key (code) '
         ')',
        ]);
    print('executing queries');
    return querier.executeQueries();
  }

  Future addData() {
    var completer = new Completer();
    pool.prepare(
        'insert into project (code, name, description) values (?, ?, ?)'
        ).then((query) {
      print('prepared query insert into project');
      var parameters = [
          ['Dart', 'Dart', 'Learning Dart.'],
          ['Web Components', 'Web Components', 'Learning web components.'],
          ['MySql', 'MySql', 'Figuring out MySql driver for Dart.']
        ];
      return query.executeMulti(parameters);
    }).then((results) {
      print('executed query insert into project');
      completer.complete();
    });
    return completer.future;
  }

  Future readData() {
    var completer = new Completer();
    print('querying projects');
    pool.query(
        'select p.name, p.description '
        'from project p '
        ).then((rows) {
      print('got results');
      rows.stream.listen((row) {
        print('Name: ${row[0]}, Description: ${row[1]}');
      });
      completer.complete();
    });
    return completer.future;
  }

}

void main() {
  try {
    OptionsFile options = new OptionsFile('connection.options');
    String user = options.getString('user');
    String password = options.getString('password');
    int port = options.getInt('port', 3306);
    String db = options.getString('db');
    String host = options.getString('host', 'localhost');

    // create a connection
    print('opening connection');
    var pool = new ConnectionPool(host: host, port: port, user: user, password: password, db: db);
    print('connection open');
    // create an example class
    var example = new Example(pool);
    // run the example
    print('running example');
    example.run().then((_) {
      // finally, close the connection
      print('bye');
      pool.close();
    });
  } catch(e) {
    print('consult README: $e');
  }
}

