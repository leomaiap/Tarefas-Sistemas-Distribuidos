import 'package:flutter/material.dart';
import 'package:planner/Page/mainPage.dart';
import 'package:planner/SQLite/sqlite.dart';
import 'package:planner/Views/openTaskBoard.dart';
import 'package:planner/userSession.dart';

class NewTask extends StatefulWidget {
  String nameBoard;
  int color;
  int taskBoardID;
  NewTask({super.key, required this.nameBoard, required this.color, required this.taskBoardID});

  @override
  State<NewTask> createState() => _NewTaskState();
}


class _NewTaskState extends State<NewTask> {
  TextEditingController nomeController = TextEditingController();
  late String nome;
  bool _nomeVazio = true;
  final db = DatabaseHelper();

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
      Colors.grey
    ];

  @override
  Widget build(BuildContext context) {
    //double screenWidth = MediaQuery.of(context).size.width;
    //double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: colorsList[selectColorIndex],
        title: Text("Nova Tarefa", style: TextStyle(
          fontWeight: FontWeight.bold
        ),),
        leading:
          IconButton(
            icon: Icon(Icons.arrow_back_ios_new),
            onPressed: () {
              Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => OpenTaskBoard(
            name: widget.nameBoard,
            color: widget.color,
            taskBoardID: widget.taskBoardID,
          )));
            },
          ),
        
        centerTitle: true,
      ),
      body: Container(
        //color: colorsList[selectColorIndex],
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('IMPLEMENTAR essa tela', style: TextStyle(
              fontSize: 30
            ),),
            TextFormField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Nome do Task Board",
                ),
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 0, 0, 0)),
                controller: nomeController,
                onChanged: (String value) {
                  nome = value;
                  //print(nome);
                  setState(() {
                    _nomeVazio = value.isEmpty;
                  });
                },
            ),
            
            ElevatedButton(onPressed: _nomeVazio
                  ? null 
                  : () {
              //UserSession.getID; para ter o user_id
              //funcao insert no DB aqui
              Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MainPage()));
            }, child: Text("CRIAR TAREFA"))
          ],
        )
      )
    );
  }
}