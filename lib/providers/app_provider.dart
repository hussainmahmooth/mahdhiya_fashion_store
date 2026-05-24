import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/product_model.dart';
import '../models/order_model.dart';
import '../models/user_model.dart';
import '../models/cart_model.dart';
import '../services/cart_service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert'; // For base64
import 'dart:typed_data';



class AppProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  String _userName = 'Guest';
  String _userEmail = 'guest@mahdhiya.com';
  String? _profileImageUrl;

  final FirebaseService _firebaseService = FirebaseService();
  final CartService _cartService = CartService();
  bool _isLoading = false;
  String? _errorMessage;

  // Simple in-memory user registry to simulate persistence/backend
  final Map<String, String> _registeredUsers = {
    'sarah.jansen@example.com': 'Sarah Jansen', // Default user
  };

  final Set<String> _wishlistIds = {};
  List<ProductModel> _allProducts = [];

  bool get isLoggedIn => _isLoggedIn;
  String get userName => _userName;
  String get userEmail => _userEmail;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Set<String> get wishlistIds => _wishlistIds;
  List<ProductModel> get allProducts => _allProducts;
  String? get profileImageUrl => _profileImageUrl;

  List<ProductModel> get wishlistProducts {
    return _allProducts.where((p) => _wishlistIds.contains(p.id ?? '')).toList();
  }

  ProductModel getProductById(String id) {
    return _allProducts.firstWhere(
      (p) => p.id == id,
      orElse: () => _allProducts.first,
    );
  }

  // --- Firestore Data Fetching ---
  Future<void> fetchProducts() async {
    try {
      _allProducts = await _firebaseService.getProducts();
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching products: $e');
    }
  }

  // Helper to initialize database with demo products
  Future<void> initializeDemoProducts() async {
    // First fetch current products to check for duplicates
    await fetchProducts();
    
    final demoProducts = [
      ProductModel(name: 'Azure Silk Midi', category: 'Dresses', price: 245.0, imageUrl: 'assets/images/azure_silk_midi.jpg'),
      ProductModel(name: 'Flora Garden Gown', category: 'Dresses', price: 310.0, imageUrl: 'assets/images/flora_garden_gown.jpg'),
      ProductModel(name: 'Citrus Knit Set', category: 'Tops', price: 185.0, imageUrl: 'assets/images/citrus_knit_set.jpg'),
      ProductModel(name: 'Indigo Structure', category: 'Dresses', price: 420.0, imageUrl: 'assets/images/indigo_structure.jpg'),
      ProductModel(name: 'STRUCTURED OVERCOAT', category: 'Outerwear', price: 1250.0, imageUrl: 'assets/images/structured_overcoat.jpg'),
      ProductModel(name: 'Silk Wrap Midi Dress', category: 'Dresses', price: 129.0, imageUrl: 'assets/images/silk_wrap_midi_dress.jpg'),
      ProductModel(name: 'Champagne Midi Dress', category: 'Dresses', price: 195.0, imageUrl: 'assets/images/champagne_midi_dress.jpg'),
      ProductModel(name: 'Midnight Silk Gown', category: 'Dresses', price: 550.0, imageUrl: 'assets/images/midnight_silk_gown.jpg'),
      ProductModel(name: 'Classic Tote Bag', category: 'Accessories', price: 320.0, imageUrl: 'assets/images/classic_tote_bag.jpg'),
      ProductModel(name: 'Essential Link Bracelet', category: 'Accessories', price: 85.0, imageUrl: 'assets/images/essential_link_bracelet.jpg'),
      ProductModel(name: 'Petite Leather Clutch', category: 'Accessories', price: 145.0, imageUrl: 'assets/images/petite_leather_clutch.jpg'),
      ProductModel(name: 'Silk Pointed Heels', category: 'Accessories', price: 210.0, imageUrl: 'assets/images/silk_pointed_heels.jpg'),
    ];

    for (var p in demoProducts) {
      // Check if product already exists by name to avoid duplicates
      bool exists = _allProducts.any((existing) => existing.name == p.name);
      if (!exists) {
        await _firebaseService.addProduct(p);
      }
    }
    await fetchProducts();
  }

  // Auth Methods
  Future<bool> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      UserCredential? result = await _firebaseService.signUp(
        fullName: fullName,
        email: email,
        password: password,
      );

      if (result != null) {
        // Sign out immediately so user can log in manually
        await FirebaseAuth.instance.signOut();
        _isLoggedIn = false;
        _isLoading = false;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      UserCredential? result = await _firebaseService.signIn(
        email: email,
        password: password,
      );

      if (result != null && result.user != null) {
        UserModel? userData = await _firebaseService.getUserData(result.user!.uid);
        _isLoggedIn = true;
        _userEmail = email;
        _userName = userData?.fullName ?? email.split('@')[0];
        _profileImageUrl = userData?.profileImageUrl;
        
        // Fetch persistent wishlist
        List<String> persistentWishlist = await _firebaseService.getWishlist(result.user!.uid);
        _wishlistIds.clear();
        _wishlistIds.addAll(persistentWishlist);

        _isLoading = false;
        notifyListeners();
        return true;
      }
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void logout() async {
    await _firebaseService.signOut();
    _isLoggedIn = false;
    _userName = 'Guest';
    _userEmail = 'guest@mahdhiya.com';
    _profileImageUrl = null;
    _wishlistIds.clear();
    notifyListeners();
  }

  // Cart Methods
  Stream<List<CartModel>> get cartStream => _cartService.getCartStream();

  Future<void> addToCart(String id, String name, String priceStr, String imageUrl) async {
    // Remove the '$' and parse price
    double price = double.parse(priceStr.replaceAll(r'$', '').trim());
    
    final cartItem = CartModel(
      productId: id,
      productName: name,
      productImage: imageUrl,
      price: price,
      quantity: 1,
      totalPrice: price,
      createdAt: DateTime.now(),
    );

    try {
      await _cartService.addToCart(cartItem);
      notifyListeners();
    } catch (e) {
      debugPrint('Add to cart failed: $e');
    }
  }

  Future<void> updateCartQuantity(String id, int quantity, double price) async {
    try {
      await _cartService.updateQuantity(id, quantity, price);
      notifyListeners();
    } catch (e) {
      debugPrint('Update quantity failed: $e');
    }
  }

  Future<void> removeFromCart(String id) async {
    try {
      await _cartService.removeFromCart(id);
      notifyListeners();
    } catch (e) {
      debugPrint('Remove from cart failed: $e');
    }
  }

  Future<void> clearCart() async {
    try {
      await _cartService.clearCart();
      notifyListeners();
    } catch (e) {
      debugPrint('Clear cart failed: $e');
    }
  }

  // Wishlist Methods
  void toggleWishlist(String id) async {
    if (_wishlistIds.contains(id)) {
      _wishlistIds.remove(id);
    } else {
      _wishlistIds.add(id);
    }
    notifyListeners();

    // Sync with Firestore if logged in
    final uid = _firebaseService.currentUserId;
    if (uid != null) {
      try {
        await _firebaseService.updateWishlist(uid, _wishlistIds.toList());
      } catch (e) {
        debugPrint('Wishlist sync failed: $e');
      }
    }
  }

  bool isInWishlist(String id) => _wishlistIds.contains(id);

  // Profile Update Methods
  Future<void> updateProfile({String? fullName, String? base64Image}) async {
    final uid = _firebaseService.currentUserId;
    if (uid == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      Map<String, dynamic> updateData = {};
      if (fullName != null) {
        updateData['full_name'] = fullName;
        _userName = fullName;
      }
      if (base64Image != null) {
        updateData['profile_image_url'] = base64Image;
        _profileImageUrl = base64Image;
      }

      if (updateData.isNotEmpty) {
        await _firebaseService.updateUserData(uid, updateData);
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<String?> pickAndConvertImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 75,
    );

    if (image != null) {
      Uint8List bytes = await image.readAsBytes();
      return base64Encode(bytes);
    }
    return null;
  }
}
