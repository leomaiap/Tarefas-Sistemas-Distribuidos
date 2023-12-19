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
    icon INTEGER NOT NULL,
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
  Future<int> insertTaskBoard(
      String name, int color, int icon, int userID) async {
    final Database db = await initDB();

    Map<String, dynamic> taskBoardData = {
      'name': name,
      'color': color,
      'icon': icon,
      'user_id': userID,
    };

    int id = await db.insert('task_board', taskBoardData);

    return id;
  }

   Future<int> insertTaskBoardID(
      int idd, String name, int color, int icon, int userID) async {
    final Database db = await initDB();

    Map<String, dynamic> taskBoardData = {
      'id': idd,
      'name': name,
      'color': color,
      'icon': icon,
      'user_id': userID,
    };

    int id = await db.insert('task_board', taskBoardData);

    return id;
  }

  //Cadastrar Tarefa
  Future<int> insertTask(
      String title,
      String note,
      int isCompleted,
      String startTime,
      String endTime,
      String date,
      int boardID,
      int userID) async {
    final Database db = await initDB();

    Map<String, dynamic> taskBoardData = {
      'title': title,
      'note': note,
      'isCompleted': isCompleted,
      'startTime': startTime,
      'endTime': endTime,
      'date': date,
      'board_id': boardID,
      'user_id': userID,
    };

    int id = await db.insert('task', taskBoardData);

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
        )) ??
        0;

    return count as int;
  }

  Future<int> getTaskCompleteCountByTaskBoard(int taskBoardId) async {
    final Database db = await initDB();

    int count = Sqflite.firstIntValue(await db.rawQuery(
          'SELECT COUNT(*) FROM task WHERE board_id = ? AND isCompleted = 1',
          [taskBoardId],
        )) ??
        0;

    return count as int;
  }


  // Método para obter todas as tasks concluídas associadas a um usuário e fazer JOIN com task_board
  Future<List<Map<String, dynamic>>> getCompletedTasks(int userId) async {
    final Database db = await initDB();

    List<Map<String, dynamic>> result = await db.rawQuery('''
    SELECT task.*, task_board.color AS color, task_board.icon AS icon
    FROM task
    JOIN task_board ON task.board_id = task_board.id
    WHERE task.user_id = ? AND task.isCompleted = 1
    ORDER BY task.date, task.startTime
  ''', [userId]);

    return result;
  }

  // Método para obter tarefas não concluídas com data e fazer JOIN com task_board
  Future<List<Map<String, dynamic>>> getPendingTasksDate(
      int userId, String date) async {
    final Database db = await initDB();

    List<Map<String, dynamic>> result = await db.rawQuery('''
      SELECT task.*, task_board.color AS color, task_board.icon AS icon
      FROM task
      INNER JOIN task_board ON task.board_id = task_board.id
      WHERE task.user_id = ? AND task.isCompleted = 0 AND task.date = ?
    ''', [userId, date]);

    return result;
  }

  // Método para obter tarefas pela data e fazer JOIN com task_board
  Future<List<Map<String, dynamic>>> getTasksDate(
      int userId, String date) async {
    final Database db = await initDB();

    List<Map<String, dynamic>> result = await db.rawQuery('''
      SELECT task.*, task_board.color AS color, task_board.icon AS icon
      FROM task
      INNER JOIN task_board ON task.board_id = task_board.id
      WHERE task.user_id = ? AND task.date = ?
    ''', [userId, date]);

    return result;
  }

  // Método para obter tarefas não concluídas com data e fazer JOIN com task_board
  Future<List<Map<String, dynamic>>> getTasksByTaskBoard(
      int taskBoardId) async {
    final Database db = await initDB();

    List<Map<String, dynamic>> result = await db.rawQuery('''
    SELECT task.*, task_board.color AS color, task_board.icon AS icon
    FROM task
    JOIN task_board ON task.board_id = task_board.id
    WHERE task.board_id = ?
    ORDER BY task.date, task.startTime
  ''', [taskBoardId]);

    return result;
  }

  //apagar tarefa
  Future<void> deleteTask(int taskId) async {
    final Database db = await initDB();
    await db.delete('task', where: 'id = ?', whereArgs: [taskId]);
  }

  //Marcar coo conclido
  Future<void> completeTask(int taskId) async {
    final Database db = await initDB();
    await db.update(
      'task',
      {'isCompleted': 1},
      where: 'id = ?',
      whereArgs: [taskId],
    );
  }

  Future<List<Map<String, dynamic>>> getTasksByDay(
      int userId, DateTime day) async {
    final String day1 = day.toString().split(' ')[0];
    final Database db = await initDB();
    List<Map<String, dynamic>> dayTasks = await db.rawQuery('''
      SELECT task.*, task_board.color AS color, task_board.icon AS icon
      FROM task
      LEFT JOIN task_board ON task.board_id = task_board.id
      WHERE task.user_id = ? AND task.date = ?
    ''', [userId, day1]);

    return dayTasks;
  }

  Future<List<Map<String, dynamic>>> getTasksByMonth(
      int userId, List<DateTime> monthDays) async {
    List<String> days = monthDays.map((DateTime day) {
      return day.toString().split(' ')[0];
    }).toList();
    String inClause = '(' + List.filled(days.length, '?').join(', ') + ')';

    final Database db = await initDB();
    List<Map<String, dynamic>> dayTasks = await db.query(
      'task t left join task_board tb on t.board_id = tb.id',
      columns: ["date"],
      where: 't.user_id = ? AND t.date IN $inClause',
      whereArgs: [userId, ...days],
    );

    return dayTasks;
  }

  Future<List<Map<String, dynamic>>> getTasksBySearch(
      int userId, String palavra) async {
    final Database db = await initDB();
    palavra = "%$palavra%".toLowerCase();
    List<Map<String, dynamic>> dayTasks = await db.rawQuery('''
      SELECT task.*, task_board.color AS color, task_board.icon AS icon
      FROM task
      LEFT JOIN task_board ON task.board_id = task_board.id
      WHERE task.user_id = ? AND (
      lower(task.title) LIKE ? 
      OR lower(task.note) LIKE ?
    )
    ''', [userId, palavra, palavra]);
    return dayTasks;
  }

  Future<Map<String, int>> getTaskProgress(int userId) async {
    final Database db = await initDB();

    int completedTasks = Sqflite.firstIntValue(await db.rawQuery('''
      SELECT COUNT(*) FROM task
      WHERE user_id = ? AND isCompleted = 1
    ''', [userId])) ?? 0;

    int totalTasks = Sqflite.firstIntValue(await db.rawQuery('''
      SELECT COUNT(*) FROM task
      WHERE user_id = ?
    ''', [userId])) ?? 0;

    return {'completedTasks': completedTasks, 'totalTasks': totalTasks};
  }

  Future<List<bool>> hasTasksInNext5Days(int userId, String currentDate) async {
    final Database db = await initDB();
    List<bool> result = [];

    for (int i = 0; i < 5; i++) {
      DateTime nextDay = DateTime.parse(currentDate).add(Duration(days: i));
      String nextDayFormatted = nextDay.toString().split(' ')[0];

      List<Map<String, dynamic>> dayTasks = await db.rawQuery('''
        SELECT COUNT(*) as count
        FROM task
        WHERE user_id = ? AND date = ? AND isCompleted = 0
      ''', [userId, nextDayFormatted]);

      int taskCount = dayTasks.isNotEmpty ? dayTasks[0]['count'] : 0;
      result.add(taskCount > 0);
    }

    return result;
  }

  Future<void> updateTask
      (int taskId,
      String title,
      String note,
      String startTime,
      String endTime,
      String date) async{

      //print("TASK ID:");
      //print(taskId);
      //print(note);

      final Database db = await initDB();
      await db.update(
        'task',
        {
          'title': title,
          'note': note,
          'startTime': startTime,
          'endTime': endTime,
          'date': date,
        },
        where: 'id = ?',
        whereArgs: [taskId],
      );
  }

  Future<List<Map<String, dynamic?>>> getTaskDataById(int taskId) async{
    final Database db = await initDB();
      List<Map<String, dynamic>> taskData = await db.rawQuery('''
      SELECT title AS name, startTime, endTime, note, date
      FROM task
      WHERE id = $taskId
    ''');
    return taskData;
  }

}
