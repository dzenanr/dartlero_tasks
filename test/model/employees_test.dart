import 'dart:async';

import 'package:unittest/unittest.dart';
import 'package:dartlero/dartlero.dart';
import 'package:dartlero_tasks/dartlero_tasks.dart';

testEmployees() {
  var model = TasksModel.one();
  model.persistence = 'mysql';
  Employees employees = model.employees;
  var robert = 'rwm@gmail.com';
  var ogden = 'ogdenr@gmail.com';
  var anne = 'anned@gmail.com';
  group('Testing Employees', () {
    test('Add employee', () {
      var employee = new Employee();
      expect(employee, isNotNull);
      employee.lastName = 'Mantha';
      employee.firstName = 'Robert';
      employee.email = robert;
      var added = employees.add(employee);
      expect(added, isTrue);
      employees.display('Add employee');
    });
    test('Update employee', () {
      var employee = employees.find(robert);
      expect(employee, isNotNull);
      var email = 'robert.mantha@gmail.com';
      employee.email = email;
      expect(employee.email, equals(email));
      employees.display('Update employee');
    });
    test('Add employee, update employee, remove employee', () {
      var employee = new Employee();
      expect(employee, isNotNull);
      employee.lastName = 'Daneault';
      employee.firstName = 'Anne';
      employee.email = anne;
      var added = employees.add(employee);
      expect(added, isTrue);

      var name = 'Anne Marie';
      employee.firstName = 'Anne Marie';
      expect(employee.firstName, equals(name));

      var length = employees.length;
      employees.remove(employee);
      expect(employees.length, equals(--length));

      employees.display('Add employee, update employee, remove employee');
    });
    test('Add employee, remove employee with future', () {
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
        completer.complete();
      }

      Future.wait(futures).then((futures) {
        employee = employees.find(ogden);
        expect(employee, isNotNull);
        var length = employees.length;
        employees.remove(employee);
        expect(employees.length, equals(--length));
        employees.display('Add employee, remove employee');
      });
    });
  });
}

main() {
  testEmployees();
}

