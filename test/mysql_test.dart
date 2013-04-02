import 'package:sqljocky/sqljocky.dart';
import 'package:unittest/unittest.dart';
import 'package:dartlero/dartlero.dart';
import 'package:dartlero_tasks/dartlero_tasks.dart';
import 'dart:async';

ConnectionPool pool;

Future<List<Results>> addEmployees(Query query) {
  Future<List<Results>> results = query.executeMulti(
      [
        [1, 'Dzenan', 'Ridjanovic', 'dzenanr@gmail.com'],
        [2, 'Timur', 'Ridjanovic', 'timur.ridjanovic@gmail.com']
      ]);
  return results;
}

printResults(List<Results> results) {
  for (var result in results) {
    print("New employee's id: ${result.insertId}");
  }
}

main() {
  pool = new ConnectionPool(host: 'localhost', port: 3306, user: 'dr', password: 'dr', db: 'test', max: 5);
  Future<Query> prepared = pool.prepare('insert into Employee (idEmployee, firstName, lastName, email) values (?, ?, ?, ?)');
  Future<List<Results>> added = prepared.
      then((query) {addEmployees(query);}).
      catchError((error) {print(error);})
      ;
  added.
      then((results) {printResults(results);}).
      catchError((error) {print(error);})
      ;
}

