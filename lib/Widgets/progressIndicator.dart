import 'package:flutter/material.dart';

class TaskProgressIndicator extends StatelessWidget {
  final int completedTasks;
  final int totalTasks;

  const TaskProgressIndicator({super.key, required this.completedTasks, required this.totalTasks});

  @override
  Widget build(BuildContext context) {
    double progress = totalTasks > 0 ? completedTasks / totalTasks : 0.0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(right: 3),
            child: const Icon(Icons.task_alt, size: 15,),
          ),
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: Text('$completedTasks de $totalTasks Tarefas', style: const TextStyle(fontWeight: FontWeight.w600),)
          ),
                    
          Expanded(
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.4),
              valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary),
              minHeight: 12,
              borderRadius: const BorderRadius.all(Radius.circular(8)),
            ),
          ),
        ],
      ),
    );
  }
}
