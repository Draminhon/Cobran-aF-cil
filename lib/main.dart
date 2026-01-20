import 'package:cobranca_facil/database/sqflite_database.dart';
import 'package:cobranca_facil/notifiers/product_notifier.dart';
import 'package:cobranca_facil/screens/homepage_screen.dart';
import 'package:cobranca_facil/notifiers/client_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  openDatabase(
    join(await getDatabasesPath(), 'cliente_database.db'),
    onConfigure: (db) async {
      await db.execute('PRAGMA foreign_keys = ON');
    },
    version: 2,
    onOpen: (db) async {
      SqfliteDatabase().popularProdutosIniciais();
    },
    onCreate: (db, version) {
      db.execute(
        'CREATE TABLE clientes(id INTEGER PRIMARY KEY, name TEXT, divida DOUBLE, icon INTEGER, iconColor INTEGER)',
      );

      db.execute(
        'CREATE TABLE produtos(id INTEGER PRIMARY KEY, name TEXT, price DOUBLE, image TEXT)',
      );

      db.execute(
        'CREATE TABLE clientesProdutos(id INTEGER PRIMARY KEY, client_id INTEGER NOT NULL, product_id INTEGER NOT NULL, purchase_date INTEGER, quantidade INTEGER, FOREIGN KEY (client_id) REFERENCES clientes (id) ON DELETE CASCADE, FOREIGN KEY (product_id) REFERENCES produtos (id) ON DELETE CASCADE, UNIQUE(client_id, product_id) ON CONFLICT IGNORE)',
      );
    },
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ClientNotifier()),
        ChangeNotifierProvider(create: (context) => ProductNotifier()),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomepageScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
