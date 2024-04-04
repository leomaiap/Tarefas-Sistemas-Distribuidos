import 'package:flutter/material.dart';
import 'package:planner/Views/concluidas.dart';
import 'package:planner/Views/dashboard.dart';
import 'package:planner/Views/pesquisa.dart';
import 'package:planner/Views/recentes.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int indexPage = 0;
  final pages = [const Dashboard(), const Pesquisa(), const Concluidas(), const Recentes()];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: pages[indexPage],
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
        indicatorColor: Theme.of(context).colorScheme.primary.withOpacity(0.8),
        backgroundColor: Theme.of(context).colorScheme.background),
        child: NavigationBar(
            selectedIndex: indexPage,
            onDestinationSelected: (value) {
              setState(() {
                indexPage = value;
              });
            },
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.dashboard_outlined),
                label: 'Dashboard',
                selectedIcon: Icon(Icons.dashboard_rounded),
              ),
              NavigationDestination(
                icon: Icon(Icons.calendar_month_outlined),
                label: 'Pesquisar',
                selectedIcon: Icon(Icons.calendar_month),
              ),
              NavigationDestination(
                icon: Icon(Icons.task_alt),
                label: 'Concluidas',
              ),
              NavigationDestination(
                icon: Icon(Icons.schedule),
                label: 'Recentes',
              ),
            ]),
      ),
    );
  }
}
