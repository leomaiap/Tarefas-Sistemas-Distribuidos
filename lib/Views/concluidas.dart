import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:planner/Autenticador/login.dart';

class Concluidas extends StatefulWidget {
  const Concluidas({super.key});

  @override
  State<Concluidas> createState() => _ConcluidasState();
}

class _ConcluidasState extends State<Concluidas> {
  // Para saber qual usuario atual use UserSession.getID()
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Tarefas concluídas", style: TextStyle(
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
      body: Text("Implementar, listar tarefas marcadas como concluidas 'Views/concluidas.dart'"),
      // buscar do banco de dados todas as tarefas daquele usuario que esteja concluida = True, (listview.builder() + gesturedetector())
    );
  }
}