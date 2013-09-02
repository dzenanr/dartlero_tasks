part of dartlero_tasks;

class TasksModel extends ConceptModel {
  static const String PROJECT = 'Project';
  static const String EMPLOYEE = 'Employee';

  static TasksModel tasksModel;

  String persistence;
  String jsonDirPath;

  static TasksModel one() {
    if (tasksModel == null) {
      tasksModel = new TasksModel();
    }
    return tasksModel;
  }

  Map<String, ConceptEntities> newEntries() {
    var map = new Map<String, ConceptEntities>();
    var projects = new Projects();
    map[PROJECT] = projects;
    var employees = new Employees();
    map[EMPLOYEE] = employees;
    return map;
  }

  Projects get projects => getEntry(PROJECT);
  Employees get employees => getEntry(EMPLOYEE);

  init() {
    var project1 = new Project();
    project1.name = 'Learning Dart by Projects';
    project1.description = 'A book about Dart by Dzenan and Ivo';
    projects.add(project1);

    var employee1 = new Employee();
    employee1.firstName = 'Dzenan';
    employee1.lastName = 'Ridjanovic';
    employee1.email = 'dzenanr@gmail.com';
    employees.add(employee1);

    var employee2 = new Employee();
    employee2.firstName = 'Ivo';
    employee2.lastName = 'Balbaert';
    employee2.email = 'ivo.balbaert@telenet.be';
    employees.add(employee2);

    var task1 = new Task();
    task1.project = project1;
    task1.employee = employee1;
    task1.description = 'learn Dart and develop projects';
    project1.tasks.add(task1);
    employee1.tasks.add(task1);

    var task2 = new Task();
    task2.project = project1;
    task2.employee = employee2;
    task2.description = 'explain Dart and write about projects';
    project1.tasks.add(task2);
    employee2.tasks.add(task2);

    var project2 = new Project();
    project2.name = 'On Dart';
    project2.description = 'A web site for On Dart Education';
    projects.add(project2);

    var task3 = new Task();
    task3.project = project2;
    task3.employee = employee1;
    task3.description = 'prepare courses On Dart';
    project2.tasks.add(task3);
    employee1.tasks.add(task3);
  }

  clear() {
    var futures = new List<Future>();
    var completer = new Completer();
    futures.add(completer.future);

    for (var employee in employees) {
      for (var task in employee.tasks) {
        employee.tasks.remove(task);
      }
    }
    for (var project in projects) {
      for (var task in project.tasks) {
        project.tasks.remove(task);
      }
    }
    completer.complete();

    Future.wait(futures).then((futures) {
      for (var employee in employees) {
        employees.remove(employee);
      }
      for (var project in projects) {
        projects.remove(project);
      }
    });
  }

  saveToJson() {
    var employeesFilePath = '${jsonDirPath}/${EMPLOYEE}.json';
    var projectsFilePath = '${jsonDirPath}/${PROJECT}.json';
    File employeesFile = getFile(employeesFilePath);
    File projectsFile = getFile(projectsFilePath);
    addTextToFile(employeesFile, JSON.encode(employees.toJson()));
    addTextToFile(projectsFile, JSON.encode(projects.toJson()));
  }

 bool loadFromJson() {
    var employeesFilePath = '${jsonDirPath}/${EMPLOYEE}.json';
    var projectsFilePath = '${jsonDirPath}/${PROJECT}.json';
    File employeesFile = getFile(employeesFilePath);
    File projectsFile = getFile(projectsFilePath);
    String employeesFileText = readTextFromFile(employeesFile);
    String projectsFileText = readTextFromFile(projectsFile);
    if (employeesFileText.length > 0 && projectsFileText.length > 0) {
      List<Map<String, Object>> employeesList = JSON.decode(employeesFileText);
      List<Map<String, Object>> projectsList = JSON.decode(projectsFileText);
      employees.fromJson(employeesList);
      projects.fromJson(projectsList);
      for (var project in projects) {
        for (var task in project.tasks) {
          task.project = project;
        }
      }
      return true;
    } else {
      return false;
    }
  }

  Future loadFromMysql() {
    var completer = new Completer();
    try {
      ConnectionPool pool = getConnectionPool(new OptionsFile('connection.options'));
      // http://www.dartlang.org/articles/using-future-based-apis/
      Future.wait([loadFromMysqlEmployees(pool), loadFromMysqlProjects(pool)])
          .then((_) => loadFromMysqlTasks(pool))
          .then((_) => completer.complete(this))
          .catchError((e) => print('error in loading data from mysql db: ${e} '));
    } catch(e) {
      print('consult README: $e');
    }
    return completer.future;
  }

  Future loadFromMysqlEmployees(ConnectionPool pool) {
    var completer = new Completer();
    pool.query(
        'select e.lastName, e.firstName, e.email '
        'from employee e '
    ).then((rows) {
      print("employees");
      rows.stream.listen((row) {
        // String lastName = UTF8.decode(row[0]);
        String lastName = row[0];
        String firstName = row[1];
        String email = row[2];
        print(
            'last name: ${lastName}, '
            'first name: ${firstName}, '
            'email: ${email}'
        );
        var employee = new Employee();
        employee.lastName = lastName;
        employee.firstName = firstName;
        employee.email = email;
        if (!employees.add(employee, insert:false)) {
          print('problem in adding employee from the mysql db to the employees entry');
          print('last name: ${lastName}');
          print('first name: ${firstName}');
          print('email: ${email}');
        }
      });
      completer.complete(employees);
    });
    return completer.future;
  }

  Future loadFromMysqlProjects(ConnectionPool pool) {
    var completer = new Completer();
    pool.query(
        'select p.name, p.description '
        'from project p '
    ).then((rows) {
      print("projects");
      rows.stream.listen((row) {
        String name = row[0];
        String description = row[1];
        print(
            'name: ${name}, '
            'description: ${description}'
        );
        var project = new Project();
        project.name = name;
        project.description = UTF8.decode(description);
        if (!projects.add(project, insert:false)) {
          print('problem in adding project from the mysql db to the projects entry');
          print('name: ${name}');
          print('description: ${description}');
        }
      });
      completer.complete(projects);
    });
    return completer.future;
  }

  Future loadFromMysqlTasks(ConnectionPool pool) {
    var completer = new Completer();
    pool.query(
        'select t.projectCode, t.employeeCode, t.description '
        'from task t '
    ).then((rows) {
      print("tasks");
      rows.stream.listen((row) {
        String projectCode = row[0];
        String employeeCode = row[1];
        String description = row[2];
        print(
            'project code: ${projectCode}, '
            'employee code: ${employeeCode}, '
            'description: ${description}'
        );
        var task = new Task();
        task.description = description;
        Project project = projects.find(projectCode);
        if (project == null) {
          print('no project in the model with the following project code: ${projectCode}');
        } else {
          Employee employee = employees.find(employeeCode);
          if (employee == null) {
            print('no employee in the model with the following employee code: ${employeeCode}');
          } else {
            task.project = project;
            task.employee = employee;
            if (!project.tasks.add(task, insert:false)) {
              print('problem in adding task from the mysql db to the project tasks');
              print('project code: ${projectCode}');
              print('employee code: ${employeeCode}');
              print('description: ${description}');
            } else if (!employee.tasks.add(task, insert:false)) {
              print('problem in adding task from the mysql db to the employee tasks');
              print('project code: ${projectCode}');
              print('employee code: ${employeeCode}');
              print('description: ${description}');
            }
          }
        }
      });
      completer.complete(this);
    });
    return completer.future;
  }

  display() {
    print('===========');
    print('Tasks Model');
    print('===========');
    print('');
    print('model persistence: $persistence');
    print('');
    for (var project in projects) {
      print('  Project');
      print('  -------');
      print(project.toString());
      print('    Tasks');
      print('    -----');
      for (var task in project.tasks) {
        print(task.toString());
      }
    }
    print('===========');
    for (var employee in employees) {
      print('  Employee');
      print('  --------');
      print(employee.toString());
      print('    Tasks');
      print('    -----');
      for (var task in employee.tasks) {
        print(task.toString());
      }
    }
    print(
      '=========== =========== =========== '
      '=========== =========== =========== '
    );
  }
}



