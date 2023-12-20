import 'package:flutter/material.dart';
import 'package:planner/Page/mainPage.dart';
import 'package:planner/SQLite/sqlite.dart';
import 'package:planner/Views/openTaskBoard.dart';
import 'package:planner/userSession.dart';

class UpdateTask extends StatefulWidget {
  int color;
  int taskId;

  String nome;
  String startTime;
  String endTime;
  String date;
  String note;

  UpdateTask(
      {super.key,
      required this.color,
      required this.nome,
      required this.startTime,
      required this.endTime,
      required this.date,
      required this.note,
      required this.taskId});

  @override
  State<UpdateTask> createState() => _UpdateTaskState();
}

class _UpdateTaskState extends State<UpdateTask> {
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

  //valores iniciais, obtidos quando 'gotInitParameters' é falso
  String initialNome = "";
  String initialNote = "";

  //controladores
  TextEditingController nomeController = TextEditingController();
  TextEditingController startController = TextEditingController();
  TextEditingController endController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  final db = DatabaseHelper();

  String getDateDisplay() {
    return "  Data: " + widget.date;
  }

  String getStartDateDisplay() {
    return "  Horário inicial: " + widget.startTime;
  }

  String getEndDateDisplay() {
    return "  Horário final: " + widget.endTime;
  }

  String getPossiblyNullValue(String? s) {
    if (s == null) {
      return "";
    }
    return s;
  }

  void updateDate(DateTime? dt) {
    if (dt == null) {
      return;
    }
    setState(() {
      widget.date = dt.toString().split(' ')[0];
    });
  }

  void updateStart(TimeOfDay? dt) {
    if (dt == null) {
      return;
    }
    setState(() {
      widget.startTime = dt.toString().split('(')[1].replaceAll(')', '');
    });
  }

  void updateEnd(TimeOfDay? dt) {
    if (dt == null) {
      return;
    }
    setState(() {
      widget.endTime = dt.toString().split('(')[1].replaceAll(')', '');
    });
  }

  void _showDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2030))
        .then((value) => updateDate(value));
  }

  void _showStartPicker() {
    showTimePicker(context: context, initialTime: TimeOfDay.now())
        .then((value) => updateStart(value));
  }

  void _showEndPicker() {
    showTimePicker(context: context, initialTime: TimeOfDay.now())
        .then((value) => updateEnd(value));
  }

  bool gotInitParameters = false;

  @override
  Widget build(BuildContext context) {
    if (!gotInitParameters) {
      initialNome = widget.nome;
      nomeController.text = initialNome;
      initialNote = getPossiblyNullValue(widget.note);
      noteController.text = initialNote;
      gotInitParameters = true;
    }
    //double screenWidth = MediaQuery.of(context).size.width;
    //double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: colorsList[widget.color],
          title: Text(
            "Editar Tarefa",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new),
            onPressed: () {
              Navigator.pop(context);
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
                  const SizedBox(
                    height: 5,
                  ),

                  //NOME DA TAREFA
                  TextFormField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Nome da tarefa",
                    ),
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.normal,
                        color: const Color.fromARGB(255, 0, 0, 0)),
                    controller: nomeController,
                    onChanged: (String value) {
                      //print(nome);
                      setState(() {
                        widget.nome = value;
                      });
                    },
                    //initialValue: initialNome,
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  //PICK DATE:

                  //PICK DATE - botão que permite o usuário selecinar data, encapsulado no center abaixo
                  Center(
                    child: SizedBox(
                      width: 335,
                      child: MaterialButton(
                        onPressed: () {
                          _showDatePicker();
                        },
                        child: Padding(
                          padding: EdgeInsets.all(4),
                          child: Text("Escolher Data",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20)),
                        ),
                        color: colorsList[widget.color],
                      ),
                    ),
                  ),
                  //PICK DATE - texto que informa data atual, encapsulado no center abaixo
                  Center(
                    child: Text(
                      getDateDisplay(),
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  //PICK START TIME
                  Center(
                    child: SizedBox(
                      width: 335,
                      child: MaterialButton(
                        onPressed: () {
                          _showStartPicker();
                        },
                        child: Padding(
                          padding: EdgeInsets.all(4),
                          child: Text("Horário inicial",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20)),
                        ),
                        color: colorsList[widget.color],
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      getStartDateDisplay(),
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  //PICK END TIME
                  Center(
                    child: SizedBox(
                      width: 335,
                      child: MaterialButton(
                        onPressed: () {
                          _showEndPicker();
                        },
                        child: Padding(
                          padding: EdgeInsets.all(4),
                          child: Text("Horário final",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20)),
                        ),
                        color: colorsList[widget.color],
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      getEndDateDisplay(),
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),

                  //WRITE NOTE
                  const Text(
                    "  Nota sobre tarefa:",
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
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black12))),
                    style: const TextStyle(
                        fontSize: 15, color: Color.fromARGB(255, 0, 0, 0)),
                    controller: noteController,
                    onChanged: (String value) {
                      widget.note = value;
                    },
                    //initialValue: initialNote,
                  ),
                  const SizedBox(
                    height: 35,
                  ),

                  //CRIAR TAREFA
                  Center(
                    child: ElevatedButton(
                        onPressed: (false)
                            ? null
                            : () {
                                db.updateTask(
                                    widget.taskId,
                                    widget.nome,
                                    widget.note,
                                    widget.startTime,
                                    widget.endTime,
                                    widget.date);
                                Navigator.pop(context);
                                Future.delayed(
                                  const Duration(milliseconds: 200),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Row(
                                      children: [
                                        Icon(Icons.check, color: Colors.white),
                                        SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            "Tarefa editada!",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                    backgroundColor: Colors.green,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    behavior: SnackBarBehavior.floating,
                                    margin: const EdgeInsets.all(5),
                                    elevation: 4,
                                    duration: const Duration(seconds: 4),
                                  ),
                                );
                                //db.insertTask(nome, note, 0, startTime, endTime, date, widget.taskBoardID, userID); //toda atividade inicia marcada como incompleta
                              },
                        child: const Text("EDITAR TAREFA")),
                  )
                ],
              ),
            )));
  }
}
