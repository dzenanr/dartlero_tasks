import 'package:unittest/unittest.dart';
import 'package:dartlero/dartlero.dart';
import 'package:dartlero_tasks/dartlero_tasks.dart';

testProjects() {
  var model = TasksModel.one();
  model.persistence = 'mysql';
  Projects projects = model.projects;
  var modelibra = 'Modelibra';
  group("Testing Projects", () {
    test('Add project', () {
      var project = new Project();
      expect(project, isNotNull);
      project.name = modelibra;
      project.description = 'domain model framework in Java';
      var added = projects.add(project);
      expect(added, isTrue);
      projects.display('Add project');
    });
    test('Update project', () {
      var project = projects.find(modelibra);
      expect(project, isNotNull);
      project.description = 'domain model framework in Java used in education';
      projects.display('Update project');
    });
    
  });
}

main() {
  testProjects();
}

