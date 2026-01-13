import 'package:cobranca_facil/constants/color_constants.dart';
import 'package:cobranca_facil/repository/products_repository.dart';
import 'package:flutter/material.dart';

class ClientaddproductspageScreen extends StatefulWidget {
  const ClientaddproductspageScreen({super.key});

  @override
  State<ClientaddproductspageScreen> createState() =>
      _ClientaddproductspageScreenState();
}

class _ClientaddproductspageScreenState
    extends State<ClientaddproductspageScreen> {
  final _products = ProductsRepository().products;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white),
      backgroundColor: ColorConstants.scaffold_color,
      body: ListView.builder(
        itemCount: _products.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              
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
              child: Row(
                children: [
                  SizedBox(
                    height: 66,
                    child: Image.asset(_products[index].image),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _products[index].name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "R\$ ${_products[index].price}",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
