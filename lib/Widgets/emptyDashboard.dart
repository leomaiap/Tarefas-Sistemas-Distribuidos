import 'package:flutter/material.dart';

class EmptyDashboard extends StatelessWidget {
  const EmptyDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                child: Text(
              "Sem quadros",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            )),
            Image.asset(
              "lib/assets/astronaut.gif",
              width: 1000,
              color: Theme.of(context).colorScheme.background,
              colorBlendMode: BlendMode.multiply,
            )
          ],
        ),
      ),
    );
  }
}
