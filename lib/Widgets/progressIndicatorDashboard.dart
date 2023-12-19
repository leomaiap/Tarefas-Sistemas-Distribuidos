import 'package:flutter/material.dart';

class TaskProgressIndicatorDashboard extends StatelessWidget {
  final int completedTasks;
  final int totalTasks;
  final Color color;

  TaskProgressIndicatorDashboard({required this.completedTasks, required this.totalTasks, required this.color});

  @override
  Widget build(BuildContext context) {
    double progress = totalTasks > 0 ? completedTasks / totalTasks : 0.0;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child:
        LinearProgressIndicator(
          value: progress,
          backgroundColor: color.withOpacity(0.3),
          valueColor: AlwaysStoppedAnimation<Color>(color.withOpacity(0.5)),
          minHeight:7,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
    );
  }
}
