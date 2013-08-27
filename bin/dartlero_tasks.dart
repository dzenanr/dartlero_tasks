import 'dart:io';
import 'package:dartlero_tasks/dartlero_tasks.dart';

void main() {
  var model = TasksModel.one();
  Options options = new Options();
  List<String> args = options.arguments;
  try {
    if (args.length == 2 && (args[0] == '--dir')) {
      // --dir C:/Users/ridjanod/git/db/dartlero_tasks/json_data
      // --dir /home/dr/git/db/dartlero_tasks/json_data
      model.persistence = 'json';
      model.jsonDirPath = args[1];
      if (!model.loadFromJson()) {
        model.init();
        model.saveToJson();
      }
      model.display();
    } else if (args.length == 1 && (args[0] == '--mysql')) {
      // --mysql
      model.persistence = 'mysql';
      model.loadFromMysql().then((m) {
        m.display();

        Employee employee = new Employee();
        employee.lastName = 'Nelson';
        employee.firstName = 'Robert';
        employee.email = 'robert.nelson@gmail.com';
        m.employees.add(employee);

        Project project = new Project();
        project.name = 'Bas Canada';
        project.description = "Le Bas-Canada était une province de l'Empire britannique, créée en 1791 par l'Acte constitutionnel.";
        m.projects.add(project);

        Task task = new Task();
        task.employee = employee;
        task.project = project;
        task.description = "Promouvoir la musique du Bas Canada";
        employee.tasks.add(task, insert:false);
        project.tasks.add(task);
      });
    } else {
      print('No arguments: see README');
    }
  } catch (e) {
    print('consult README: $e');
  }
}
