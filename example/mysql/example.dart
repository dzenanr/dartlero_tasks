import 'package:sqljocky/sqljocky.dart';
import 'package:sqljocky/utils.dart';
import 'package:options_file/options_file.dart';
import 'dart:async';

/*
 * This example drops a couple of tables if they exist, before recreating them.
 * It then stores some data in the database and reads it back out.
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
      .then((_) => completer.complete())
      .catchError((e) => print(e));
    return completer.future;
  }

  Future dropTables() {
    print('dropping tables');
    var dropper = new TableDropper(pool, ['task', 'employee', 'project']);
    return dropper.dropTables();
  }

  Future createTables() {
    print('creating tables');
    var querier = new QueryRunner(pool,
        [
         'create table employee (code varchar(64) not null, '
         'lastName varchar(32) not null, '
         'firstName varchar(32) not null, '
         'email varchar(64) not null, '
         'primary key (code))',

         'create table project (code varchar(64) not null, '
         'name varchar(64) not null, '
         'description varchar(256), '
         'primary key (code))',

         'create table task (code varchar(128) not null, '
         'projectCode varchar(64), '
         'employeeCode varchar(64), '
         'description varchar(256), '
         'primary key (code), '
         'foreign key (projectCode) references project (code), '
         'foreign key (employeeCode) references employee (code))'
        ]);
    print('executing queries');
    return querier.executeQueries();
  }

  Future addData() {
    var completer = new Completer();
    pool.prepare(
        'insert into employee (code, lastName, firstName, email) values (?, ?, ?, ?)'
        ).then((query) {
      print('prepared query 1');
      var parameters = [
          ['dzenanr@gmail.com', 'Ridjanovic', 'Dzenan', 'dzenanr@gmail.com'],
          ['timur.ridjanovic@gmail.com', 'Ridjanovic', 'Timur', 'timur.ridjanovic@gmail.com'],
          ['ma.seyer@gmail.com', 'Seyer', 'Marc-Antoine', 'ma.seyer@gmail.com']
        ];
      return query.executeMulti(parameters);
    }).then((results) {
      print('executed query 1');
      return pool.prepare(
          'insert into project (code, name, description) values (?, ?, ?)'
          );
    }).then((query) {
      print('prepared query 2');
      var parameters = [
          ['Dart', 'Dart', 'Learning Dart.'],
          ['Web Components', 'Web Components', 'Learning web components.'],
          ['MySql', 'MySql', 'Figuring out MySql driver for Dart.']
        ];
      return query.executeMulti(parameters);
    }).then((results) {
      print('executed query 2');
      return pool.prepare(
          'insert into task (code, projectCode, employeeCode, description) values (?, ?, ?, ?)'
          );
    }).then((query) {
      print('prepared query 3');
      var parameters = [
          ['Dart-timur.ridjanovic@gmail.com', 'Dart', 'timur.ridjanovic@gmail.com', 'Timur is learning Dart.'],
          ['Dart-ma.seyer@gmail.com', 'Dart', 'ma.seyer@gmail.com', 'Marc-Antoine is learning Dart.'],
          ['Web Components-dzenanr@gmail.com', 'Web Components', 'dzenanr@gmail.com', 'Dzenan is learning Web Components.']
        ];
      return query.executeMulti(parameters);
    }).then((results) {
      print('executed query 3');
      completer.complete();
    });
    return completer.future;
  }

  Future readData() {
    var completer = new Completer();
    print('querying');
    pool.query(
        'select e.lastName, e.firstName, e.email '
        'from employee e ').then((rows) {
      print('got results');
      rows.listen((row) {
        print('Last Name: ${row[0]}, First Name: ${row[1]}, Email: ${row[2]}');
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

