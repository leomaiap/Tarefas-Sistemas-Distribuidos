import 'package:flutter/material.dart';
import 'package:planner/SQLite/sqlite.dart';

class TaskBoardCard extends StatefulWidget {
  String name;
  int color;
  int icon;
  int taskBoardID;
  TaskBoardCard(
      {super.key,
      required this.name,
      required this.color,
      required this.taskBoardID,
      required this.icon});

  @override
  State<TaskBoardCard> createState() => _TaskBoardCardState();
}

class _TaskBoardCardState extends State<TaskBoardCard> {
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

  // List<IconData> iconList = [
  //   Icons.fitness_center,
  //   Icons.health_and_safety,
  //   Icons.book,
  //   Icons.favorite,
  //   Icons.work,
  //   Icons.tv
  // ];

  final db = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _quantTarefas();
  }

  String countTasks = '';

  _quantTarefas() async {
    int count = await db.getTaskCountByTaskBoard(widget.taskBoardID);
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

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    IconData icon = IconLabel.values[widget.icon!].icon;
    //double screenHeight = MediaQuery.of(context).size.height;
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              color: colorsList[widget.color],
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(screenWidth * 0.020),
                  topRight: Radius.circular(screenWidth * 0.020))),
          height: screenWidth * 0.3,
          width: screenWidth * 0.5,
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: screenWidth * 0.025),
                    child: Text(
                      widget.name,
                      style: TextStyle(
                          fontSize: screenWidth * 0.06,
                          fontWeight: FontWeight.bold),
                    )),
                Icon(
                  icon,
                  size: screenWidth * 0.12,
                )
              ],
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
              color: colorsList[widget.color].withOpacity(0.8),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(screenWidth * 0.020),
                  bottomRight: Radius.circular(screenWidth * 0.020))),
          height: screenWidth * 0.1,
          width: screenWidth * 0.5,
          child: Container(
            child: Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: screenWidth * 0.025),
                child: Text(
                  countTasks,
                  style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      fontWeight: FontWeight.bold),
                )),
          ),
        ),
      ],
    );
  }
}

enum IconLabel {
  exercise('Exercício', Icons.fitness_center),
  health(
    'Saúde',
    Icons.health_and_safety,
  ),
  book('Estudo', Icons.book),
  heart('Hobby', Icons.favorite),
  work('Trabalho', Icons.work),
  fun('Diversão', Icons.tv);

  const IconLabel(this.label, this.icon);
  final String label;
  final IconData icon;
}
