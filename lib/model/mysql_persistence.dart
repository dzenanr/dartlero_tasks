part of dartlero_tasks;

// https://github.com/jamesots/sqljocky

ConnectionPool getConnectionPool(OptionsFile options) {
  print("getting connection options");
  String user = options.getString('user');
  String password = options.getString('password');
  int port = options.getInt('port', 3306);
  String db = options.getString('db');
  String host = options.getString('host', 'localhost');
  return new ConnectionPool(
      host: host, port: port, user: user, password: password, db: db);
}



