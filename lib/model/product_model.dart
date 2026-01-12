class ProductModel {

  final int? id;
  final String name;
  final double price;
  final String image;

   int quantity;

  ProductModel({
    this.id,
    this.quantity = 0,
    required this.name,
    required this.price,
    required this.image
  });

  double get totalValue => price * quantity;

}