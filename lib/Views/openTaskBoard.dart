import 'package:flutter/material.dart';
import 'package:planner/Page/mainPage.dart';
import 'package:planner/SQLite/sqlite.dart';
import 'package:planner/Views/newTask.dart';
import 'package:planner/Widgets/progressIndicator.dart';
import 'package:planner/taskList/taskListBuilder.dart';


class OpenTaskBoard extends StatefulWidget {
  String name;
  int color;
  int taskBoardID;
  OpenTaskBoard({super.key, required this.name, required this.color, required this.taskBoardID});

  @override
  State<OpenTaskBoard> createState() => _OpenTaskBoardState();
}

List<Color> colorsList = [
    const Color(0xFFD7423D),
    const Color(0xFFFFE066),
    const Color(0xFFFFBA59),
    const Color(0xFFFF8C8C),
    const Color(0xFFFF99E5),
    const Color(0xFFC3A6FF),
    const Color(0xFF9FBCF5),
    const Color(0xFF8CE2FF),
    const Color(0xFF87F5B5),
    const Color(0xFFBCF593),
    const Color(0xFFE2F587),
    const Color(0xFFD9BCAD),
    Colors.grey.shade50
  ];



class _OpenTaskBoardState extends State<OpenTaskBoard> {
  final db = DatabaseHelper();
  List<Map<String, dynamic>> listTask = [];
  late Future<List<Map<String, dynamic>>> futureTaskList;

  @override
  void initState() {
    super.initState();
    _quantTarefas();
    futureTaskList = _getTaskList();
  }

  int totalTasks = 0;
  int completeTasks = 0;

  _quantTarefas() async {
    int count = await db.getTaskCountByTaskBoard(widget.taskBoardID);
    int comp = await db.getTaskCompleteCountByTaskBoard(widget.taskBoardID);
    totalTasks = count;
    completeTasks = comp;
    setState(() {
      
    });
  }

  Future<List<Map<String, dynamic>>> _getTaskList() async {
    List<Map<String, dynamic>> list =
        await db.getTasksByTaskBoard(widget.taskBoardID);
    return list;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
        backgroundColor: colorsList[widget.color],
        title: Text(widget.name, style: const TextStyle(
          fontWeight: FontWeight.bold
        ),),
        leading:
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () {
              Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) =>  const MainPage()));
            },
          ),
        
        centerTitle: true,
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: TaskProgressIndicator(completedTasks: completeTasks, totalTasks: totalTasks),
          ),
          FutureBuilder<List<Map<String, dynamic>>>(
            future: futureTaskList,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container();
              } else if (snapshot.hasError) {
                return Text('Erro: ${snapshot.error}');
              } else {
                List<Map<String, dynamic>> listTask = snapshot.data!;
                return Expanded(child: TaskListBuilder(removeIfComplete: false, list: listTask));
              }
            },
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.task),
        onPressed: () {
          Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => NewTask(
            nameBoard: widget.name,
            color: widget.color,
            taskBoardID: widget.taskBoardID)));
        },
        label: const Text('Nova Tarefa'),),
      );
  }
}