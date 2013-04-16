import 'dart:async';

import 'package:unittest/unittest.dart';
import 'package:dartlero/dartlero.dart';
import 'package:dartlero_tasks/dartlero_tasks.dart';

testEmployees() {
  var model = TasksModel.one();
  model.persistence = 'mysql';
  Employees employees = model.employees;
  var amra = 'acr@gmail.com';
  var ogden = 'ogdenr@gmail.com';
  group("Testing Employees", () {
    test('Add employee', () {
      var employee = new Employee();
      expect(employee, isNotNull);
      employee.lastName = 'Curovac Ridjanovic';
      employee.firstName = 'Amra';
      employee.email = amra;
      var added = employees.add(employee);
      expect(added, isTrue);
      employees.display('Add employee');
    });
    test('Update employee', () {
      var employee = employees.find(amra);
      expect(employee, isNotNull);
      employee.email = 'amra.ridjanovic@gmail.com';
      employees.display('Update employee');
    });
    test('Add employee, remove employee', () {
      var futures = new List<Future>();
      var completer = new Completer();
      futures.add(completer.future);

      var employee = new Employee();
      expect(employee, isNotNull);
      employee.lastName = 'Ridjanovic';
      employee.firstName = 'Ogden';
      employee.email = ogden;
      var added = employees.add(employee);
      expect(added, isTrue);
      if (added) {
        completer.complete(null);
      }

      Future.wait(futures).then((futures) {
        employee = employees.find(ogden);
        expect(employee, isNotNull);
        employees.remove(employee);
        employees.display('Add employee, remove employee');
      });
    });
    
  });
}

main() {
  testEmployees();
}

