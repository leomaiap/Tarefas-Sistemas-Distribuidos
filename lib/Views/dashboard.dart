import 'package:flutter/material.dart';
import 'package:planner/Autenticador/login.dart';
import 'package:planner/Page/mainPage.dart';
import 'package:planner/SQLite/exampleData.dart';
import 'package:planner/SQLite/sqlite.dart';
import 'package:planner/Views/newTaskBoard.dart';
import 'package:planner/Views/openTaskBoard.dart';
import 'package:planner/Widgets/emptyTask.dart';
import 'package:planner/Widgets/emptyDashboard.dart';
import 'package:planner/userSession.dart';
import 'package:planner/widgets/taskboardWidget.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final db = DatabaseHelper();
  final dataGenerator = DataGenerator();
  int count = 0;
  List<Map<String, dynamic>> taskBoardsList = [];
  late Future<List<Map<String, dynamic>>> taskBoardsFuture;

  @override
  void initState() {
    super.initState();
    taskBoardsFuture = db.getTaskBoardsByUserId(UserSession.getID());
  }

  // _getTaskBoardDB() async {
  //   List<Map<String, dynamic>> list =
  //       await db.getTaskBoardsByUserId(UserSession.getID());
  //   setState(() {
  //     taskBoardsList = list;
  //   });
  //   print(taskBoardsList);
  // }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          Text('Sair', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
          IconButton(
            icon: Icon(Icons.logout),
            iconSize: 20,
            onPressed: () {
              showDialog(context: context,
                        builder: (context){
                          return AlertDialog(
                            title: Text('Sair'),
                            content: Text('Deseja sair?'),
                            actions: [
                              TextButton(
                                onPressed: (){
                                  Navigator.pop(context);
                                }
                              , child: Text('cancelar')),
                              TextButton(
                                onPressed: (){
                                  Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (context) => const TelaLogin()));
                                }
                              , child: Text('sim')),
                            ],
                          );
                        }
                        );
              // Navigator.pushReplacement(context,
              //     MaterialPageRoute(builder: (context) => const TelaLogin()));
            },
          ),
        ],
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Bem-Vindo", style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 26
                ),),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const NewTaskBoard()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          10.0), // Ajuste o valor conforme necessário
                    ),
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add), // Ícone que você deseja adicionar
                      SizedBox(width: 2), // Espaçamento entre o ícone e o texto
                      Text('Novo Quadro'),
                    ],
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: taskBoardsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erro: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: GestureDetector(onTap: () {
                    count++;
                    if (count == 10){
                      _gerarDados();
                                   
                      Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MainPage()));

                    }
                  },
                  child: EmptyDashboard(),
                  ));
                } else {
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: GridView.builder(
                      itemCount: snapshot.data!.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 18,
                          mainAxisSpacing: 18),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OpenTaskBoard(
                                  name: snapshot.data![index]['name'],
                                  color: snapshot.data![index]['color'] as int,
                                  taskBoardID: snapshot.data![index]['id'] as int,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            child: TaskBoardCard(
                              name: snapshot.data![index]['name'],
                              color: snapshot.data![index]['color'] as int,
                              icon: snapshot.data![index]['icon'] as int,
                              taskBoardID: snapshot.data![index]['id'] as int,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
  
  void _gerarDados() {
    dataGenerator.generateExampleData();
  }
}