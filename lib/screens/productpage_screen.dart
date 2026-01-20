import 'package:cobranca_facil/constants/color_constants.dart';
import 'package:cobranca_facil/database/sqflite_database.dart';
import 'package:cobranca_facil/notifiers/product_notifier.dart';
import 'package:cobranca_facil/screens/addproductpage_screen.dart';
import 'package:cobranca_facil/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductpageScreen extends StatefulWidget {
  const ProductpageScreen({super.key});

  @override
  State<ProductpageScreen> createState() => _ProductpageScreenState();
}

class _ProductpageScreenState extends State<ProductpageScreen> {
  
  Utils _utils = Utils();
  
  @override
  void initState() {
    Provider.of<ProductNotifier>(context, listen: false).carregarProdutos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var notifier = context.watch<ProductNotifier>();

    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white,
      actions: [IconButton(onPressed: () {
         Navigator.push(context, MaterialPageRoute(builder: (context) {
          return AddproductpageScreen();
        },));
      }, icon: Container(
        height: 30,
        width: 30,
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(10)
        ),
        child: Icon(Icons.add, color: Colors.white,)))],
      ),
      backgroundColor: ColorConstants.scaffold_color,
      body: ListView.builder(
        itemCount: notifier.produtos.length,
        itemBuilder: (context, index) {
          var produto = notifier.produtos[index];
          return Container(
            margin: EdgeInsets.only(top: 20, right: 20, left: 20),
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: ColorConstants.box_border_color),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // LEADING: Imagem do produto
                SizedBox(
                  width: 70,
                  height: 70,
                  child: _utils.displayImage(produto.image),
                ),

                const SizedBox(width: 16), // Espaço entre imagem e texto
                // TITLE + SUBTITLE: Informações do produto
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        produto.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ), // Pequeno ajuste entre nome e detalhes
                      Row(
                        children: [
                          Text(
                            "R\$ ${produto.price}",
                            style: const TextStyle(fontSize: 16),
                          ),
                          const Spacer(),
                          IconButton(onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return AddproductpageScreen(produto: produto,);
                            },));
                          }, icon: Icon(Icons.edit, color: Colors.green,)),
                          IconButton(onPressed: () {
                            SqfliteDatabase().deleteProduct(produto.id!);
                          
                            notifier.carregarProdutos();
                          }, icon: Icon(Icons.delete, color: Colors.red,))
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),

    );
  }
}
