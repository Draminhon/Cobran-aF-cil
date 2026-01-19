import 'package:cobranca_facil/constants/color_constants.dart';
import 'package:cobranca_facil/database/sqflite_database.dart';
import 'package:cobranca_facil/model/client_model.dart';
import 'package:cobranca_facil/notifiers/client_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class PaymentpageScreen extends StatefulWidget {
  final ClientModel client;
  final int idCliente;
  const PaymentpageScreen({
    super.key,
    required this.client,
    required this.idCliente,
  });

  @override
  State<PaymentpageScreen> createState() => _PaymentpageScreenState();
}

class _PaymentpageScreenState extends State<PaymentpageScreen> {
  @override
  int idCliente = 0;
  final _sql = SqfliteDatabase();
  TextEditingController valorASerPago = TextEditingController();
  Widget build(BuildContext context) {
   
   
   
   
    final clientNotifier = context.watch<ClientNotifier>();
   
   
    idCliente = widget.idCliente;
   
    

    final currentClient = clientNotifier.clients.firstWhere(
      (c) => c.id == idCliente,
      orElse: () => widget.client,
    );
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white),
      backgroundColor: ColorConstants.scaffold_color,
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: SingleChildScrollView(
          child: Column(
            spacing: 10,
            children: [
              Text(
                'Dívida: R\$ ${currentClient.divida.toStringAsFixed(2)}',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
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
          
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(17.0, 8.0, 8.0, 8.0),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _sql.removerProdutoDoCliente(widget.client.id!, produto['id']);
                                clientNotifier.carregarClientes();
                              });
                            },
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
                                      crossAxisAlignment: CrossAxisAlignment.start,
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
                                              style: const TextStyle(fontSize: 16),
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
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
                   GestureDetector(

                                                      onTap: () {

                              
                },

                child: Container(
                  width: 374,
                  height: 48,

margin: EdgeInsets.only(top: 150),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      "Confirmar Pagamento",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
