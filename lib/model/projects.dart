part of dartlero_tasks;

class Project extends ConceptEntity<Project> {
  String _name;
  String _description;
  Tasks tasks = new Tasks();

  String get name => _name;
  set name(String name) {
    _name = name;
    if (code == null) {
      code = name;
    }
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
            'update project '
            'set project.description="${description}" '
            'where project.code="${code}" '
        ).then((x) {
          print(
              'project.description updated: '
              'code: ${code}, '
              'name: ${name}, '
              'old description: ${oldDescription}, '
              'description: ${description}'
          );
        }, onError:(e) => print(
            'project.description not updated: ${e} -- '
            'code: ${code}, '
            'name: ${name}, '
            'old description: ${oldDescription}, '
            'description: ${description}'
        ));
      } // if (model.persistence == 'mysql') {
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
      String utf8Description = codepointsToString(encodeUtf8(project.description));
      if (insert) {
        var model = TasksModel.one();
        if (model.persistence == 'mysql') {
          ConnectionPool pool = getConnectionPool(new OptionsFile('connection.options'));
          pool.query(
              'insert into project '
              '(code, name, description)'
              'values'
              '("${project.code}", "${project.name}", "${utf8Description}")'
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
        } // if (model.persistence == 'mysql') {
      } // if (insert) {
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

  bool remove(Project project, {bool delete:true}) {
    if (super.remove(project)) {
      if (delete) {
        var model = TasksModel.one();
        if (model.persistence == 'mysql') {
          ConnectionPool pool =
              getConnectionPool(new OptionsFile('connection.options'));
          pool.query(
              'delete from project '
              'where project.code="${project.code}" '
          ).then((x) {
            print(
                'project deleted: '
                'code: ${project.code}, '
                'name: ${project.name}, '
                'email: ${project.description}'
            );
          }, onError:(e) => print(
              'project not deleted: ${e} -- '
              'code: ${project.code}, '
              'name: ${project.name}, '
              'email: ${project.description}'
          ));
        } // if (model.persistence == 'mysql') {
      } // if (delete) {
      return true;
    } else {
      print(
          'project not removed: '
          'code: ${project.code}, '
          'name: ${project.name}, '
          'email: ${project.description}'
      );
      return false;
    }
  }

}

