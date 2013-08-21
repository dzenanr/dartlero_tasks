
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

**JSON Files**

In the Run/Manage Launches of Dart Editor, enter two script arguments
(--dir & path) in the bin/dartlero_tasks.dart command-line launch:

--dir path

Example:

--dir C:/Users/ridjanod/git/dartlero/dartlero_tasks/json_data

or

--dir /home/dr/git/dartlero/dartlero_tasks/json_data

By running the main function in the bin/dartlero_tasks.dart file, a model,
with two entry points, will be initialized (and saved) in the given directory.
For each entry concept, a file with the concept name and the json extension
will be created. The next time, data from the two files will be loaded.

You may open a file with a text editor. Use a
[JSON pretty-printer] (http://jsonformatter.curiousconcept.com/)
to examine the json document.

**MySQL**

If you want to use MySQL and not JSON data files in 8., do not use script arguments
in the Run/Manage Launches of Dart Editor.

1. no need to create a new database; test database will be used
2. before running a Dart file with main, put a path to the project folder
   (dartlero_tasks) in the working directory field in Run/Manage Launches
   (in order to have access to the connection.options file).

3. run example/mysql/example.dart to drop and create all tables
4. run other examples

5. run test/mysql/employee_test.dart to test employees
6. run test/mysql/project_test.dart to test projects
7. run test/mysql/task/*_tasks_test.dart to test tasks

8. run bin/dartlero_tasks.dart







