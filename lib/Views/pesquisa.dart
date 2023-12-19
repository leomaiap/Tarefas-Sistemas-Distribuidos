import 'package:flutter/material.dart';
import 'package:planner/Autenticador/login.dart';
import 'package:planner/SQLite/sqlite.dart';
import 'package:planner/taskList/taskListBuilder.dart';
import 'package:planner/userSession.dart';
import 'package:table_calendar/table_calendar.dart';

class Pesquisa extends StatefulWidget {
  const Pesquisa({super.key});

  @override
  State<Pesquisa> createState() => _PesquisaState();
}

class _PesquisaState extends State<Pesquisa> {
  final TextEditingController _searchController = TextEditingController();
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  ValueNotifier<Map<DateTime, List<dynamic>>> _currentMonth = ValueNotifier({});
  CalendarFormat _calendarFormat = CalendarFormat.month;
  List<Map<String, dynamic>> selectedTasks = [];
  final int _userId = UserSession.getID();
  bool _isSearching = false;
  late Future<List<Map<String, dynamic>>> futureSelectedTasks;

  final db = DatabaseHelper();

  // Retorna a lista de dias de um mês
  Future<Map<DateTime, List<dynamic>>> getTaskDaysOfMonth(
      int year, int month) async {
    List<DateTime> days = [];


    DateTime firstDayOfMonth = DateTime(year, month, 1);

    DateTime firstDayOfNextMonth =
        month < 12 ? DateTime(year, month + 1, 1) : DateTime(year + 1, 1, 1);

    for (DateTime day = firstDayOfMonth;
        day.isBefore(firstDayOfNextMonth);
        day = day.add(const Duration(days: 1))) {
      days.add(day);
    }

    List<Map<String, dynamic>> daysWithTasks =
        await db.getTasksByMonth(_userId, days);

    Map<DateTime, List<dynamic>> finalDays = {};
    for (Map<String, dynamic> day in daysWithTasks) {
      DateTime auxDay = DateTime.parse(day["date"]);
      finalDays[DateTime.utc(
          auxDay.year,
          auxDay.month,
          auxDay.day,
          auxDay.hour,
          auxDay.minute,
          auxDay.second,
          auxDay.millisecond,
          auxDay.microsecond)] = [auxDay];
    }

    return finalDays;
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      _currentMonth = ValueNotifier(
          await getTaskDaysOfMonth(_focusedDay.year, _focusedDay.month));
      List<Map<String, dynamic>> tasks = await futureSelectedTasks;
      setState(() {
        if (tasks.isNotEmpty) {
          _calendarFormat = CalendarFormat.twoWeeks;
        }
      });
    });

    futureSelectedTasks = db.getTasksByDay(_userId, _selectedDay);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Para saber qual usuario atual use UserSession.getID()
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(-1.0, 0.0),
                  end: const Offset(0.0, 0.0),
                ).animate(animation),
                child: child,
              );
            },
            child: _isSearching
                ? TextField(
                    key: const ValueKey('SearchBar'),
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Pesquisar...',
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      futureSelectedTasks =
                          db.getTasksBySearch(_userId, _searchController.text);
                      setState(() {});
                    },
                  )
                : const Text(
                    "Calendário",
                    key: ValueKey('Title'),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
          ),
          actions: [
            IconButton(
              icon: Icon(_isSearching ? Icons.cancel : Icons.search),
              onPressed: () {
                setState(() {
                  _isSearching = !_isSearching;
                });
              },
            ),
            if (!_isSearching)
              IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const TelaLogin()));
                  })
          ],
          centerTitle: true,
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (!_isSearching)
                TableCalendar(
                  // shouldFillViewport: true,
                  firstDay: DateTime.utc(2019, 10, 16),
                  lastDay: DateTime.utc(2030, 3, 14),
                  focusedDay: _focusedDay,
                  calendarStyle: const CalendarStyle(
                    cellMargin:
                        EdgeInsets.all(2), // Reduz a margem entre as células

                    outsideDaysVisible: false,
                  ),
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) async {
                    futureSelectedTasks =
                        db.getTasksByDay(_userId, selectedDay);
                    List<Map<String, dynamic>> tasks =
                        await futureSelectedTasks;
                    setState(() {
                      if (tasks.isNotEmpty) {
                        _calendarFormat = CalendarFormat.twoWeeks;
                      }
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  calendarFormat: _calendarFormat,
                  onFormatChanged: (format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  },
                  onPageChanged: (focusedDay) async {
                    _focusedDay = focusedDay;
                    Map<DateTime, List<dynamic>> newEvents =
                        await getTaskDaysOfMonth(
                            focusedDay.year, focusedDay.month);
                    _currentMonth.value = newEvents;
                    setState(() {});
                  },
                  eventLoader: (DateTime day) {
                    return _currentMonth.value[day] ?? [];
                  },
                ),
              Expanded(
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: futureSelectedTasks,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      print('wait');
                      return Container();
                    } else if (snapshot.hasError) {
                      return Text('Erro: ${snapshot.error}');
                    } else {
                      List<Map<String, dynamic>> selectedTasks = snapshot.data!;

                      return TaskListBuilder(
                          removeIfComplete: false, list: selectedTasks);
                    }
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
