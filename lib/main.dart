import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:planner/Autenticador/login.dart';
import 'package:planner/SQLite/sqlite.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  Intl.defaultLocale = 'pt_BR';
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('pt', 'BR'), // Português do Brasil
        // ... outros idiomas suportados
      ],
      debugShowCheckedModeBanner: false,
      title: 'Planner',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
      home: const TelaLogin(),
    );
  }
}
