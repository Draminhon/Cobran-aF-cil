import 'package:cobranca_facil/model/client_model.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqfliteDatabase {
  Future<Database> _getDatabase() async {
    return openDatabase(join(await getDatabasesPath(), 'cliente_database.db'));
  }

  Future<void> insertClient(ClientModel cliente) async {
    final db = await _getDatabase();

    await db.insert(
      'clientes',
      cliente.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<ClientModel>> clientes() async {
    final db = await _getDatabase();

    final List<Map<String, Object?>> clienteMaps = await db.query('clientes');

    return [
      for (final {
            'id': id as int,
            'name': name as String,
            'icon': icon as int,
            'iconColor': iconColor as int,
            'divida': divida as double,
          }
          in clienteMaps)
        ClientModel(
          id: id,
          divida: divida,
          icon: IconData(icon, fontFamily: 'MaterialIcons'),
          iconColor: Color(iconColor),
          name: name,
        ),
    ];
  }
}
