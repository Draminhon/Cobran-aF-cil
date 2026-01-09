import 'package:cobranca_facil/homepage_screen.dart';
import 'package:cobranca_facil/model/client_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = openDatabase(
    join(await getDatabasesPath(), 'cliente_database.db'),

    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE clientes(id INTEGER PRIMARY KEY, name TEXT, divida DOUBLE, icon INTEGER, iconColor INTEGER)',
      );
    },
    version: 1,
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => ClientNotifier(),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: HomepageScreen());
  }
}
