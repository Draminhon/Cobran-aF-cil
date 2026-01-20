import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cobranca_facil/constants/color_constants.dart';
import 'package:cobranca_facil/database/sqflite_database.dart';
import 'package:cobranca_facil/model/product_model.dart';
import 'package:cobranca_facil/notifiers/product_notifier.dart';
import 'package:cobranca_facil/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AddproductpageScreen extends StatefulWidget {
  final ProductModel? produto;
  const AddproductpageScreen({super.key, this.produto});

  @override
  State<AddproductpageScreen> createState() => _AddproductpageScreenState();
}

class _AddproductpageScreenState extends State<AddproductpageScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool _showCamera = false;
  XFile? _imageFile;
  TextEditingController _productNameController = TextEditingController();
  TextEditingController _productPriceController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _initializeControllerFuture = _setupCamera();
    if(widget.produto != null){
      _productNameController.text = widget.produto!.name;
      _productPriceController.text = widget.produto!.price.toString();
    }
  }

  Future<void> _setupCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
    _controller = CameraController(firstCamera, ResolutionPreset.ultraHigh);

    await _controller.initialize();

    if (!mounted) return;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.produto);
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white),
      backgroundColor: ColorConstants.scaffold_color,
      body: SingleChildScrollView(
          child: Column(
            spacing: 15,
            children: [
              SizedBox(height: 15,),
              widget.produto != null ?
              Container(
                child: Utils().displayImage(widget.produto!.image),
              ):
              FutureBuilder(
                future: _initializeControllerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _showCamera = !_showCamera;
                        });
                      },
                      child: Center(
                        child: Container(
                          height: 400,
                          width: 400,
                                  margin: EdgeInsets.symmetric(horizontal: 20),
                          child: _showCamera
                              ? Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    SizedBox.expand(
                                      child: CameraPreview(_controller),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: FloatingActionButton(
                                        onPressed: () async {
                                          try {
                                            await _initializeControllerFuture;
                                  
                                            final image = await _controller
                                                .takePicture();
                                            setState(() {
                                              _imageFile = image;
                                              _showCamera = !_showCamera;
                                            });
                                            print(image.path);
                                          } catch (e) {
                                            print(e);
                                          }
                                        },
                                        child: const Icon(Icons.camera_alt),
                                      ),
                                    ),
                                  ],
                                )
                              : Container(
                                  height: 300,
                                  width: 300,
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(255, 216, 216, 216),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: _imageFile != null
                                      ? Image.file(
                                          File(_imageFile!.path),
                                          fit: BoxFit.cover,
                                        )
                                      : Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.camera_alt, size: 50),
                                            Text(
                                              'Adicionar Foto',
                                              style: TextStyle(fontSize: 25),
                                            ),
                                          ],
                                        ),
                                ),
                        ),
                      ),
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
              Container(
                width: 400,
                margin: EdgeInsets.only(top: 20,left: 20, right: 20),
                decoration: BoxDecoration(
                  border: Border.all(color: ColorConstants.box_border_color),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: _productNameController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(8),
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    hint: Text("Nome do produto"),
                  ),
                ),
              ),
          
              Container(
                width: 400,
                margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                decoration: BoxDecoration(
                  border: Border.all(color: ColorConstants.box_border_color),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: _productPriceController,
                  keyboardType: TextInputType.numberWithOptions(),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(8),
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    hint: Text("Preço"),
                  ),
                ),
              ),

              GestureDetector(
                onTap: () async {
                  if(widget.produto != null){
                    await SqfliteDatabase().updateProduct(ProductModel(id: widget.produto!.id,name: _productNameController.text, price: double.parse(_productPriceController.text), image: widget.produto!.image));
                  }else{
                   await SqfliteDatabase().insertProduto(ProductModel(name: _productNameController.text,
                  price: double.parse(_productPriceController.text), image: _imageFile!.path));
                  }
                
                    
                    if(mounted){
                      Provider.of<ProductNotifier>(context, listen:false).carregarProdutos();
                        Navigator.pop(context);
                    }

                },
                child: Container(
                  width: 400,
                  height: 60,
                  margin: EdgeInsets.only(top: 20,left: 20, right: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.green
                  ),
                  child:  Center(
                        child: widget.produto != null ?
                         Text("Atualizar Produto", style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white
                        ),)
                        : Text("Adicionar Produto", style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white
                        ),)
                      ),
                ),
              ),
            ],
          ),
        ),
    );
  }
}
