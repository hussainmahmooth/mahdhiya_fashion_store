import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/product_model.dart';
import '../models/order_model.dart';
import 'package:flutter/foundation.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Sign Up with Email and Password
  Future<UserCredential?> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      // 1. Create account in Firebase Authentication
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        // 2. Store user details in Firestore
        UserModel newUser = UserModel(
          fullName: fullName,
          email: email,
          createdAt: DateTime.now(),
        );

        await _db.collection('users').doc(userCredential.user!.uid).set(
          newUser.toMap(password),
        );
      }
      
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    } catch (e) {
      throw 'An unexpected error occurred. Please try again.';
    }
  }

  // --- Products Section ---

  // Fetch all products
  Future<List<ProductModel>> getProducts() async {
    try {
      QuerySnapshot snapshot = await _db.collection('products').get();
      return snapshot.docs.map((doc) => 
        ProductModel.fromMap(doc.data() as Map<String, dynamic>, doc.id)
      ).toList();
    } catch (e) {
      throw 'Failed to load products.';
    }
  }

  // Add a product (Admin use)
  Future<void> addProduct(ProductModel product) async {
    try {
      await _db.collection('products').add(product.toMap());
    } catch (e) {
      throw 'Failed to add product.';
    }
  }

  // --- Orders Section ---

  // Place a new order
  Future<String> placeOrder(OrderModel order) async {
    try {
      DocumentReference ref = await _db.collection('orders').add(order.toMap());
      return ref.id;
    } catch (e) {
      throw 'Failed to place order.';
    }
  }

  // Fetch user orders
  Future<List<OrderModel>> getUserOrders(String userId) async {
    try {
      QuerySnapshot snapshot = await _db.collection('orders')
        .where('user_id', isEqualTo: userId)
        .orderBy('created_at', descending: true)
        .get();
      
      return snapshot.docs.map((doc) => 
        OrderModel.fromMap(doc.data() as Map<String, dynamic>, doc.id)
      ).toList();
    } catch (e) {
      throw 'Failed to load orders.';
    }
  }

  // --- Auth Section ---
  
  // Get current user ID
  String? get currentUserId => _auth.currentUser?.uid;

  // Update user data
  Future<void> updateUserData(String uid, Map<String, dynamic> data) async {
    try {
      await _db.collection('users').doc(uid).update(data);
    } catch (e) {
      throw 'Failed to update profile.';
    }
  }

  // --- Wishlist Section ---
  Future<List<String>> getWishlist(String uid) async {
    try {
      DocumentSnapshot doc = await _db.collection('wishlists').doc(uid).get();
      if (doc.exists) {
        return List<String>.from(doc.get('product_ids') ?? []);
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<void> updateWishlist(String uid, List<String> productIds) async {
    try {
      await _db.collection('wishlists').doc(uid).set({
        'product_ids': productIds,
        'updated_at': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Failed to update wishlist: $e');
    }
  }

  Future<UserCredential?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    } catch (e) {
      throw 'An unexpected error occurred. Please try again.';
    }
  }

  // Get User Data from Firestore
  Future<UserModel?> getUserData(String uid) async {
    try {
      DocumentSnapshot doc = await _db.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Handle Firebase Auth Errors
  String _handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-disabled':
        return 'This user has been disabled.';
      default:
        return e.message ?? 'Authentication failed.';
    }
  }
}
