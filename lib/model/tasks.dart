part of dartlero_tasks;

class Task extends ConceptEntity<Task> {
  Project _project;
  Employee _employee;
  String _description;

  Project get project => _project;
  set project(Project project) {
    Project oldProject = _project;
    _project = project;
    if (code == null && employee != null) {
      code = '${project.code}-${employee.code}';
    }
    if (oldProject != null) {
      var model = TasksModel.one();
      if (model.persistence == 'mysql') {
        ConnectionPool pool =
            getConnectionPool(new OptionsFile('connection.options'));
        pool.query(
            'update task '
            'set task.projectCode="${project.code}" '
            'where task.code="${code}" '
        ).then((x) {
          print(
              'task.projectCode updated: '
              'code: ${code}, '
              'project old code: ${oldProject.code}, '
              'project code: ${project.code}, '
              'employee code: ${employee.code}, '
              'description: ${description}'
          );
        }, onError:(e) => print(
            'task.projectCode not updated: ${e} -- '
            'code: ${code}, '
            'project old code: ${oldProject.code}, '
            'project code: ${project.code}, '
            'employee code: ${employee.code}, '
            'description: ${description}'
        ));
      } // if (model.persistence == 'mysql') {
    } // if (oldProject != null) {
  }

  Employee get employee => _employee;
  set employee(Employee employee) {
    Employee oldEmployee = _employee;
    _employee = employee;
    if (code == null && project != null) {
      code = '${project.code}-${employee.code}';
    }
    if (oldEmployee != null) {
      var model = TasksModel.one();
      if (model.persistence == 'mysql') {
        ConnectionPool pool =
            getConnectionPool(new OptionsFile('connection.options'));
        pool.query(
            'update task '
            'set task.employeeCode="${employee.code}" '
            'where task.code="${code}" '
        ).then((x) {
          print(
              'task.employeeCode updated: '
              'code: ${code}, '
              'project code: ${project.code}, '
              'employee old code: ${oldEmployee.code}, '
              'employee code: ${employee.code}, '
              'description: ${description}'
          );
        }, onError:(e) => print(
            'task.employeeCode not updated: ${e} -- '
            'code: ${code}, '
            'project code: ${project.code}, '
            'employee old code: ${oldEmployee.code}, '
            'employee code: ${employee.code}, '
            'description: ${description}'
        ));
      } // if (model.persistence == 'mysql') {
    } // if (oldProject != null) {
  }

  String get description => _description;
  set description(String description) {
    String oldDescription = _description;
    _description = description;
    if (oldDescription != null) {
      var model = TasksModel.one();
      if (model.persistence == 'mysql') {
        ConnectionPool pool =
            getConnectionPool(new OptionsFile('connection.options'));
        pool.query(
            'update task '
            'set task.description="${description}" '
            'where task.code="${code}" '
        ).then((x) {
          print(
              'task.description updated: '
              'code: ${code}, '
              'project code: ${project.code}, '
              'employee code: ${employee.code}, '
              'old description: ${oldDescription}, '
              'description: ${description}'
          );
        }, onError:(e) => print(
            'task.description not updated: ${e} -- '
            'code: ${code}, '
            'project code: ${project.code}, '
            'employee code: ${employee.code}, '
            'old description: ${oldDescription}, '
            'description: ${description}'
        ));
      } // if (model.persistence == 'mysql') {
    } // if (oldDescription != null) {
  }

  Task newEntity() => new Task();

  String toString() {
    return '    {\n'
           '      code: ${code}\n'
           '      project.name: ${project.name}\n'
           '      employee.email: ${employee.email}\n'
           '      description: ${description}\n'
           '    }\n';
  }

  Map<String, Object> toJson() {
    Map<String, Object> entityMap = new Map<String, Object>();
    entityMap['code'] = code;
    entityMap['employee'] = employee.code;
    entityMap['description'] = description;
    return entityMap;
  }

  fromJson(Map<String, Object> entityMap) {
    code = entityMap['code'];
    description = entityMap['description'];
    String employeeCode = entityMap['employee'];
    employee = TasksModel.one().employees.find(employeeCode);
    employee.tasks.add(this);
    // see TasksModel.load() where each task is linked to its project
  }
}

class Tasks extends ConceptEntities<Task> {
  Tasks newEntities() => new Tasks();
  Task newEntity() => new Task();

  bool add(Task task, {bool insert:true}) {
    if (super.add(task)) {
      if (insert) {
        var model = TasksModel.one();
        if (model.persistence == 'mysql') {
          ConnectionPool pool =
              getConnectionPool(new OptionsFile('connection.options'));
          pool.query(
              'insert into task '
              '(code, projectCode, employeeCode, description)'
              'values'
              '("${task.code}", "${task.project.code}", "${task.employee.code}", "${task.description}")'
          ).then((x) {
            print(
                'task inserted: '
                'code: ${task.code}, '
                'project code: ${task.project.code}, '
                'employee code: ${task.employee.code}, '
                'description: ${task.description}'
            );
          }, onError:(e) => print(
              'task not inserted: ${e} -- '
              'code: ${task.code}, '
              'project code: ${task.project.code}, '
              'employee code: ${task.employee.code}, '
              'description: ${task.description}'
          ));
        } // if (model.persistence == 'mysql') {
      } // if (insert) {
      return true;
    } else {
      print(
          'task not added: '
          'code: ${task.code}, '
          'project code: ${task.project.code}, '
          'employee code: ${task.employee.code}, '
          'description: ${task.description}'
      );
      return false;
    }
  }

  bool remove(Task task, {bool delete:true}) {
    if (super.remove(task)) {
      if (delete) {
        var model = TasksModel.one();
        if (model.persistence == 'mysql') {
          ConnectionPool pool =
              getConnectionPool(new OptionsFile('connection.options'));
          pool.query(
              'delete from task '
              'where task.code="${task.code}" '
          ).then((x) {
            print(
                'task deleted: '
                'code: ${task.code}, '
                'project code: ${task.project.code}, '
                'employee code: ${task.employee.code}, '
                'description: ${task.description}'
            );
          }, onError:(e) => print(
              'task not deleted: ${e} -- '
              'code: ${task.code}, '
              'project code: ${task.project.code}, '
              'employee code: ${task.employee.code}, '
              'description: ${task.description}'
          ));
        } // if (model.persistence == 'mysql') {
      } // if (delete) {
      return true;
    } else {
      print(
          'task not removed: '
          'code: ${task.code}, '
          'project code: ${task.project.code}, '
          'employee code: ${task.employee.code}, '
          'description: ${task.description}'
      );
      return false;
    }
  }

}

