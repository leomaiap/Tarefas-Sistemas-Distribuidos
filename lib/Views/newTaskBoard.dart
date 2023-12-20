import 'package:flutter/material.dart';
import 'package:planner/Page/mainPage.dart';
import 'package:planner/SQLite/sqlite.dart';
import 'package:planner/Widgets/taskboardWidget.dart';
import 'package:planner/userSession.dart';

class NewTaskBoard extends StatefulWidget {
  const NewTaskBoard({super.key});

  @override
  State<NewTaskBoard> createState() => _NewTaskBoardState();
}

class _NewTaskBoardState extends State<NewTaskBoard> {
  TextEditingController nomeController = TextEditingController();
  final TextEditingController iconController = TextEditingController();
  late String nome;
  int selectColorIndex = 0;
  IconLabel? selectedIcon;
  bool _nomeVazio = true;
  bool _iconeVazio = true;
  final db = DatabaseHelper();

  List<Color> colorsList = [
    const Color(0xFFD7423D),
    const Color(0xFFFFE066),
    const Color(0xFFFFBA59),
    const Color(0xFFFF8C8C),
    const Color(0xFFFF99E5),
    const Color(0xFFC3A6FF),
    const Color(0xFF9FBCF5),
    const Color(0xFF8CE2FF),
    const Color(0xFF87F5B5),
    const Color(0xFFBCF593),
    const Color(0xFFE2F587),
    const Color(0xFFD9BCAD),
    Colors.grey.shade50
  ];

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
    double screenWidth = MediaQuery.of(context).size.width;
    //double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          //backgroundColor: colorsList[selectColorIndex],
          title: const Text(
            "Novo Quadro de Tarefas",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => const MainPage()));
            },
          ),
          centerTitle: true,
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Container(
                //color: colorsList[selectColorIndex],
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                          labelText: 'Nome TaskBoard',
                          prefixIcon: Icon(Icons.add),
                          border: OutlineInputBorder(),
                          filled: false),
                      style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 0, 0, 0)),
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
                      padding: const EdgeInsets.all(15),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: [
                          Container(
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              child: Text(
                                "Selecione uma cor",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground),
                              )),
                          //Selcao de cor
                          SizedBox(
                              width: screenWidth,
                              height: 110,
                              child: GridView.builder(
                                itemCount: 12,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 6,
                                        crossAxisSpacing: 5,
                                        mainAxisSpacing: 5),
                                itemBuilder: (context, index) {
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
                                        color: colorsList[
                                            index % colorsList.length],
                                        borderRadius:
                                            BorderRadius.circular(150),
                                      ),
                                      child: selectColorIndex == index
                                          ? Icon(
                                              Icons.check_circle,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .background,
                                            )
                                          : null,
                                    ),
                                  );
                                },
                              )),
                          Container(
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              child: Text(
                                "Selecione um ícone",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground),
                              )),

                          //selecao de icone
                          SizedBox(
                            width: screenWidth,
                            height: 170,
                            child: GridView.builder(
                              itemCount: IconLabel.values.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 8,
                                crossAxisSpacing: 4,
                                mainAxisSpacing: 8,
                              ),
                              itemBuilder: (context, index) {
                                final icon = IconLabel.values[index];
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedIcon = icon;
                                      _iconeVazio = icon == null
                                          ? true
                                          : icon.label.isEmpty;
                                    });
                                  },
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: selectedIcon == icon
                                          ? colorsList[selectColorIndex]
                                          : Theme.of(context)
                                              .colorScheme
                                              .background,
                                      borderRadius: BorderRadius.circular(150),
                                    ),
                                    child: Icon(icon.icon,
                                        color: modifyColor(
                                            colorsList[selectColorIndex],
                                            -120)),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                        onPressed: (_nomeVazio || _iconeVazio)
                            ? null
                            : () {
                                db.insertTaskBoard(nome, selectColorIndex,
                                    selectedIcon!.index, UserSession.getID());
                                print("$nome $selectColorIndex");

                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const MainPage()));
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
                                            "Quadro adicionado com sucesso!",
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
                              },
                        child: const Text("CRIAR QUADRO"))
                  ],
                )),
          ),
        ));
  }
}
