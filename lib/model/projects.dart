part of dartlero_tasks;

class Project extends ConceptEntity<Project> {
  String _name;
  String description;
  Tasks tasks = new Tasks();
  
  String get name => _name;
  set name(String name) {
    _name = name;
    code = name;
  }
  
  Project newEntity() => new Project();
  
  String toString() {
    return '  {\n'
           '    name: ${name}\n'
           '    description: ${description}\n'
           '  }\n';
  }
  
  Map<String, Object> toJson() {
    Map<String, Object> entityMap = new Map<String, Object>();
    entityMap['name'] = name;
    entityMap['description'] = description;
    entityMap['tasks'] = tasks.toJson();
    return entityMap;
  }

  fromJson(Map<String, Object> entityMap) {
    name = entityMap['name'];
    description = entityMap['description'];
    tasks.fromJson(entityMap['tasks']);
  }
}

class Projects extends ConceptEntities<Project> {
  Projects newEntities() => new Projects();
  Project newEntity() => new Project();
}

