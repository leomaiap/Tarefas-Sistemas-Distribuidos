import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:planner/Autenticador/login.dart';
import 'package:planner/Page/mainPage.dart';
import 'package:planner/SQLite/exampleData.dart';
import 'package:planner/SQLite/sqlite.dart';
import 'package:planner/Views/editTaskBoard.dart';
import 'package:planner/Views/newTaskBoard.dart';
import 'package:planner/Views/openTaskBoard.dart';
import 'package:planner/Widgets/emptyDashboard.dart';
import 'package:planner/userSession.dart';
import 'package:planner/widgets/taskboardWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  bool _isLongPressed = false;
  int? _indexPressed;
  Map<String, dynamic> boardPressed = {
    "id": null,
    "name": null,
    "icon": null,
    "color": null
  };

  @override
  void initState() {
    super.initState();
    taskBoardsFuture = db.getTaskBoardsByUserId(UserSession.getID());
  }

  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', false);
    prefs.remove('userId');

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const TelaLogin()));
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
    Widget? leadingWidget;
    if (_isLongPressed) {
      leadingWidget = IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          setState(() {
            _isLongPressed = false;
            _indexPressed = null;
          });
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: leadingWidget,
        title: Text(
          !_isLongPressed ? 'Dashboard' : "",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          if (!_isLongPressed) ...[
            const Text('Sair',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            IconButton(
              icon: const Icon(Icons.logout),
              iconSize: 20,
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Sair'),
                        content: const Text('Deseja sair?'),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('cancelar')),
                          TextButton(
                              onPressed: () {
                                //logout
                                logout();
                              },
                              child: const Text('sim')),
                        ],
                      );
                    });
                // Navigator.pushReplacement(context,
                //     MaterialPageRoute(builder: (context) => const TelaLogin()));
              },
            ),
          ] else ...[
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              iconSize: 20,
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditTaskBoard(
                            nome: boardPressed["name"],
                            color: boardPressed["color"],
                            icon: boardPressed["icon"],
                            id: boardPressed["id"])));
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete_outlined),
              iconSize: 20,
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Atenção!'),
                        content: const Text(
                            'Ao excluir um Quadro todas as tarefas relacionadas a ele serão excluídas também. Deseja continuar?'),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('cancelar')),
                          TextButton(
                              onPressed: () { 
                                Future.delayed(Duration.zero, () async {
                                  await db.deleteTaskBoard(boardPressed["id"]);
                                  taskBoardsFuture = db.getTaskBoardsByUserId(
                                      UserSession.getID());
                                  setState(() {
                                    _isLongPressed = false;
                                    _indexPressed = null;
                                  });
                                });
                                Future.delayed(
                                  const Duration(milliseconds: 500),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Row(
                                      children: [
                                        Icon(Icons.check, color: Colors.white),
                                        SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            "Quadro deletado com sucesso!",
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
                                Navigator.pop(context);
                                //print(boardPressed["id"]);
                              },
                              child: const Text('sim')),
                        ],
                      );
                    });
              },
            ),
          ]
        ],
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Bem-Vindo",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
                ),
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
                    backgroundColor:
                        Theme.of(context).colorScheme.primaryContainer,
                    foregroundColor:
                        Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                  child: const Row(
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
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erro: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                      child: GestureDetector(
                    onTap: () {
                      count++;
                      if (count == 10) {
                        _gerarDados();

                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MainPage()));
                      }
                    },
                    child: const EmptyDashboard(),
                  ));
                } else {
                  // Adicionando o campo isLongPressed em um novo snapshot
                  // List<Map<String, dynamic>> snapshotData =
                  //     snapshot.data!.map((data) {
                  //   var newData = Map<String, dynamic>.from(data);
                  //   newData["isLongPressed"] = false;
                  //   return newData;
                  // }).toList();
                  // List<Map<String, dynamic>> snapshotData =
                  //     snapshot.data!.map((taskBoard) {
                  //   return Map<String, dynamic>.from(taskBoard)
                  //     ..["isLongPressed"] =
                  //         (_indexPressed == snapshot.data!.indexOf(taskBoard));
                  // }).toList();
                  List<Map<String, dynamic>> snapshotData = [];
                  int index =
                      0; // Variável de índice para rastrear a posição no loop

                  for (var taskBoard in snapshot.data!) {
                    Map<String, dynamic> newTaskBoard =
                        Map<String, dynamic>.from(taskBoard);

                    newTaskBoard["isLongPressed"] =
                        _indexPressed == index ? true : false;
                    snapshotData.add(newTaskBoard);

                    index++;
                  }

                  // var snapshotData =
                  //     List<Map<String, dynamic>>.from(snapshot.data!);
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: GridView.builder(
                      itemCount: snapshot.data!.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 15,
                              mainAxisSpacing: 15),
                      itemBuilder: (context, index) {
                        // setState(() {
                        //   if (_indexPressed == index) {
                        //     snapshotData[index]["isLongPressed"] = true;
                        //   }
                        // });

                        return GestureDetector(
                          onTap: () {
                            if (_isLongPressed) {
                              snapshotData[index]["islongpressed"] = false;
                              _indexPressed = null;
                              _isLongPressed = false;
                              setState(() {});
                            } else {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OpenTaskBoard(
                                    name: snapshot.data![index]['name'],
                                    color:
                                        snapshot.data![index]['color'] as int,
                                    taskBoardID:
                                        snapshot.data![index]['id'] as int,
                                  ),
                                ),
                              );
                            }
                          },
                          onLongPress: () {
                            boardPressed["name"] =
                                snapshot.data![index]['name'];
                            boardPressed["id"] =
                                snapshot.data![index]['id'] as int;
                            boardPressed["color"] =
                                snapshot.data![index]['color'] as int;
                            boardPressed["icon"] =
                                snapshot.data![index]['icon'] as int;
                            setState(() {
                              _isLongPressed = !_isLongPressed;
                              _isLongPressed
                                  ? _indexPressed = index
                                  : _indexPressed = null;

                              snapshotData[index]["isLongPressed"] =
                                  _isLongPressed;
                            });
                          },
                          child: Container(
                            child: TaskBoardCard(
                                    name: snapshot.data![index]['name'],
                                    color:
                                        snapshot.data![index]['color'] as int,
                                    icon: snapshot.data![index]['icon'] as int,
                                    taskBoardID:
                                        snapshot.data![index]['id'] as int,
                                    isLongPressed: snapshotData[index]
                                        ["isLongPressed"])
                                .animate()
                                .fadeIn(delay: ((index) * 20).ms)
                                .fade(),
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
