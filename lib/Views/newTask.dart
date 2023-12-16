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
  TextEditingController startController = TextEditingController();
  TextEditingController endController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  late String nome;
  bool nomeVazio = true;
  late String startTime;
  bool startTimeVazio = true;
  late String endTime;
  bool endTimeVazio = true;
  late String date;
  bool dateVazio = true;
  late String note = "";

  final db = DatabaseHelper();

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

  @override
  Widget build(BuildContext context) {
    //double screenWidth = MediaQuery.of(context).size.width;
    //double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorsList[widget.color],
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
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Nome da tarefa",
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
                    nomeVazio = value.isEmpty;
                  });
                },
              ),
              const SizedBox(height: 10,),

              TextFormField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Data da tarefa",
                ),
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 0, 0, 0)),
                controller: dateController,
                onChanged: (String value) {
                  date = value;
                  //print(nome);
                  setState(() {
                    dateVazio = value.isEmpty;
                  });
                },
              ),
              const SizedBox(height: 10,),

              TextFormField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Start Time",
                ),
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 0, 0, 0)),
                controller: startController,
                onChanged: (String value) {
                  startTime = value;
                  //print(nome);
                  setState(() {
                    startTimeVazio = value.isEmpty;
                  });
                },
              ),
              const SizedBox(height: 10,),

              TextFormField(
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "End Time",
                ),
                style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 0, 0)),
                controller: endController,
                onChanged: (String value) {
                  endTime = value;
                  //print(nome);
                  setState(() {
                    endTimeVazio = value.isEmpty;
                  });
                },
              ),
              const SizedBox(height: 25,),

              const Text("  Nota sobre tarefa:",
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,

              ),
              ),
              TextFormField(
                keyboardType: TextInputType.text,
                maxLines: 4,
                decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black12))
                ),
                style: const TextStyle(
                    fontSize: 25,
                    color: Color.fromARGB(255, 0, 0, 0)),
                controller: noteController,
                onChanged: (String value) {
                  note = value;
                },
              ),

              const SizedBox(height: 35,),

              Center(
                child: ElevatedButton(onPressed: (nomeVazio || endTimeVazio || startTimeVazio || dateVazio)
                      ? null
                      : () {
                  int userID = UserSession.getID();
                  db.insertTask(nome, note, 0, startTime, endTime, date, widget.taskBoardID, userID); //toda atividade inicia marcada como incompleta
                  Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MainPage()));
                }, child: const Text("CRIAR TAREFA")),
              )
            ],
          ),
        )
      )
    );
  }
}