import 'dart:io';
import 'package:dartlero_tasks/dartlero_tasks.dart';

void main() {
  Options options = new Options();
  // --dir C:/Users/ridjanod/git/dart/educ
  List<String> args = options.arguments;
  if (args.length == 2 && (args[0] == '--dir')) {
    var model = TasksModel.one();
    model.jsonDirPath = args[1];
    model.init();
    model.save();
    model.display();
  } else {
    print('arguments are not entered properly in Run/Manage Launches of Dart Editor');
  }
}
