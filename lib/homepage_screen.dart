import 'package:cobranca_facil/constants/color_constants.dart';
import 'package:cobranca_facil/database/sqflite_database.dart';
import 'package:cobranca_facil/model/client_model.dart';
import 'package:cobranca_facil/model/client_notifier.dart';
import 'package:cobranca_facil/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomepageScreen extends StatefulWidget {
  const HomepageScreen({super.key});

  @override
  State<HomepageScreen> createState() => _HomepageScreenState();
}

class _HomepageScreenState extends State<HomepageScreen> {
  final _utils = Utils();
  final _sql = SqfliteDatabase();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.scaffold_color,

      body: Consumer<ClientNotifier>(
        builder: (context, value, child) {
          value.carregarClientes();
          return GridView.builder(
            padding: EdgeInsetsGeometry.only(top: 70),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemCount: value.clients.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return Placeholder();
                      },));
                    },
                    child: Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: ColorConstants.box_border_color,
                          width: 0.5,
                        ),
                      ),
                      child: Icon(
                        value.clients[index].icon,
                        color: value.clients[index].iconColor,
                        size: 80,
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    value.clients[index].name,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ],
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          final cliente = ClientModel(
            divida: 0,
            icon: _utils.randomIcon(),

            iconColor: _utils.randomColor(),
            name: "Novo Cliente",
          );
          _sql.insertClient(cliente);
        },
        child: Text(
          "+",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
