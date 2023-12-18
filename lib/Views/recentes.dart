import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:planner/Autenticador/login.dart';
import 'package:planner/SQLite/sqlite.dart';
import 'package:planner/Widgets/dayWidget.dart';
import 'package:planner/taskList/taskListBuilder.dart';
import 'package:planner/userSession.dart';

class Recentes extends StatefulWidget {
  const Recentes({super.key});

  @override
  State<Recentes> createState() => _RecentesState();
}

class _RecentesState extends State<Recentes> {
  late DateTime today;
  int daySelected = 0;
  final db = DatabaseHelper();
  List<Map<String, dynamic>> listTask = [];
  List<bool> dayHasTask = [];
  late Future<List<Map<String, dynamic>>> futureTaskList;
  late Future<List<bool>> futureHasTask;

  @override
  void initState() {
    super.initState();
    futureTaskList = _getTaskList();
    futureHasTask = _getHasTask();
    setState(() {
      today = DateTime.now();
    });
  }

  bool isSelected(int index) {
    return daySelected == index;
  }

  Future<List<bool>> _getHasTask() async {
    String data = DateTime.now().toString().split(' ')[0];
    List<bool> result = await db.hasTasksInNext5Days(UserSession.getID(), data);
    return result;
  }

  Future<List<Map<String, dynamic>>> _getTaskList() async {
    String data = DateTime.now().add(Duration(days: daySelected)).toString().split(' ')[0];
    List<Map<String, dynamic>> list =
        await db.getPendingTasksDate(UserSession.getID(), data);
    return list;
  }

  // Para saber qual usuario atual use UserSession.getID()
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Tarefas Recentes',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: [
            FutureBuilder<List<bool>>(
                future: futureHasTask,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    print('wait');
                    return Container();
                  } else if (snapshot.hasError) {
                    return Text('Erro: ${snapshot.error}');
                  } else {
                    List<bool> dayHasTask = snapshot.data!;
                    return Container(
                      height: 110,
                      padding: EdgeInsets.all(12),
                      child: GridView.builder(
                        itemCount: 5,
                      gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                        crossAxisSpacing: 0,
                      ),
                      itemBuilder:(context, index) {
                        if(daySelected == index){
                          //futureTaskList = _getTaskList();
                        }
                        return GestureDetector(
                          onTap: () {
                            daySelected = index;
                            print(daySelected);
                            futureTaskList = _getTaskList();
                            setState(() {
                              
                            });
                          },
                          child: Container(
                            child: DayCard(
                              day: today.add(Duration(days: index)), 
                              isSelected: isSelected(index),
                              hasTask: dayHasTask[index],),
                          ),
                        );
                      },
                      ),
                    );
                  }
                },
              ),
            //Lista de tarefas aqui
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: futureTaskList,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    print('wait');
                    return Container();
                  } else if (snapshot.hasError) {
                    return Text('Erro: ${snapshot.error}');
                  } else {
                    List<Map<String, dynamic>> listTask = snapshot.data!;
                    return TaskListBuilder(removeIfComplete: true, list: listTask);
                  }
                },
              ),
            ),
          ],
        ),
      )
      // consultar o banco de dados referente ao usuari0 e a data, e listar as tarefas daquele dia (listview.builder() + gesturedetector())
    );
  }
}