import 'package:flutter/material.dart';
import 'package:planner/Page/mainPage.dart';
import 'package:planner/SQLite/sqlite.dart';
import 'package:planner/Views/newTask.dart';

class OpenTaskBoard extends StatefulWidget {
  String name;
  int color;
  int taskBoardID;
  OpenTaskBoard({super.key, required this.name, required this.color, required this.taskBoardID});

  @override
  State<OpenTaskBoard> createState() => _OpenTaskBoardState();
}

List<Color> colorsList = [
      Colors.red,
      Colors.orange,
      Colors.yellow,
      Colors.green,
      Colors.lightGreen,
      Colors.lightBlue,
      Colors.blueAccent,
      Colors.purple,
      Colors.deepPurple,
      Colors.pinkAccent,
      Colors.pink,
      Colors.brown,
      Colors.grey,
      Colors.blueGrey
    ];



class _OpenTaskBoardState extends State<OpenTaskBoard> {
  final db = DatabaseHelper();
  List<Map<String, dynamic>> taskList = [];

  @override
  void initState() {
    super.initState();
    // pegar dados do banco de dados
    _getTaskDB(widget.taskBoardID);
  }

  _getTaskDB(int taskBoardID) async{
    // taskList recebe as tasks que tem taskBoardID como referencia
    // get do banco de dados
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
        backgroundColor: colorsList[widget.color],
        title: Text(widget.name, style: TextStyle(
          fontWeight: FontWeight.bold
        ),),
        leading:
          IconButton(
            icon: Icon(Icons.arrow_back_ios_new),
            onPressed: () {
              Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) =>  MainPage()));
            },
          ),
        
        centerTitle: true,
      ),

      body:Container(
        decoration: BoxDecoration(
          color: colorsList[widget.color].withOpacity(0.5)
        ),
        child: Text("Implementar"),
        // Listview builder no taskList
        // Criar um widget TaskWidget(parametros construtor...),
      ),

      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.task),
        onPressed: () {
          Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => NewTask(
            nameBoard: widget.name,
            color: widget.color,
            taskBoardID: widget.taskBoardID)));
        },
        label: Text('Nova Tarefa'),),
      );
  }
}