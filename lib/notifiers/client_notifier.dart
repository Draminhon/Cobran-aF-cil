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
    notifyListeners();
  }

  Future<void> abaterDividaCliente(ClientModel client, double divida) async{

    int idCliente = client.id!;
    final clientSelected = _clients.firstWhere((element) => element.id == idCliente,);

    print("Valor subtraido: ${(clientSelected.divida - divida)}");
    ClientModel newClient = ClientModel(
      id: client.id,
      divida: (clientSelected.divida - divida),
     icon: client.icon, 
     iconColor: client.iconColor, 
     name: client.name);

    await SqfliteDatabase().updateClient(newClient);
    notifyListeners();


  }
}