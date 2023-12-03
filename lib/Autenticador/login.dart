import 'package:flutter/material.dart';
import 'package:planner/Autenticador/cadastrar.dart';
import 'package:planner/JsonModels/usuarios.dart';
import 'package:planner/SQLite/sqlite.dart';
import 'package:planner/Views/dashboard.dart';

class TelaLogin extends StatefulWidget {
  const TelaLogin({super.key});

  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  final usuario = TextEditingController();
  final senha = TextEditingController();
  bool isVisivel = false; //MOSTRAR E ESCONDER SENHA
  bool isLoginTrue = false;
  final db = DatabaseHelper();

  login() async {
    var response = await db
        .login(Usuarios(usrName: usuario.text, usrPassword: senha.text));
    if (response == true) {
      //Se o login tiver correto, vai p o dashboard
      if (!mounted) return;
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const Dashboard()));
    } else {
      //Se o login n tiver correto, mostra msg de erro
      setState(() {
        isLoginTrue = true;
      });
    }
  }

  final formKey = GlobalKey<FormState>(); //GLOBAL KEY P/ O FORM
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            //COLOCANDO TUDO NO TEXFIELD P/ UM FORM
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  //Campo de Usuário
                  Image.asset(
                    "lib/assets/login.png",
                    width: 210,
                  ),
                  const SizedBox(height: 15),
                  Container(
                    margin: const EdgeInsets.all(8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.blueGrey.withOpacity(.2)),
                    child: TextFormField(
                      controller: usuario,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "usuário é necessário";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        icon: Icon(Icons.person),
                        border: InputBorder.none,
                        hintText: "Usuário",
                      ),
                    ),
                  ),

                  //Campo da Senha
                  Container(
                    margin: const EdgeInsets.all(8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.blueGrey.withOpacity(.2)),
                    child: TextFormField(
                      controller: senha,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "senha é necessária";
                        }
                        return null;
                      },
                      obscureText: !isVisivel,
                      decoration: InputDecoration(
                          icon: const Icon(Icons.lock),
                          border: InputBorder.none,
                          hintText: "Senha",
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                isVisivel = !isVisivel;
                              });
                            },
                            icon: Icon(isVisivel
                                ? Icons.visibility
                                : Icons.visibility_off),
                          )),
                    ),
                  ),

                  const SizedBox(height: 10),
                  //Botão de Login
                  Container(
                    height: 55,
                    width: MediaQuery.of(context).size.width * .9,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.blueGrey),
                    child: TextButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            //METODO DO LOGIN CMC AQUI
                            login();
                          }
                        },
                        child: Text(
                          "LOGIN",
                          style: TextStyle(color: Colors.white),
                        )),
                  ),

                  //Botao Cadastrar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Não tem uma Conta?"),
                      TextButton(
                          onPressed: () {
                            //NAVIGATE PARA CRIAR CONTA
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Cadastro()));
                          },
                          child: const Text("CRIAR CONTA"))
                    ],
                  ),

                  isLoginTrue
                      ? const Text(
                          "Usuário ou Senha está incorreta",
                          style: TextStyle(color: Colors.red),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
