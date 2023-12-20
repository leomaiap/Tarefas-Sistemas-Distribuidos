import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:planner/SQLite/sqlite.dart';
import 'package:planner/Widgets/progressIndicator.dart';
import 'package:planner/Widgets/progressIndicatorDashboard.dart';

class TaskBoardCard extends StatefulWidget {
  String name;
  int color;
  int icon;
  int taskBoardID;
  final bool isLongPressed;
  TaskBoardCard(
      {super.key,
      required this.name,
      required this.color,
      required this.taskBoardID,
      required this.icon,
      required this.isLongPressed});

  @override
  State<TaskBoardCard> createState() => _TaskBoardCardState();
}

class _TaskBoardCardState extends State<TaskBoardCard> {
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

  late Color color1;
  late Color color2;
  late Color color3;

  final db = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _quantTarefas();
    color1 = colorsList[widget.color];
    color2 = modifyColor(colorsList[widget.color], -120);
    color3 = modifyColor(colorsList[widget.color], -60);
  }

  String countTasks = '';
  int totalTasks = 0;
  int completeTasks = 0;

  _quantTarefas() async {
    int count = await db.getTaskCountByTaskBoard(widget.taskBoardID);
    int comp = await db.getTaskCompleteCountByTaskBoard(widget.taskBoardID);
    totalTasks = count;
    completeTasks = comp;
    setState(() {
      if (count == 0) {
        countTasks = "Não há tarefas";
      } else if (count == 1) {
        countTasks = "$count Tarefa";
      } else {
        countTasks = "$count Tarefas";
      }
    });
  }

  //Mudar o tom da cor
  Color modifyColor(Color originalColor, int brightness) {
    int red = originalColor.red + brightness;
    int green = originalColor.green + brightness;
    int blue = originalColor.blue + brightness;

    red = red.clamp(0, 255);
    green = green.clamp(0, 255);
    blue = blue.clamp(0, 255);

    return Color.fromARGB(255, red, green, blue);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width - 40;
    IconData icon = IconLabel.values[widget.icon].icon;
    // if (widget.isLongPressed) {
    //   controller.forward();
    // } else {
    //   controller.stop();
    // }
    //print("id ${widget.taskBoardID}: ${widget.isLongPressed}");
    return Stack(
      children: [
        
        Container(
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
              color: !widget.isLongPressed ? color1 : color3,
              borderRadius: BorderRadius.all(Radius.circular(screenWidth * 0.050))),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 4),
                  child: Icon(
                    icon,
                    size: screenWidth * 0.10,
                    color: color2,
                  ),
                ),
                Container(
                    alignment: Alignment.center,
                    //padding: EdgeInsets.only(left: screenWidth * 0.025),
                    child: Text(
                      widget.name,
                      style: TextStyle(
                          fontSize: screenWidth * 0.06,
                          fontWeight: FontWeight.bold,
                          color: color2),
                    )),
                Container(
                    alignment: Alignment.center,
                    //padding: EdgeInsets.only(left: screenWidth * 0.015),
                    child: Text(
                      countTasks,
                      style:
                          TextStyle(fontSize: screenWidth * 0.032, color: color2),
                    )),
                totalTasks > 0
                    ? Padding(
                        padding: const EdgeInsets.all(5),
                        child: Column(
                          children: [
                            TaskProgressIndicatorDashboard(
                                completedTasks: completeTasks,
                                totalTasks: totalTasks,
                                color: color2),
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Text(
                                '${((completeTasks / totalTasks) * 100).round()}%',
                                style: TextStyle(fontSize: 10, color: color2),
                              ),
                            )
                          ],
                        ),
                      )
                    : Container()
              ],
            ),
          ),
        ),
        widget.isLongPressed ? Container(
          padding: EdgeInsets.all(16),
          child: Icon(Icons.check_circle, color: Colors.white, size: screenWidth * 0.06),
        ) : Container()
      ],
    );
    //.rotate(begin: -0.991, end: -1.01, curve: Curves.easeInOut, duration: 600.ms,);
  }
}

enum IconLabel {
  exercise('Exercício', Icons.fitness_center),
  health('Saúde', Icons.health_and_safety),
  book('Estudo', Icons.book),
  heart('Hobby', Icons.favorite),
  work('Trabalho', Icons.work),
  fun('Diversão', Icons.tv),
  shopping('Compras', Icons.shopping_cart),
  meeting('Reunião', Icons.group),
  aniversario('Aniversario', Icons.cake),
  assignment('Atribuição', Icons.assignment),
  travel('Viagem', Icons.flight_takeoff),
  coding('Programação', Icons.code),
  cooking('Cozinha', Icons.restaurant),
  finance('Finanças', Icons.attach_money),
  music('Música', Icons.music_note),
  coffee('Café', Icons.local_cafe),
  puzzle('Quebra-cabeça', Icons.extension),
  alarm('Alarme', Icons.alarm),
  list('Lista', Icons.list),
  map('Mapa', Icons.map),
  paint('Arte', Icons.palette),
  pet('Animal de Estimação', Icons.pets),
  photo('Fotografia', Icons.photo),
  shoppingBag('Sacola de Compras', Icons.shopping_bag);

  const IconLabel(this.label, this.icon);
  final String label;
  final IconData icon;
}
