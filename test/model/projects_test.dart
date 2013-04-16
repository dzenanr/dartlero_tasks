import 'package:unittest/unittest.dart';
import 'package:dartlero/dartlero.dart';
import 'package:dartlero_tasks/dartlero_tasks.dart';

testProjects() {
  var model = TasksModel.one();
  Projects projects = model.projects;
  group("Testing Projects", () {
    setUp(() {

    });
    tearDown(() {
      //tasks.clear();
      //expect(tasks.isEmpty, isTrue);
    });
    test('Add task', () {
      /*
      var task = new Project();
      expect(project, isNotNull);
      project.name = 'modelibra';
      project.description = 'domain model framework for educational purposes';
      var added = projects.add(project);
      expect(added, isTrue);
      projects.display('Add Project');
      */
    });
  });
}

main() {
  testProjects();
}

