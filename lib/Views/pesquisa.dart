import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:planner/Autenticador/login.dart';

class Pesquisa extends StatefulWidget {
  const Pesquisa({super.key});

  @override
  State<Pesquisa> createState() => _PesquisaState();
}

class _PesquisaState extends State<Pesquisa> {
  @override
  Widget build(BuildContext context) {
    // Para saber qual usuario atual use UserSession.getID()
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Pesquisar", style: TextStyle(
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
      body: Text("Implementar o calendario e listar as tarefas referentes ao dia selecionado 'Views/pesquisa.dart'"),
      // implementar um calendario (Pode usar um widget de calendario pronto da internet) ou usar datePicker
      // buscar no banco de dados as tarefas daquela data selecionada e listar (listview.builder() + gesturedetector())
    );
  }
}