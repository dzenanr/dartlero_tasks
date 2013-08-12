
# Tasks application with dartlero model, JSON files, MySQL database

**Categories**: education, class models, many-to-many relationships,
JSON data files, MySQL database.

**Concepts**: Project, Employee, Task.

**Description**:
A model example with a [many-to-many relationship]
(https://docs.google.com/document/d/1OOYUa5wX6IjGIBD1KuSEpec1p_unIbzE4JFvPL5ULxA/edit?usp=sharing)
between Project and Employee.

**Start**:
Clone the project and open it with Dart Editor.

In the Run/Manage Launches of Dart Editor, enter two arguments (--dir & path)
in the dartlero_tasks.dart command-line launch:

--dir path

Example:

--dir C:/Users/ridjanod/git/dart/educ
--dir /home/dr/git/dartlero

By running the main function in the bin/dartlero_tasks.dart file, a model,
with two entry points, will be initialized (and saved) in the given directory.
For each entry concept, a file with the concept name and the json extension
will be created. The next time, data from the two files will be loaded.

You may open a file with a text editor. Use a
[JSON pretty-printer] (http://jsonformatter.curiousconcept.com/)
to examine the json document.

If you want to use MySQL instead, do not use arguments
in the Run/Manage Launches of Dart Editor.







