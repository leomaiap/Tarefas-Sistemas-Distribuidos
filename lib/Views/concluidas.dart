import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:planner/Autenticador/login.dart';
import 'package:planner/SQLite/sqlite.dart';
import 'package:planner/taskList/taskListBuilder.dart';
import 'package:planner/userSession.dart';

class Concluidas extends StatefulWidget {
  const Concluidas({super.key});

  @override
  State<Concluidas> createState() => _ConcluidasState();
}

class _ConcluidasState extends State<Concluidas> {
  final db = DatabaseHelper();
  List<Map<String, dynamic>> listTask = [];
  late Future<List<Map<String, dynamic>>> futureTaskList;

  @override
  void initState() {
    super.initState();
    futureTaskList = _getTaskList();
  }

  Future<List<Map<String, dynamic>>> _getTaskList() async {
    List<Map<String, dynamic>> list =
        await db.getCompletedTasks(UserSession.getID());
    return list;
  }

  // Para saber qual usuario atual use UserSession.getID()
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Tarefas concluídas", style: TextStyle(
          fontWeight: FontWeight.bold
        ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const TelaLogin()));
            },
          ),
        ],
        centerTitle: true,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: futureTaskList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container();
          } else if (snapshot.hasError) {
            return Text('Erro: ${snapshot.error}');
          } else {
            List<Map<String, dynamic>> listTask = snapshot.data!;
            return TaskListBuilder(removeIfComplete: false, list: listTask);
          }
        },
      ),

    );
  }
}