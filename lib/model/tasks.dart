part of dartlero_tasks;

class Task extends ConceptEntity<Task> { 
  Project _project;
  Employee _employee;
  String description;
  
  Project get project => _project;
  set project(Project project) {
    _project = project;
    if (code == null && employee != null) {
      code = '${project.code}-${employee.code}';
    }
  }
  
  Employee get employee => _employee;
  set employee(Employee employee) {
    _employee = employee;
    if (code == null && project != null) {
      code = '${project.code}-${employee.code}';
    }
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
    entityMap['project'] = project.code;
    entityMap['employee'] = employee.code;
    entityMap['description'] = description;
    return entityMap;
  }

  fromJson(Map<String, Object> entityMap) {
    code = entityMap['code'];
    description = entityMap['description'];
    String projectCode = entityMap['project'];
    String employeeCode = entityMap['employee'];
    // within a specific project, but we do not know which one!
    employee = TasksModel.one().employees.find(employeeCode);  
    if (employee != null) {
      employee.tasks.add(this);
    } else {
      print('employee is null');
    }
  }
}

class Tasks extends ConceptEntities<Task> {
  Tasks newEntities() => new Tasks();
  Task newEntity() => new Task();
}

