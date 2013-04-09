import 'dart:io';
import 'package:dartlero_tasks/dartlero_tasks.dart';

void main() {
  var model = TasksModel.one();
 
  Options options = new Options();
  List<String> args = options.arguments;
  if (args.length == 2 && (args[0] == '--dir')) {
    // --dir C:/Users/ridjanod/git/dart/educ
    model.persistence = 'json';
    model.jsonDirPath = args[1];
    if (!model.loadFromJson()) {
      model.init();
    }
    model.display();
  } else {
    model.persistence = 'mysql';
    model.loadFromMysql().then((m) => m.display());
  }
}
