import 'package:cobranca_facil/constants/color_constants.dart';
import 'package:cobranca_facil/database/sqflite_database.dart';
import 'package:cobranca_facil/model/client_model.dart';
import 'package:cobranca_facil/notifiers/client_notifier.dart';
import 'package:cobranca_facil/screens/clientpage_screen.dart';
import 'package:cobranca_facil/screens/productpage_screen.dart';
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
  void initState() {
    Provider.of<ClientNotifier>(context, listen: false).carregarClientes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var notifier = context.watch<ClientNotifier>();

    return Scaffold(
      backgroundColor: ColorConstants.scaffold_color,

      body: GridView.builder(
        padding: EdgeInsetsGeometry.only(top: 70),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemCount: notifier.clients.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return ClientpageScreen(
                          client: notifier.clients[index],
                        );
                      },
                      settings: RouteSettings(
                        arguments: {'idCliente': notifier.clients[index].id},
                      ),
                    ),
                  );
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
                    IconData(notifier.clients[index].icon, fontFamily: 'MaterialIcons'),
                    color: notifier.clients[index].iconColor,
                    size: 80,
                  ),
                ),
              ),
              SizedBox(height: 15),
              Text(
                notifier.clients[index].name,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ],
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Column(
            children: [
              FloatingActionButton(
                heroTag: "hero_tag_add_client",

                backgroundColor: Colors.green,
                onPressed: () {
                  final cliente = ClientModel(
                    divida: 0,
                    icon: _utils.randomIcon().codePoint,

                    iconColor: _utils.randomColor(),
                    name: "Novo Cliente",
                  );
                  _sql.insertClient(cliente);
                  notifier.carregarClientes();
                },
                child: Icon(Icons.person, color: Colors.white),
              ),
              SizedBox(height: 22),

              FloatingActionButton(
                heroTag: "hero_tag_add_food",
                backgroundColor: Colors.green,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return ProductpageScreen();
                      },
                    ),
                  );
                },
                child: Icon(Icons.wine_bar, color: Colors.white),
              ),
            ],
          ),

          SizedBox(height: 25),
        ],
      ),
    );
  }
}
