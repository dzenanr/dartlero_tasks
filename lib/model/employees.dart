part of dartlero_tasks;

class Employee extends ConceptEntity<Employee> {
  String lastName;
  String firstName;
  String _email;
  Tasks tasks = new Tasks();

  String get email => _email;
  set email(String email) {
    String oldEmail = _email;
    _email = email;
    if (code == null) {
      code = email;
    }
    if (oldEmail != null) {
      var model = TasksModel.one();
      if (model.persistence == 'mysql') {
        ConnectionPool pool =
            getConnectionPool(new OptionsFile('connection.options'));
        pool.query(
            'update employee '
            'set employee.email="${email}" '
            'where employee.code="${code}" '
        ).then((x) {
          print(
              'employee.email updated: '
              'code: ${code}, '
              'last name: ${lastName}, '
              'first name: ${firstName}, '
              'old email: ${oldEmail}, '
              'email: ${email}'
          );
        }, onError:(e) => print(
            'employee.email not updated: ${e} -- '
            'code: ${code}, '
            'last name: ${lastName}, '
            'first name: ${firstName}, '
            'old email: ${oldEmail}, '
            'email: ${email}'
        ));
      } // if (model.persistence == 'mysql') {
    }
  }

  Employee newEntity() => new Employee();

  String toString() {
    return '  {\n'
           '    code: ${code}\n'
           '    firstName: ${firstName}\n'
           '    lastName: ${lastName}\n'
           '    email: ${email}\n'
           '  }\n';
  }

  Map<String, Object> toJson() {
    Map<String, Object> entityMap = new Map<String, Object>();
    entityMap['code'] = code;
    entityMap['lastName'] = lastName;
    entityMap['firstName'] = firstName;
    entityMap['email'] = email;
    return entityMap;
  }

  fromJson(Map<String, Object> entityMap) {
    code = entityMap['code'];
    lastName = entityMap['lastName'];
    firstName = entityMap['firstName'];
    email = entityMap['email'];
  }

}

class Employees extends ConceptEntities<Employee> {
  Employees newEntities() => new Employees();
  Employee newEntity() => new Employee();

  bool add(Employee employee, {bool insert:true}) {
    if (super.add(employee)) {
      if (insert) {
        var model = TasksModel.one();
        if (model.persistence == 'mysql') {
          ConnectionPool pool = getConnectionPool(new OptionsFile('connection.options'));
          pool.query(
              'insert into employee '
              '(code, lastName, firstName, email)'
              'values'
              '("${employee.code}", "${employee.lastName}", "${employee.firstName}", "${employee.email}")'
          ).then((x) {
            print(
                'employee inserted: '
                'code: ${employee.code}, '
                'last name: ${employee.lastName}, '
                'first name: ${employee.firstName}, '
                'email: ${employee.email}'
            );
          }, onError:(e) => print(
              'employee not inserted: ${e} -- '
              'code: ${employee.code}, '
              'last name: ${employee.lastName}, '
              'first name: ${employee.firstName}, '
              'email: ${employee.email}'
          ));
        } // if (model.persistence == 'mysql') {
      } // if (insert) {
      return true;
    } else {
      print(
          'employee not added: '
          'code: ${employee.code}, '
          'last name: ${employee.lastName}, '
          'first name: ${employee.firstName}, '
          'email: ${employee.email}'
      );
      return false;
    }
  }

  bool remove(Employee employee, {bool delete:true}) {
    if (super.remove(employee)) {
      if (delete) {
        var model = TasksModel.one();
        if (model.persistence == 'mysql') {
          ConnectionPool pool =
              getConnectionPool(new OptionsFile('connection.options'));
          pool.query(
              'delete from employee '
              'where employee.code="${employee.code}" '
          ).then((x) {
            print(
                'employee deleted: '
                'code: ${employee.code}, '
                'last name: ${employee.lastName}, '
                'first name: ${employee.firstName}, '
                'email: ${employee.email}'
            );
          }, onError:(e) => print(
              'employee not deleted: ${e} -- '
              'code: ${employee.code}, '
              'last name: ${employee.lastName}, '
              'first name: ${employee.firstName}, '
              'email: ${employee.email}'
          ));
        } // if (model.persistence == 'mysql') {
      } // if (delete) {
      return true;
    } else {
      print(
          'employee not removed: '
          'code: ${employee.code}, '
          'last name: ${employee.lastName}, '
          'first name: ${employee.firstName}, '
          'email: ${employee.email}'
      );
      return false;
    }
  }

}

