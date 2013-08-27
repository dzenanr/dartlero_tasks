import 'package:unittest/unittest.dart';
import 'package:dartlero/dartlero.dart';
import 'package:dartlero_tasks/dartlero_tasks.dart';

testTasks() {
  var model = TasksModel.one();
  model.persistence = 'mysql';
  Employees employees = model.employees;
  Projects projects = model.projects;
  var dzenan = 'dzenanr@gmail.com';
  var modelibra = 'Modelibra';
  group('Testing Tasks', () {
    test('Add task', () {
      var employee = new Employee();
      expect(employee, isNotNull);
      employee.lastName = 'Ridjanovic';
      employee.firstName = 'Dzenan';
      employee.email = dzenan;
      var added = employees.add(employee);
      expect(added, isTrue);
      employees.display('Add employee');
      
      var project = new Project();
      expect(project, isNotNull);
      project.name = modelibra;
      project.description = 'domain model framework in Java';
      added = projects.add(project);
      expect(added, isTrue);
      projects.display('Add project');
      
      var task = new Task();
      expect(task, isNotNull);
      task.employee = employee;
      task.project = project;
      task.description = 'write a paper';
      added = employee.tasks.add(task);
      expect(added, isTrue);
      employee.tasks.display('Add employee task');
      added = project.tasks.add(task);
      expect(added, isTrue);
      project.tasks.display('Add project task');
    });
  });
}

main() {
  testTasks();
}

