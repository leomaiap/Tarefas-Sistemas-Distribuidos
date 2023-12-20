import 'package:flutter/material.dart';
import 'package:planner/Autenticador/login.dart';
import 'package:planner/JsonModels/usuarios.dart';
import 'package:planner/SQLite/sqlite.dart';

class Cadastro extends StatefulWidget {
  const Cadastro({super.key});

  @override
  State<Cadastro> createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  final usuario = TextEditingController();
  final senha = TextEditingController();
  final confirmarSenha = TextEditingController();

  final formKey = GlobalKey<FormState>();

  bool isVisivel = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //SingleChildScrollView p ter um scrol na tela
        body: Center(
      child: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //COPIAR O TEXTFIELD ANTERIOR Q FIZEMOS P PREVENIR TIME CONSUMING

                const ListTile(
                  title: Text("Registrar Nova Conta",
                      style:
                          TextStyle(fontSize: 55, fontWeight: FontWeight.bold)),
                ),

                //AS

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
                    decoration: const InputDecoration(
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
                            //criar click p mostrar e esconder senha
                            setState(() {
                              //alternar
                              isVisivel = !isVisivel;
                            });
                          },
                          icon: Icon(isVisivel
                              ? Icons.visibility
                              : Icons.visibility_off),
                        )),
                  ),
                ),

                //Campo para Confirmação de Senha
                //Agora checamos qnd as senhas são iguais ou n
                Container(
                  margin: const EdgeInsets.all(8),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.blueGrey.withOpacity(.2)),
                  child: TextFormField(
                    controller: confirmarSenha,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "senha é necessária";
                      } else if (senha.text != confirmarSenha.text) {
                        return "Senhas não coincidem";
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
                            //criar click p mostrar e esconder senha
                            setState(() {
                              //botao alternar
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

                          final db = DatabaseHelper();
                          db
                              .signup(Usuarios(
                                  usrName: usuario.text,
                                  usrPassword: senha.text))
                              .whenComplete(() {
                            //Depois de criar conta com sucesso volta p tela de login
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const TelaLogin()));
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
                                        "Usuário cadastrado com sucesso!",
                                        style: TextStyle(color: Colors.white),
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
                          });
                        }
                      },
                      child: const Text(
                        "CRIAR CONTA",
                        style: TextStyle(color: Colors.white),
                      )),
                ),

                //Botao Cadastrar
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Já tem uma Conta?"),
                    TextButton(
                        onPressed: () {
                          //NAVIGATE PARA CRIAR CONTA
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const TelaLogin()));
                        },
                        child: const Text("LOGIN"))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
