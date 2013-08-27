import 'package:sqljocky/sqljocky.dart';
import 'package:sqljocky/utils.dart';
import 'package:options_file/options_file.dart';
import 'dart:async';

/*
 * This example drops the employee table if it exists, before recreating it.
 * It then stores several employees in the database and reads them back.
 * You must have a connection.options file in order for this to connect.
 */

class Example {
  ConnectionPool pool;

  Example(this.pool);
  
  Future run() {
    var completer = new Completer();
    // the following works
    dropTables().then((_) {
      print("dropped tables");
      createTables().then((_) {   
        print("created tables");
        addData().then((_) {
          readData();
          completer.complete();
        }); 
      });
    });
    return completer.future;
  }

  /*
  Future run() {
    var completer = new Completer();
    // the following does not work
    dropTables().then((_) {
      print("dropped tables");
      createTables().then((_) {   
        print("created tables");
        addData(); 
      }).then((_) {
        readData();
        completer.complete();
      });
    });
    return completer.future;
  }
  */
  
  /*
  Future run() {
    var completer = new Completer();
    // the following does not work
    dropTables().then((_) {
      createTables();
    }).then((_) {   
      addData(); 
    }).then((_) {
      readData();
      completer.complete();
    });
    return completer.future;
  }
  */

  /*
  Future run() {
    var completer = new Completer();
    // the following does not work
    dropTables().then((_) {
      print("dropped tables");
    }).then((_) {
      createTables();
      print("created tables");
    }).then((_) {
      addData();
    }).then((_) {
      readData();
      completer.complete();
    });
    return completer.future;
  }
  */
 
  /*
  Future run() {
    var completer = new Completer();
    // the following works
    // drop the tables if they already exist
    dropTables().then((_) {
      print("dropped tables");
      // then recreate the tables
      return createTables();
    }).then((_) {
      print("created tables");
      // add some data
      return addData();
    }).then((_) {
      // and read it back out
      return readData();
    }).then((_) {
      completer.complete();
    });
    return completer.future;
  }
  */

  Future dropTables() {
    print("dropping tables");
    var dropper = new TableDropper(pool, ['task', 'employee']);
    return dropper.dropTables();
  }

  Future createTables() {
    print("creating tables");
    var querier = new QueryRunner(pool,
        [
         'create table employee '
         '('
           'code varchar(64) not null, '
           'lastName varchar(32) not null, '
           'firstName varchar(32) not null, '
           'email varchar(64) not null, '
           'primary key (code) '
         ')'
        ]);
    print("executing queries");
    return querier.executeQueries();
  }

  Future addData() {
    var completer = new Completer();
    pool.prepare(
        "insert into employee (code, lastName, firstName, email) values (?, ?, ?, ?)"
        ).then((query) {
      print("prepared query insert into employee");
      var parameters = [
          ["dzenanr@gmail.com", "Ridjanovic", "Dzenan", "dzenanr@gmail.com"],
          ["timur.ridjanovic@gmail.com", "Ridjanovic", "Timur", "timur.ridjanovic@gmail.com"],
          ["ma.seyer@gmail.com", "Seyer", "Marc-Antoine", "ma.seyer@gmail.com"]
        ];
      return query.executeMulti(parameters);
    }).then((results) {
      print("executed query insert into employee");
      completer.complete();
    });
    return completer.future;
  }

  Future readData() {
    var completer = new Completer();
    print("querying employees");
    pool.query(
        'select e.lastName, e.firstName, e.email '
        'from employee e '
        ).then((rows) {
      print("got results");
      rows.stream.listen((row) {
        print("Last Name: ${row[0]}, First Name: ${row[1]}, Email: ${row[2]}");
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
    print("opening connection");
    var pool = new ConnectionPool(host: host, port: port, user: user, password: password, db: db);
    print("connection open");
    // create an example class
    var example = new Example(pool);
    // run the example
    print("running example");
    example.run().then((_) {
      // finally, close the connection
      print("bye");
      pool.close();
    });
  } catch(e) {
    print('consult README: $e');
  }
}

