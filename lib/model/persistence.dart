part of dartlero_tasks;

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

addText(File file, String text) {
  IOSink<File> writeSink = file.openWrite();
  writeSink.addString(text);
  writeSink.close();
}



