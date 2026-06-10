import 'package:icare/models/product.dart';

class Cart {
  final String? id;
  final Product? product;
  final int quantity;

  const Cart({this.id, this.product, this.quantity = 0});
}
