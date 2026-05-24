import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String? id;
  final String userId;
  final List<Map<String, dynamic>> items;
  final double totalAmount;
  final String status;
  final DateTime createdAt;
  final Map<String, dynamic> shippingAddress;

  OrderModel({
    this.id,
    required this.userId,
    required this.items,
    required this.totalAmount,
    this.status = 'pending',
    required this.createdAt,
    required this.shippingAddress,
  });

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'items': items,
      'total_amount': totalAmount,
      'status': status,
      'created_at': Timestamp.fromDate(createdAt),
      'shipping_address': shippingAddress,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map, String id) {
    return OrderModel(
      id: id,
      userId: map['user_id'] ?? '',
      items: List<Map<String, dynamic>>.from(map['items'] ?? []),
      totalAmount: (map['total_amount'] ?? 0.0).toDouble(),
      status: map['status'] ?? 'pending',
      createdAt: (map['created_at'] as Timestamp).toDate(),
      shippingAddress: Map<String, dynamic>.from(map['shipping_address'] ?? {}),
    );
  }
}
