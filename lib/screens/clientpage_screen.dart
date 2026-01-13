import 'package:cobranca_facil/constants/color_constants.dart';
import 'package:cobranca_facil/database/sqflite_database.dart';
import 'package:cobranca_facil/model/client_model.dart';
import 'package:cobranca_facil/model/client_notifier.dart';
import 'package:cobranca_facil/screens/clientaddproductspage_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClientpageScreen extends StatefulWidget {
  final ClientModel client;

  const ClientpageScreen({super.key, required this.client});
  @override
  State<ClientpageScreen> createState() => _ClientpageScreenState();
}

class _ClientpageScreenState extends State<ClientpageScreen> {
  TextEditingController _clienteName = TextEditingController();

  @override
  void initState() {
    _clienteName.text = widget.client.name;
    super.initState();
  }

  bool _isEditingName = false;

  final _sql = SqfliteDatabase();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white),
      backgroundColor: ColorConstants.scaffold_color,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Column(
              spacing: 20,
              children: [
                Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: ColorConstants.box_border_color,
                      width: 0.5,
                    ),
                  ),
                  child: Icon(
                    widget.client.icon,
                    color: widget.client.iconColor,
                    size: 110,
                  ),
                ),
                GestureDetector(
                  onDoubleTap: () {
                    setState(() {
                      _isEditingName = true;
                    });
                  },

                  child: SizedBox(
                    width: 400,
                    child: TextField(
                      readOnly: !_isEditingName,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        suffixIcon: _isEditingName
                            ? const Icon(Icons.check, color: Colors.green)
                            : null,
                      ),
                      controller: _clienteName,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      onTapOutside: (event) {
                        setState(() {
                          _sql.updateClient(
                            ClientModel(
                              id: widget.client.id,
                              divida: widget.client.divida,
                              icon: widget.client.icon,
                              iconColor: widget.client.iconColor,
                              name: _clienteName.text,
                            ),
                          );
                          Provider.of<ClientNotifier>(
                            context,
                            listen: false,
                          ).carregarClientes();

                          _isEditingName = false;
                        });
                        FocusScope.of(context).unfocus();
                      },
                      onSubmitted: (value) {
                        setState(() {
                          _sql.updateClient(
                            ClientModel(
                              id: widget.client.id,
                              divida: widget.client.divida,
                              icon: widget.client.icon,
                              iconColor: widget.client.iconColor,
                              name: _clienteName.text,
                            ),
                          );
                          Provider.of<ClientNotifier>(
                            context,
                            listen: false,
                          ).carregarClientes();

                          _isEditingName = false;
                        });
                      },
                    ),
                  ),
                ),
                Text(
                  'Dívida: R\$ ${widget.client.divida.toString()}',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),



              Padding(
                padding: const EdgeInsets.only(right: 250, top: 50),
                child: Text("Produtos pegos", style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16
                ),),
              ),




                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return ClientaddproductspageScreen();
                        },
                      ),
                    );
                  },

                  child: Container(
                    width: 374,
                    height: 48,

                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        "Abater Dívida",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return ClientaddproductspageScreen();
                        },
                      ),
                    );
                  },

                  child: Container(
                    width: 374,
                    height: 48,

                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        "Adicionar Produto",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
