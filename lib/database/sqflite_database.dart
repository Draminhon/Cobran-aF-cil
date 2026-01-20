import 'package:cobranca_facil/model/client_model.dart';
import 'package:cobranca_facil/model/product_model.dart';
import 'package:cobranca_facil/repository/products_repository.dart';
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
          icon: icon,
          iconColor: Color(iconColor),
          name: name,
        ),
    ];
  }

  Future<void> updateClient(ClientModel cliente) async {
    final db = await _getDatabase();

    await db.update(
      'clientes',
      cliente.toMap(),

      where: 'id = ?',

      whereArgs: [cliente.id],
    );
  }

  //produto
  Future<void> popularProdutosIniciais() async {
    final db = await _getDatabase();

    final List<Map<String, dynamic>> existente = await db.query('produtos');

    if (existente.isEmpty) {
      final repository = ProductsRepository();

      await db.transaction((txn) async {
        for (var produto in repository.products) {
          await txn.insert('produtos', produto.toMap());
        }
      });
      print("Produtos inseridos com sucesso");
    }
  }

  Future<List<ProductModel>> produtos() async {
    final db = await _getDatabase();

    final List<Map<String, Object?>> produtosMaps = await db.query('produtos');

    return [
      for (final {
            'id': id as int,
            'name': name as String,
            'price': price as double,
            'image': image as String,
          }
          in produtosMaps)
        ProductModel(id: id, name: name, price: price, image: image),
    ];
  }

Future<void> insertProduto(ProductModel produto) async{
  final db = await _getDatabase();

  await db.insert(
    'produtos',
    produto.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace
  );
}

Future<void> updateProduct(ProductModel produto) async {
  final db = await _getDatabase();

  await db.update('produtos',
   produto.toMap(),
   where: 'id = ?',
   whereArgs: [produto.id],
   );
}

Future<void> deleteProduct(int productId) async{
  final db = await _getDatabase();

  await db.delete(
    'produtos',
    where: 'id = ?',
    whereArgs: [productId]
  );
}
  //produtoCliente
Future<void> vincularProdutoECliente(int clienteId, int produtoId) async {
  final db = await _getDatabase();

  await db.transaction((txn) async {
    List<Map<String, dynamic>> produtoRes = await txn.query(
      'produtos', 
      columns: ['price'],
      where: 'id = ?',
      whereArgs: [produtoId],
    );

    if (produtoRes.isEmpty) return;
    double precoProduto = double.parse(produtoRes.first['price'].toString());

    List<Map<String, dynamic>> res = await txn.query(
      'clientesProdutos',
      where: 'client_id = ? AND product_id = ?',
      whereArgs: [clienteId, produtoId],
    );

    if (res.isNotEmpty) {
      int quantidadeAtual = res.first['quantidade'] as int;
      await txn.update(
        'clientesProdutos',
        {'quantidade': quantidadeAtual + 1},
        where: 'client_id = ? AND product_id = ?',
        whereArgs: [clienteId, produtoId],
      );
    } else {
      await txn.insert('clientesProdutos', {
        'client_id': clienteId,
        'product_id': produtoId,
        'quantidade': 1,
        'purchase_date': DateTime.now().millisecondsSinceEpoch,
      });
    }

    await txn.rawUpdate(
      'UPDATE clientes SET divida = divida + ? WHERE id = ?',
      [precoProduto, clienteId],
    );
  });
}


Future<void> removerProdutoDoCliente(int clientId, int produtoId) async {

  final db = await _getDatabase();

  await db.transaction((txn) async {
    
        List<Map<String, dynamic>> produtoRes = await txn.query(
      'produtos', 
      columns: ['price'],
      where: 'id = ?',
      whereArgs: [produtoId],
    );

      if(produtoRes.isEmpty) return;
      double precoProduto = double.parse(produtoRes.first['price'].toString());

      List<Map<String, dynamic>> res = await txn.query(
        'clientesProdutos',
        where: 'client_id = ? AND product_id = ?',
        whereArgs: [clientId, produtoId] 
      );

      if (res.isNotEmpty){
        int quantidadeAtual = res.first['quantidade'] as int;
                 if(quantidadeAtual == 1){
          await txn.delete('clientesProdutos',
          where: 'client_id = ? AND product_id = ?',
          whereArgs: [clientId, produtoId]
          );
         }else{
 await txn.update('clientesProdutos',
         {
          'quantidade': quantidadeAtual -1
         },
         where: 'client_id = ? AND product_id = ?',
         whereArgs: [clientId, produtoId]
         );
         }
       

         await txn.rawUpdate('UPDATE clientes SET divida = divida - ? WHERE id = ?',
          [precoProduto, clientId]
         );


      }



  },);


}
  Future<List<Map<String, dynamic>>> produtoClienteResultado(
    int idCliente,
  ) async {
    final db = await _getDatabase();

    return await db.rawQuery(
      '''
    SELECT p.*,
    cp.quantidade
     FROM produtos p
    INNER JOIN clientesProdutos cp ON p.id = cp.product_id
    WHERE cp.client_id = ?
''',
      [idCliente],
    );
  }

  Future<void> deletarCliente(int idCliente) async{
    final db = await _getDatabase();

    await db.delete('clientes',
    where: 'id = ?',
    whereArgs: [idCliente]
    );



  }
}
