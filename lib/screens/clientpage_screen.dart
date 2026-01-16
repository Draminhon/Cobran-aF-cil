import 'package:cobranca_facil/constants/color_constants.dart';
import 'package:cobranca_facil/database/sqflite_database.dart';
import 'package:cobranca_facil/model/client_model.dart';
import 'package:cobranca_facil/notifiers/client_notifier.dart';
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
  int idCliente = 0;
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    idCliente = args['idCliente'];
    final clientNotifier = context.watch<ClientNotifier>();

    final currentClient = clientNotifier.clients.firstWhere(
      (c) => c.id == idCliente,
      orElse: () => widget.client,
    );
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white),
      backgroundColor: ColorConstants.scaffold_color,
      body:  Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            spacing: 10,
            children: [
              Container(
                height: 160,
                width: 160,
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
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                'Dívida: R\$ ${currentClient.divida.toStringAsFixed(2)}',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(right: 250, top: 10),
                child: Text(
                  "Produtos pegos",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),

              SizedBox(
                height: 350,
                child: FutureBuilder(
                  future: _sql.produtoClienteResultado(idCliente),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text("Erro ao carregar os dados!"));
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text("Nenhum produto foi pego"));
                    }

                    final produtos = snapshot.data;
                    return ListView.builder(
                      itemCount: produtos!.length,
                      itemBuilder: (context, index) {
                        final produto = produtos[index];
                        print("Produto: $produto");

                        return Padding(
                          padding: const EdgeInsets.fromLTRB(
                            17.0,
                            8.0,
                            8.0,
                            8.0,
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: ColorConstants.box_border_color,
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // LEADING: Imagem do produto
                                SizedBox(
                                  width: 70,
                                  height: 70,
                                  child: Image.asset(produto['image']),
                                ),

                                const SizedBox(
                                  width: 16,
                                ), // Espaço entre imagem e texto
                                // TITLE + SUBTITLE: Informações do produto
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        produto['name'],
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
                                            "${produto['quantidade']} x R\$ ${produto['price']}",
                                            style: const TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                          const Spacer(),
                                          Text(
                                            "R\$ ${(produto['quantidade'] * produto['price']).toStringAsFixed(2)}",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return ClientaddproductspageScreen(
                          idCliente: idCliente,
                        );
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
                        return ClientaddproductspageScreen(
                          idCliente: idCliente,
                        );
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
    );
  }
}
