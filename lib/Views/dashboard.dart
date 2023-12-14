import 'package:flutter/material.dart';
import 'package:planner/Autenticador/login.dart';
import 'package:planner/SQLite/sqlite.dart';
import 'package:planner/Views/newTaskBoard.dart';
import 'package:planner/Views/openTaskBoard.dart';
import 'package:planner/userSession.dart';
import 'package:planner/widgets/taskboardWidget.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final db = DatabaseHelper();
  List<Map<String, dynamic>> taskBoardsList = [];

  @override
  void initState() {
    super.initState();
    _getTaskBoardDB();
  }

  _getTaskBoardDB() async {
    List<Map<String, dynamic>> list =
        await db.getTaskBoardsByUserId(UserSession.getID());
    setState(() {
      taskBoardsList = list;
    });
    print(taskBoardsList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Dashboard",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const TelaLogin()));
            },
          ),
        ],
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(15),
        child: GridView.builder(
          itemCount: taskBoardsList.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            return GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OpenTaskBoard(
                                name: taskBoardsList[index]['name'],
                                color: taskBoardsList[index]['color'] as int,
                                taskBoardID: taskBoardsList[index]['id'] as int,
                              )));
                },
                child: Container(
                    child: TaskBoardCard(
                  name: taskBoardsList[index]['name'],
                  color: taskBoardsList[index]['color'] as int,
                  icon: taskBoardsList[index]['icon'] as int,
                  taskBoardID: taskBoardsList[index]['id'] as int,
                )));
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.add_box),
        onPressed: () {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const NewTaskBoard()));
        },
        label: Text('Novo Quadro'),
      ),
    );
  }
}
