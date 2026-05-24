import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/cart_model.dart';
import 'package:flutter/foundation.dart';

class CartService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Collection Reference
  CollectionReference _cartRef(String uid) => 
      _db.collection('users').doc(uid).collection('cart');

  // Add Item to Cart
  Future<void> addToCart(CartModel item) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    try {
      final doc = await _cartRef(uid).doc(item.productId).get();
      
      if (doc.exists) {
        // If exists, update quantity
        int newQuantity = (doc.get('quantity') ?? 0) + item.quantity;
        await _cartRef(uid).doc(item.productId).update({
          'quantity': newQuantity,
          'totalPrice': newQuantity * item.price,
        });
      } else {
        // New item
        await _cartRef(uid).doc(item.productId).set(item.toMap());
      }
    } catch (e) {
      debugPrint('Error adding to cart: $e');
      throw 'Could not add item to cart.';
    }
  }

  // Remove Item from Cart
  Future<void> removeFromCart(String productId) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    try {
      await _cartRef(uid).doc(productId).delete();
    } catch (e) {
      debugPrint('Error removing from cart: $e');
      throw 'Could not remove item.';
    }
  }

  // Update Quantity
  Future<void> updateQuantity(String productId, int quantity, double price) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    try {
      if (quantity <= 0) {
        await removeFromCart(productId);
      } else {
        await _cartRef(uid).doc(productId).update({
          'quantity': quantity,
          'totalPrice': quantity * price,
        });
      }
    } catch (e) {
      debugPrint('Error updating quantity: $e');
      throw 'Could not update quantity.';
    }
  }

  // Get Cart Items Stream (Real-time)
  Stream<List<CartModel>> getCartStream() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return Stream.value([]);

    return _cartRef(uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return CartModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // Clear Cart (e.g., after checkout)
  Future<void> clearCart() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    try {
      final snapshot = await _cartRef(uid).get();
      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      debugPrint('Error clearing cart: $e');
    }
  }
}
