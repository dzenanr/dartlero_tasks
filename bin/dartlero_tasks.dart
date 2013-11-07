import 'package:dartlero_tasks/dartlero_tasks.dart';

void main(List<String> arguments) {
  var model = TasksModel.one();
  try {
    if (arguments.length == 2 && (arguments[0] == '--dir')) {
      model.persistence = 'json';
      model.jsonDirPath = arguments[1];
      if (!model.loadFromJson()) {
        model.init();
        model.saveToJson();
      }
      model.display();
    } else if (arguments.length == 1 && (arguments[0] == '--mysql')) {
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
        m.associations.add(project);

        Task task = new Task();
        task.employee = employee;
        task.project = project;
        task.description = 'Promouvoir la musique du Bas Canada';
        employee.tasks.add(task, insert:false);
        project.tasks.add(task);
      });
    } else {
      print('No arguments: consult README');
    }
  } catch (e) {
    print('consult README: $e');
  }
}
