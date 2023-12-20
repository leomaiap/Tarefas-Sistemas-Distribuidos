import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DayCard extends StatelessWidget {
  DateTime day;
  bool isSelected;
  bool hasTask;
  DayCard({super.key, required this.day, required this.isSelected, required this.hasTask});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (isSelected){
      return Container(
          decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: const BorderRadius.all(Radius.circular(8))
        ),
        child: Container(
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(DateFormat.MMM().format(day), style: TextStyle(
                fontSize: screenWidth*0.03,
                color: Colors.white
              ),),
              Text("${day.day}",  style: TextStyle(
                fontSize: screenWidth*0.05,
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),),
              Icon(Icons.circle, size: 7, color: hasTask ? Theme.of(context).colorScheme.primaryContainer : Colors.transparent),
              Text(DateFormat.E().format(day), style: TextStyle(
                fontSize: screenWidth*0.03,
                color: Colors.white))
            ],
          )
        ),
          
      );
    }
    else{
      return Container(
        decoration: const BoxDecoration(
        color: Colors.transparent
      ),
      child: Container(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(DateFormat.MMM().format(day), style: TextStyle(
              fontSize: screenWidth*0.03,
              
            ),),
            Text("${day.day}",  style: TextStyle(
              fontSize: screenWidth*0.05,
              fontWeight: FontWeight.bold,
              
            ),),
            Icon(Icons.circle, size: 7, color: hasTask ? Theme.of(context).colorScheme.primary : Colors.transparent),
            Text(DateFormat.E().format(day))
          ],
        )
      ),
    );
    }
    
  }
}