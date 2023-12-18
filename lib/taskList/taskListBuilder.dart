import 'package:flutter/material.dart';
import 'package:planner/Widgets/emptyTask.dart';
import 'package:planner/taskList/taskExpanderWidget.dart';

class TaskListBuilder extends StatefulWidget {
  //passar a lista de tarefas
  bool removeIfComplete; // remove da lista se marcado como concluído, serve para usar na tela "Recentes"
  List<Map<String, dynamic>> list;
  TaskListBuilder({Key? key, required this.list, required this.removeIfComplete}) : super(key: key);

  @override

  @override
  State<TaskListBuilder> createState() => _TaskListBuilderState();
}

class _TaskListBuilderState extends State<TaskListBuilder> {
  int selectedIndex = -1;
  List<int> ignoreIndex = [];
  List<Map<String, dynamic>> listTask = [];

  @override
  void initState() {
    super.initState();
    listTask = List.from(widget.list);
  }

  //remover da lista pelo indice
  void removeTaskAtIndex(int index) {
    selectedIndex = -1;
    setState(() {
      ignoreIndex.add(index);
    });
    print(listTask);
  }

  //editado - atualizar edicao na lista
  void updateEdit(int index){

  }

  //marcar concluido - atualizar conclusao na lista, se revoveIfComplete == true remove da lista
  void changeCompleted(int index){
    if(widget.removeIfComplete){
      setState(() {
        ignoreIndex.add(index);
        selectedIndex = -1;
      });
    }else{
      setState(() {
        listTask[index] = Map<String, dynamic>.from(listTask[index]);
        listTask[index]['isCompleted'] = 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15,20,15,15),
      child: listTask.isEmpty
                ? Center(
                    child: EmptyList()
                  )
                :  
        ListView.builder(
        itemCount: listTask.length, //list.lenth
        itemBuilder: (context, index) {
          if (ignoreIndex.contains(index)) {
            return SizedBox.shrink();
          }
          return GestureDetector(
            onTap: (){
              selectedIndex == index ? selectedIndex = -1 : selectedIndex = index;
              print(selectedIndex);
              setState(() {
                
              });
            },
            child:TaskExpander(
              expand: selectedIndex == index ? false : true,
              onDelete: removeTaskAtIndex,
              onEdit: updateEdit,
              onCompleted: changeCompleted,
              id: listTask[index]['id'] as int,
              title: listTask[index]['title'],
              note: listTask[index]['note'],
              date: DateTime.parse(listTask[index]['date']),
              startTime: listTask[index]['startTime'],
              endTime: listTask[index]['endTime'],
              isCompleted: listTask[index]['isCompleted'] as int,
              color: listTask[index]['color'] as int,
              icon: listTask[index]['icon'] as int,
              indexListTask: index,
            ),
          );
        },
      ),
    );
  }
}
