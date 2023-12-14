import 'package:flutter/material.dart';
import 'package:planner/Page/mainPage.dart';
import 'package:planner/SQLite/sqlite.dart';
import 'package:planner/userSession.dart';

class NewTaskBoard extends StatefulWidget {
  const NewTaskBoard({super.key});

  @override
  State<NewTaskBoard> createState() => _NewTaskBoardState();
}


class _NewTaskBoardState extends State<NewTaskBoard> {
  TextEditingController nomeController = TextEditingController();
  late String nome;
  int selectColorIndex = 12;
  bool _nomeVazio = true;
  final db = DatabaseHelper();

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
      Colors.grey
    ];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    //double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorsList[selectColorIndex],
        title: Text("Novo Quadro de Tarefas", style: TextStyle(
          fontWeight: FontWeight.bold
        ),),
        leading:
          IconButton(
            icon: Icon(Icons.arrow_back_ios_new),
            onPressed: () {
              Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) =>  MainPage()));
            },
          ),
        
        centerTitle: true,
      ),
      body: Container(
        color: colorsList[selectColorIndex],
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Nome do Task Board",
                ),
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 0, 0, 0)),
                controller: nomeController,
                onChanged: (String value) {
                  nome = value;
                  //print(nome);
                  setState(() {
                    _nomeVazio = value.isEmpty;
                  });
                },
            ),
            Container(
              padding: EdgeInsets.all(8),
              margin: EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration( 
                color: Colors.white,       
                borderRadius: BorderRadius.circular(15),
              ),
              
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 20),
                    child: Text("Selecione uma cor",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                    ),)
                  ),
              SizedBox(
                width: screenWidth,
                height: 110,
                child: GridView.builder(
                    itemCount: 12,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 6,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5
                    ),
                    itemBuilder:(context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectColorIndex = index;
                            print(selectColorIndex);
                          });
                        },
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: colorsList[index % colorsList.length],
                            borderRadius: BorderRadius.circular(150),
                           
                          ),
                          child: selectColorIndex == index
                          ? Icon(
                              Icons.check_circle,
                              color: Colors.white,
                            )
                          : null,
                        ),
                      );
                    },))
                ],
              ),
            ),
            ElevatedButton(onPressed: _nomeVazio
                  ? null 
                  : () {
              db.insertTaskBoard(nome, selectColorIndex, UserSession.getID());
              print("$nome $selectColorIndex");
              Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MainPage()));
            }, child: Text("CRIAR QUADRO"))
          ],
        )
      )
    );
  }
}