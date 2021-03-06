import 'package:unittest/unittest.dart';
import 'package:options_file/options_file.dart';
import 'package:sqljocky/sqljocky.dart';
import 'package:sqljocky/utils.dart';
import 'dart:async';

testEmployees(ConnectionPool pool) {

  test('Select all employees', () {
    var count = 0;
    pool.query(
        'select e.code, e.lastName, e.firstName, e.email '
        'from employee e '
    ).then((rows) {
      print('selected all employees');
      rows.listen((row) {
        count++;
        print(
            'count: $count - '
            'code: ${row[0]}, '
            'last name: ${row[1]}, '
            'first name: ${row[2]}, '
            'email: ${row[3]}'
        );
      }).onDone(() => expect(count, equals(3)));
    });
  });

  test('Select Ridjanovic employees', () {
    pool.query(
        'select e.code, e.lastName, e.firstName, e.email '
        'from employee e '
        'where e.lastName = "Ridjanovic" '
    ).then((rows) {
      print('selected Ridjanovic employees');
      rows.listen((row) {
        expect(row[1], equals('Ridjanovic'));
        print(
            'code: ${row[0]}, '
            'last name: ${row[1]}, '
            'first name: ${row[2]}, '
            'email: ${row[3]}'
        );
      });
    });
  });

  test('Select all employees, then select Ridjanovic employees', () {
    var futures = new List<Future>();
    var completer = new Completer();
    futures.add(completer.future);
    var count = 0;

    pool.query(
        'select e.code, e.lastName, e.firstName, e.email '
        'from employee e '
    ).then((rows) {
      print('selected all employees');
      rows.listen((row) {
        count++;
        print(
            'count: $count - '
            'code: ${row[0]}, '
            'last name: ${row[1]}, '
            'first name: ${row[2]}, '
            'email: ${row[3]}'
        );
      }).onDone(() {
        expect(count, equals(3));
        completer.complete();
      });
    });

    Future.wait(futures).then((futures) {
      pool.query(
          'select e.code, e.lastName, e.firstName, e.email '
          'from employee e '
          'where e.lastName = "Ridjanovic" '
      ).then((rows) {
        print('selected Ridjanovic employees');
        rows.listen((row) {
          expect(row[1], equals('Ridjanovic'));
          print(
              'code: ${row[0]}, '
              'last name: ${row[1]}, '
              'first name: ${row[2]}, '
              'email: ${row[3]}'
          );
        });
      });
    });

  });

}

Future dropTables(ConnectionPool pool) {
  print('dropping tables');
  var dropper = new TableDropper(pool, ['task', 'employee']);
  return dropper.dropTables();
}

Future createTable(ConnectionPool pool) {
  print('creating employee table');
  var query = new QueryRunner(pool, [
    'create table employee ('
      'code varchar(64) not null, '
      'lastName varchar(32) not null, '
      'firstName varchar(32) not null, '
      'email varchar(64) not null, '
      'primary key (code) '
    ')'
  ]);
  return query.executeQueries();
}

Future initData(ConnectionPool pool) {
  print('initializing employee data');
  var completer = new Completer();
  pool.prepare(
    'insert into employee (code, lastName, firstName, email) values (?, ?, ?, ?)'
  ).then((query) {
    print('prepared query insert into employee');
    var data = [
      ['dzenanr@gmail.com', 'Ridjanovic', 'Dzenan', 'dzenanr@gmail.com'],
      ['timur.ridjanovic@gmail.com', 'Ridjanovic', 'Timur', 'timur.ridjanovic@gmail.com'],
      ['ma.seyer@gmail.com', 'Seyer', 'Marc-Antoine', 'ma.seyer@gmail.com']
    ];
    return query.executeMulti(data);
  }).then((results) {
    print('executed query insert into employee');
    completer.complete(results);
  });
  return completer.future;
}

Future emptyTable(ConnectionPool pool) {
  print('empting employee table');
  var query = new QueryRunner(pool, [
    'truncate employee'
  ]);
  return query.executeQueries();
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
  try {
    var pool = getPool(new OptionsFile('connection.options'));
    dropTables(pool)
      .then((_) => createTable(pool))
      .then((_) => initData(pool))
      .then((_) => testEmployees(pool))
      .catchError((e) => print(e));
  } catch(e) {
    print('consult README: $e');
  }
}