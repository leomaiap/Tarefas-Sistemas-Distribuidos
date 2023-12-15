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
    Color(0xFFD7423D),
    Color(0xFFFFE066),
    Color(0xFFFFBA59),
    Color(0xFFFF8C8C),
    Color(0xFFFF99E5),
    Color(0xFFC3A6FF),
    Color(0xFF9FBCF5),
    Color(0xFF8CE2FF),
    Color(0xFF87F5B5),
    Color(0xFFBCF593),
    Color(0xFFE2F587),
    Color(0xFFD9BCAD),
    Colors.grey.shade50
  ];



class _OpenTaskBoardState extends State<OpenTaskBoard> {
  final db = DatabaseHelper();
  List<Map<String, dynamic>> taskList = [];

  @override
  void initState() {
    super.initState();
    // pegar dados do banco de dados
    _getTaskDB(widget.taskBoardID);
    setState(() {
      
    });
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