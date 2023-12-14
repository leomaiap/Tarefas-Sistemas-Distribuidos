import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:planner/Autenticador/login.dart';
import 'package:planner/Widgets/dayWidget.dart';

class Recentes extends StatefulWidget {
  const Recentes({super.key});

  @override
  State<Recentes> createState() => _RecentesState();
}

class _RecentesState extends State<Recentes> {
  late DateTime today;
  int daySelected = 0;
  @override
  void initState() {
    super.initState();
    setState(() {
      today = DateTime.now();
    });
  }

  bool isSelected(int index) {
    return daySelected == index;
  }
  // Para saber qual usuario atual use UserSession.getID()
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Tarefas Recentes", style: TextStyle(
          fontWeight: FontWeight.bold
        ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const TelaLogin()));
            },
          ),
        ],
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              height: 130,
              padding: EdgeInsets.all(12),
              child: GridView.builder(
                itemCount: 5,
              gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                crossAxisSpacing: 0,
              ),
              itemBuilder:(context, index) {
                return GestureDetector(
                  onTap: () {
                    daySelected = index;
                    print(daySelected);
                    setState(() {
                      
                    });
                  },
                  child: Container(
                    child: DayCard(
                      day: today.add(Duration(days: index)), 
                      isSelected: isSelected(index)),
                  ),
                );
              },
              ),
            ),
            //Lista de tarefas aqui
            Container(
              //ListView.builder()
            )
          ],
        ),
      )
      // consultar o banco de dados referente ao usuari0 e a data, e listar as tarefas daquele dia (listview.builder() + gesturedetector())
    );
  }
}