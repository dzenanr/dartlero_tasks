part of dartlero_tasks;

class Project extends ConceptEntity<Project> {
  String _name;
  String description;
  Tasks tasks = new Tasks();

  String get name => _name;
  set name(String name) {
    _name = name;
    if (code == null) {
      code = name;
    }
  }

  Project newEntity() => new Project();

  String toString() {
    return '  {\n'
           '    code: ${code}\n'
           '    name: ${name}\n'
           '    description: ${description}\n'
           '  }\n';
  }

  Map<String, Object> toJson() {
    Map<String, Object> entityMap = new Map<String, Object>();
    entityMap['code'] = code;
    entityMap['name'] = name;
    entityMap['description'] = description;
    entityMap['tasks'] = tasks.toJson();
    return entityMap;
  }

  fromJson(Map<String, Object> entityMap) {
    code = entityMap['code'];
    name = entityMap['name'];
    description = entityMap['description'];
    tasks.fromJson(entityMap['tasks']);
  }
}

class Projects extends ConceptEntities<Project> {
  Projects newEntities() => new Projects();
  Project newEntity() => new Project();
  
  bool add(Project project, {bool insert:true}) {
    if (super.add(project)) {
      var model = TasksModel.one();
      if (model.persistence == 'mysql') {
        if (insert) {
          ConnectionPool pool = getConnectionPool(new OptionsFile('connection.options'));
          pool.query(
              'insert into project '
              '(code, name, description)'
              'values'
              '("${project.code}", "${project.name}", "${project.description}")'
          ).then((x) {
            print(
                'project inserted: '
                'code: ${project.code}, '
                'name: ${project.name}, '
                'email: ${project.description}'
            );
          }, onError:(e) => print(
              'project not inserted: ${e} -- '
              'code: ${project.code}, '
              'name: ${project.name}, '
              'email: ${project.description}'
          ));
        }
      }
      return true;
    } else {
      print(
          'project not added: '
          'code: ${project.code}, '
          'name: ${project.name}, '
          'email: ${project.description}'
      );
      return false;
    }
  }
  
}

