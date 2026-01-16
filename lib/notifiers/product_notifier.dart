
import 'package:cobranca_facil/database/sqflite_database.dart';
import 'package:cobranca_facil/model/product_model.dart';
import 'package:flutter/material.dart';

class ProductNotifier  extends ChangeNotifier{

     List<ProductModel> _produtos = [];

    List<ProductModel> get produtos => _produtos;

    void add(ProductModel produto){
      _produtos.add(produto);
      notifyListeners();
    }


    Future<void> carregarProdutos() async{
      _produtos = await SqfliteDatabase().produtos();
      notifyListeners();
    }



}