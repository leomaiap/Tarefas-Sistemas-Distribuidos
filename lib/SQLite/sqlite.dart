import 'package:path/path.dart';
import 'package:planner/JsonModels/usuarios.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  final databaseName = "notes.db";

  String users =
      "create table users (usrId INTEGER PRIMARY KEY AUTOINCREMENT, usrName TEXT UNIQUE, usrPassword TEXT)";
    
  String taskBoard = """CREATE TABLE task_board(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR NOT NULL,
    color INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    FOREIGN KEY(user_id) REFERENCES user(id));""";

  String task = """CREATE TABLE task(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    board_id INTEGER NOT NULL,
    title VARCHAR NOT NULL,
    note TEXT NOT NULL,
    date VARCHAR NOT NULL,
    startTime VARCHAR NOT NULL,
    endTime VARCHAR NOT NULL,
    isCompleted INTEGER,
    FOREIGN KEY(user_id) REFERENCES user(id),
    FOREIGN KEY(board_id) REFERENCES task_board(id));""";
  
  Future<Database> initDB() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, databaseName);

    //databaseFactory.deleteDatabase(path); //Se quiser deletar o BD descomentar...

    return openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute(users);
      await db.execute(taskBoard);
      await db.execute(task);
    });
  }


  //Metodo de Login

  Future<bool> login(Usuarios user) async {
    final Database db = await initDB();

    // Esqueci a senha para verificar
    var result = await db.rawQuery(
        "select * from users where usrName = '${user.usrName}' AND usrPassword = '${user.usrPassword}'");
    if (result.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  //Cadastrar
  Future<int> signup(Usuarios user) async {
    final Database db = await initDB();

    return db.insert('users', user.toMap());
  }

  // ID do usuario para sessão
  Future<int?> getIdByName(String usrName) async {
    final Database db = await initDB();

    List<Map<String, dynamic>> result = await db.query(
      'users',
      columns: ['usrId'],
      where: 'usrName = ?',
      whereArgs: [usrName],
    );

    if (result.isNotEmpty) {
      return result[0]['usrId'] as int?;
    } else {
      return null; // Retorna null se não encontrar nenhum usuário com o usrName fornecido
    }
  }
  
  //Criar nova Task board
  Future<int> insertTaskBoard(String name, int color, int userID) async {
    final Database db = await initDB();

    Map<String, dynamic> taskBoardData = {
      'name': name,
      'color': color,
      'user_id': userID,
    };

    int id = await db.insert('task_board', taskBoardData);

    return id;
  }
 
  //Carregar Todas taskboards do usuario
  Future<List<Map<String, dynamic>>> getTaskBoardsByUserId(int userId) async {
    final Database db = await initDB();

    List<Map<String, dynamic>> result = await db.query(
      'task_board',
      where: 'user_id = ?',
      whereArgs: [userId],
    );

    return result;
  }

  // Método para obter a quantidade de tasks associadas a um taskboard_id
  Future<int> getTaskCountByTaskBoard(int taskBoardId) async {
    final Database db = await initDB();

    int count = Sqflite.firstIntValue(await db.rawQuery(
      'SELECT COUNT(*) FROM task WHERE board_id = ?',
      [taskBoardId],
    )) ?? 0;

    return count as int;
  }

  //Lista de tarefas passando o taskboardID
  Future<List<Map<String, dynamic>>> getTasksByTaskBoard(int taskBoardId) async {
    final Database db = await initDB();

    List<Map<String, dynamic>> result = await db.query(
      'task',
      where: 'board_id = ?',
      whereArgs: [taskBoardId],
    );

    return result;
  }

}
