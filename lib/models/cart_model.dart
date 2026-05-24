import 'package:cloud_firestore/cloud_firestore.dart';

class CartModel {
  final String productId;
  final String productName;
  final String productImage;
  final double price;
  final int quantity;
  final double totalPrice;
  final DateTime createdAt;

  CartModel({
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.price,
    required this.quantity,
    required this.totalPrice,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'productImage': productImage,
      'price': price,
      'quantity': quantity,
      'totalPrice': totalPrice,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory CartModel.fromMap(Map<String, dynamic> map) {
    return CartModel(
      productId: map['productId'] ?? '',
      productName: map['productName'] ?? '',
      productImage: map['productImage'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      quantity: map['quantity'] ?? 1,
      totalPrice: (map['totalPrice'] ?? 0.0).toDouble(),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }
}
