import 'package:cobranca_facil/model/product_model.dart';

class ProductsRepository {
  List<ProductModel> products = [
    ProductModel(
      name: 'Arroz',
      price: 2.50,
      image: 'lib/assets/images/arroz_mariano.png',
    ),

        ProductModel(
      name: 'Arroz 2',
      price: 3.50,
      image: 'lib/assets/images/arroz_mariano.png',
    ),

        ProductModel(
      name: 'Arroz 3',
      price: 4.50,
      image: 'lib/assets/images/arroz_mariano.png',
    ),
  ];
}
