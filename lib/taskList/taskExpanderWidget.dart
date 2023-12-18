import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:planner/SQLite/sqlite.dart';
import 'package:planner/Views/newTask.dart';
import 'package:planner/Widgets/taskboardWidget.dart';

class TaskExpander extends StatefulWidget {
  //bool expand;
  final bool expand;
  final Function(int index) onDelete;
  final Function(int index) onEdit;
  final Function(int index) onCompleted;
  final int id;
  final String title;
  final String note;
  final DateTime date;
  final String startTime;
  final String endTime;
  final int isCompleted;
  final int color;
  final int icon;
  final int indexListTask;

  TaskExpander({
    Key? key,
    required this.expand,
    required this.onDelete,
    required this.onEdit,
    required this.onCompleted,
    required this.id,
    required this.title,
    required this.note,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.isCompleted,
    required this.color,
    required this.icon,
    required this.indexListTask,
  }) : super(key: key);

  @override
  State<TaskExpander> createState() => _TaskExpanderState();
}

class _TaskExpanderState extends State<TaskExpander> {
  late Color color2;
  late Color color1;
  final db = DatabaseHelper();

  @override
  initState() {
    super.initState();
    color1 = colorsList[widget.color];
    color2 = modifyColor(colorsList[widget.color], -120);
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
    if (widget.expand) {
      return Container(
        decoration: BoxDecoration(
            color: color1, borderRadius: BorderRadius.all(Radius.circular(20))),
        margin: EdgeInsets.symmetric(vertical: 6),
        //height: 100,
        child: Container(
            padding: EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Titulo da Tarefa
                    Text(widget.title,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: color2,
                        )),
                    Row(
                      children: [
                        //Data da tarefa
                        Container(
                          margin: EdgeInsets.only(right: 15),
                          child: Row(
                            children: [
                              //Dia
                              Text(
                                '${DateFormat.E().format(widget.date)} ${widget.date.day}/${widget.date.month}',
                                style: TextStyle(
                                    color: color2,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold),
                              ),
                              Divider(
                                indent: 4,
                              ),
                              Icon(Icons.alarm, color: color2, size: 13),
                              Divider(
                                indent: 2,
                              ),
                              //hora
                              Text(
                                widget.startTime,
                                style: TextStyle(
                                    color: color2,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        widget.isCompleted == 0
                            ? Row(
                                children: [
                                  //isComplete
                                  Icon(
                                    Icons.hourglass_empty_rounded,
                                    size: 13,
                                    color: color2,
                                  ),
                                  Divider(
                                    indent: 2,
                                  ),
                                  Text(
                                    "Pendente",
                                    style:
                                        TextStyle(color: color2, fontSize: 13),
                                  )
                                ],
                              )
                            : Row(
                                children: [
                                  //isComplete
                                  Icon(
                                    Icons.task_alt,
                                    size: 15,
                                    color: color2,
                                  ),
                                  Divider(
                                    indent: 2,
                                  ),
                                  Text(
                                    "Concluído",
                                    style:
                                        TextStyle(color: color2, fontSize: 13),
                                  )
                                ],
                              )
                      ],
                    )
                  ],
                ),
                //Icone
                Icon(
                  IconLabel.values[widget.icon].icon,
                  size: 55,
                  color: color2.withOpacity(0.4),
                ),
              ],
            )),
      );

      //EXPANDIDO
    } else {
      return Container(
          decoration: BoxDecoration(
              color: color1,
              borderRadius: BorderRadius.all(Radius.circular(20))),
          margin: EdgeInsets.symmetric(vertical: 6),
          //height: 320,
          child: Container(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                padding: EdgeInsets.fromLTRB(15, 15, 15, 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //Icone title pendente
                  children: [
                    Row(
                      children: [
                        Icon(
                          IconLabel.values[widget.icon].icon,
                          color: color2,
                          size: 34,
                        ),
                        Divider(
                          indent: 6,
                        ),
                        Text(widget.title,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: color2,
                            ))
                      ],
                    ),
                    widget.isCompleted == 0
                        ? Column(
                            children: [
                              Icon(Icons.hourglass_empty_rounded,
                                  color: color2, size: 18),
                              Text("Pendente",
                                  style: TextStyle(
                                      color: color2,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600))
                            ],
                          )
                        : Column(
                            children: [
                              Icon(Icons.task_alt, color: color2, size: 18),
                              Text("Concluído",
                                  style: TextStyle(
                                      color: color2,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600))
                            ],
                          )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 15),
                child: Row(
                  children: [
                    Text(
                      '${DateFormat.E().format(widget.date)} ${widget.date.day}/${widget.date.month}',
                      style: TextStyle(
                          color: color2,
                          fontSize: 13,
                          fontWeight: FontWeight.bold),
                    ),
                    Divider(
                      indent: 4,
                    ),
                    Icon(Icons.alarm, color: color2, size: 13),
                    Divider(
                      indent: 2,
                    ),
                    Text(
                      widget.startTime,
                      style: TextStyle(
                          color: color2,
                          fontSize: 13,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              //Anotation
              Container(
                margin: EdgeInsets.fromLTRB(15, 6, 15, 0),
                padding: EdgeInsets.all(9),
                //height: 180,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Colors.white38),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "ANOTAÇÃO",
                        style: TextStyle(
                            color: color2,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                      Divider(
                        height: 5,
                        thickness: 1,
                        endIndent: 200,
                        color: color2.withOpacity(0.3),
                      ),
                      Text(
                        widget.note,
                        style: TextStyle(color: color2.withOpacity(.8)),
                      )
                    ]),
              ),
              //Botoes
              Container(
                margin: EdgeInsets.all(3),
                padding: EdgeInsets.fromLTRB(15, 6, 0, 6),
                child: Row(
                  children: [
                    // Botão Apagar
                    MaterialButton(
                      onPressed: () {
                        //Confirmar apagar
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Apagar'),
                                content: Text('Deseja apagar?'),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('cancelar')),
                                  TextButton(
                                      onPressed: () {
                                        db.deleteTask(widget.id);
                                        widget.onDelete(widget.indexListTask);
                                        print('APAGAR');
                                        Navigator.pop(context);
                                      },
                                      child: Text('sim')),
                                ],
                              );
                            });
                      },
                      minWidth: MediaQuery.of(context).size.width / 5,
                      child: Text("Apagar", style: TextStyle(fontSize: 12),),
                      color: color2,
                      textColor: color1,
                    ),
                    
                    Divider(
                      indent: 6,
                    ),
                    //EDITAR
                    MaterialButton(
                      onPressed: () {
                        
                      },
                      minWidth: MediaQuery.of(context).size.width / 5,
                      child: Text("Editar", style: TextStyle(fontSize: 12),),
                      color: color2,
                      textColor: color1,
                    ),
                    
                    Divider(
                      indent: 6,
                    ),
                    //Concluido
                    widget.isCompleted == 0
                        ? MaterialButton(
                      onPressed: () {
                        //isComplete do banco de dados
                        widget.onCompleted(widget.indexListTask);
                        db.completeTask(widget.id);
                        print('Complete');
                      },
                      minWidth: MediaQuery.of(context).size.width / 5,
                      child: Text("Concluído", style: TextStyle(fontSize: 12),),
                      color: color2,
                      textColor: color1,
                    ) : Container(),
                  ],
                ),
              )
            ]),
          ));
    }
  }
}
