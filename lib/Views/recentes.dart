import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:planner/Autenticador/login.dart';

class Recentes extends StatefulWidget {
  const Recentes({super.key});

  @override
  State<Recentes> createState() => _RecentesState();
}

class _RecentesState extends State<Recentes> {
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
      body: Text("Implementar as tarefas mais urgentes dos proximos 5 dias 'Views/recentes.dart'"),
      // Implementar escolher 5 dias
      // consultar o banco de dados referente ao usuari0 e a data, e listar as tarefas daquele dia (listview.builder() + gesturedetector())
    );
  }
}