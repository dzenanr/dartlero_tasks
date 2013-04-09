part of dartlero_tasks;

// http://www.dartlang.org/articles/io/

Directory getDir(String path) {
  var dir = new Directory(path);
  if (dir.existsSync()) {
    print('directory ${path} exists already');
  } else {
    dir.createSync();
    print('directory created: ${path}');
  }
  return dir;
}

File getFile(String path) {
  File file = new File(path);
  if (file.existsSync()) {
    print('file ${path} exists already');
  } else {
    file.createSync();
    print('file created: ${path}');
  }
  return file;
}

addTextToFile(File file, String text) {
  IOSink<File> writeSink = file.openWrite();
  writeSink.write(text);
  writeSink.close();
}

String readTextFromFile(File file) {
  String fileText = file.readAsStringSync();
  return fileText;
}









