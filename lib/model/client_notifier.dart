import 'package:cobranca_facil/database/sqflite_database.dart';
import 'package:cobranca_facil/model/client_model.dart';
import 'package:flutter/material.dart';

class ClientNotifier extends ChangeNotifier{
   List<ClientModel> _clients = [];

  List<ClientModel> get clients => _clients;

  void add (ClientModel client){
    _clients.add(client);
    notifyListeners();
  }

  Future<void> carregarClientes() async{
   _clients = await SqfliteDatabase().clientes();
   print(_clients);
    notifyListeners();
  }
}