part of dartlero_tasks;

class Task extends ConceptEntity<Task> { 
  Project _project;
  Employee _employee;
  String description;
  
  Project get project => _project;
  set project(Project project) {
    _project = project;
    if (employee != null) {
      code = '${project.code}-${employee.code}';
    }
  }
  
  Employee get employee => _employee;
  set employee(Employee employee) {
    _employee = employee;
    if (project != null) {
      code = '${project.code}-${employee.code}';
    }
  }
  
  Task newEntity() => new Task();
  
  String toString() {
    return '    {\n'
           '      project.name: ${project.name}\n'
           '      employee.email: ${employee.email}\n'
           '      description: ${description}\n'
           '    }\n';
  }
  
  Map<String, Object> toJson() {
    Map<String, Object> entityMap = new Map<String, Object>();
    entityMap['project'] = project.code;
    entityMap['employee'] = employee.code;
    entityMap['description'] = description;
    return entityMap;
  }

  fromJson(Map<String, Object> entityMap) {
    String projectCode = entityMap['project'];
    String employeeCode = entityMap['employee'];
    project = TasksModel.one().projects.find(projectCode);
    employee = TasksModel.one().employees.find(employeeCode);
    description = entityMap['description'];
    employee.tasks.add(this);
  }
}

class Tasks extends ConceptEntities<Task> {
  Tasks newEntities() => new Tasks();
  Task newEntity() => new Task();
}

