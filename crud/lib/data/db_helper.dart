import 'package:crud/models/student_model.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DBHelper {
  static Database _db;

  //Checando o estado do banco de dados
  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDatabase();
    return _db;
  }

  //Iniciando o banco de dados
  initDatabase() async {
    io.Directory documentDiretory = await getApplicationDocumentsDirectory();
    String path = join(documentDiretory.path, 'student.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  //Criando tabela de estudantes no banco de dados
  _onCreate(Database db, int version) async {
    await db
        .execute('CREATE TABLE student (id INTEGER PRIMARY KEY, name TEXT)');
  }

  //Adicionando estudantes ao banco de dados
  Future<Student> getStudents(Student student) async {
    var dbClient = await db;
    student.id = await dbClient.insert('student', student.toMap());
    return student;
  }

  //Listar todos os estudantes do banco de dados
  Future<List<Student>> getStudent() async {
    var dbClient = await db;
    List<Map> map = await dbClient.query('student', columns: ['id', 'name']);
    List<Student> students = [];
    if (map.length > 0) {
      for (int i = 0; i < map.length; i++) {
        students.add(Student.fromMap(map[i]));
      }
    }
    return students;
  }

  //Deletando um estudante do banco de dados
  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient.delete(
      'student',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  //Alterando informações do estudante localizando ele por ID
  Future<int> update(Student student) async {
    var dbClient = await db;
    return await dbClient.update(
      'student',
      student.toMap(),
      where: 'id = ?',
      whereArgs: [student.id],
    );
  }

  //Fechando a conexão com o banco de dados
  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}
