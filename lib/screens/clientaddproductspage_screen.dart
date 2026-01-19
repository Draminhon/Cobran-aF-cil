import 'package:cobranca_facil/constants/color_constants.dart';
import 'package:cobranca_facil/database/sqflite_database.dart';
import 'package:cobranca_facil/notifiers/client_notifier.dart';
import 'package:cobranca_facil/notifiers/product_notifier.dart';
import 'package:cobranca_facil/repository/products_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClientaddproductspageScreen extends StatefulWidget {
  final int idCliente;
  const ClientaddproductspageScreen({super.key, required this.idCliente});

  @override
  State<ClientaddproductspageScreen> createState() =>
      _ClientaddproductspageScreenState();
}

class _ClientaddproductspageScreenState
    extends State<ClientaddproductspageScreen> {
  final _dbSql = SqfliteDatabase();
  
  @override
  void initState() {
    Provider.of<ProductNotifier>(context, listen:false).carregarProdutos();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var notifier = context.watch<ProductNotifier>();

    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white),
      backgroundColor: ColorConstants.scaffold_color,
      body: GridView.builder(
        itemCount: notifier.produtos.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () async {
              _dbSql.vincularProdutoECliente(widget.idCliente, notifier.produtos[index].id!);
                if(mounted){
                  Provider.of<ClientNotifier>(context, listen: false).carregarClientes();
                }

                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Produto adicionado!"),duration: Duration(milliseconds: 200),));
            },
            child: Container(
              margin: EdgeInsets.only(top: 20, left: 20, right: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: ColorConstants.box_border_color,
                  strokeAlign: 0.5,
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: 10,),
                  Expanded(
                    child: SizedBox(child: Image.asset(notifier.produtos[index].image)),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      notifier.produtos[index].name,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 90),
                    child: Text(
                      "R\$ ${notifier.produtos[index].price}",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),

                ],
              ),
            ),
          );
        },
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
      ),
    );
  }
}
