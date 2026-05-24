import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/cart_model.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.8),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A237E)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'MAHDHIYA FASHION',
          style: textTheme.labelLarge?.copyWith(
            letterSpacing: 2.0,
            color: AppTheme.primary,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Color(0xFF1A237E)),
            onPressed: () {},
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: const Color(0xFF1A237E).withOpacity(0.05),
            height: 1,
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 200),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 StreamBuilder<List<CartModel>>(
                  stream: context.read<AppProvider>().cartStream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    
                    final items = snapshot.data ?? [];
                    
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your Bag (${items.length} items)',
                          style: textTheme.displayMedium?.copyWith(
                            color: AppTheme.primary,
                            fontSize: 28,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Carefully curated selections for your elegant wardrobe.',
                          style: textTheme.bodySmall?.copyWith(color: AppTheme.outline),
                        ),
                        const SizedBox(height: 32),
                        if (items.isEmpty)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 40),
                              child: Text('Your cart is empty.'),
                            ),
                          )
                        else
                          ...items.map((item) => Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _CartItem(
                              item: item,
                            ),
                          )).toList(),
                        
                        const SizedBox(height: 40),
                        
                        // Order Summary
                        _OrderSummary(items: items),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          
          // Checkout Button Fixed at bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      final provider = context.read<AppProvider>();
                      if (!provider.isLoggedIn) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Login Required'),
                            content: const Text('Please login to your account to proceed to checkout and complete your purchase.'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('CANCEL'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.pushNamed(context, '/login');
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.primary,
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text('LOGIN'),
                              ),
                            ],
                          ),
                        );
                        return;
                      }
                      Navigator.pushNamed(context, '/checkout');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 64),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'PROCEED TO CHECKOUT',
                      style: textTheme.labelLarge?.copyWith(
                        color: Colors.white,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CartItem extends StatelessWidget {
  final CartModel item;

  const _CartItem({
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1A237E).withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1A237E).withOpacity(0.02),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 100,
            height: 130,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: const Color(0xFFF6F3F2),
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.asset(item.productImage, fit: BoxFit.cover),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item.productName,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontSize: 18,
                          color: AppTheme.onSurface,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => context.read<AppProvider>().removeFromCart(item.productId),
                      child: Icon(Icons.delete_outline, color: AppTheme.outline, size: 20),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Exclusive Selection',
                  style: theme.textTheme.bodySmall?.copyWith(color: AppTheme.outline),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F7FF),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFBAE1FF)),
                      ),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => context.read<AppProvider>().updateCartQuantity(item.productId, item.quantity - 1, item.price),
                            child: const Icon(Icons.remove, size: 16, color: AppTheme.primary),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          GestureDetector(
                            onTap: () => context.read<AppProvider>().updateCartQuantity(item.productId, item.quantity + 1, item.price),
                            child: const Icon(Icons.add, size: 16, color: AppTheme.primary),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '\$${item.totalPrice.toStringAsFixed(2)}',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontSize: 18,
                        color: AppTheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderSummary extends StatelessWidget {
  final List<CartModel> items;
  const _OrderSummary({required this.items});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final subtotal = items.fold(0.0, (sum, item) => sum + item.totalPrice);
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF1A237E).withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Summary',
            style: textTheme.headlineMedium?.copyWith(
              color: AppTheme.primary,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 24),
          _SummaryRow(label: 'Subtotal', value: '\$${subtotal.toStringAsFixed(2)}'),
          const SizedBox(height: 12),
          _SummaryRow(label: 'Shipping', value: 'Free', isSecondary: true),
          const SizedBox(height: 12),
          _SummaryRow(label: 'Estimated Tax', value: '\$0.00'),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TOTAL AMOUNT',
                    style: textTheme.labelSmall?.copyWith(
                      letterSpacing: 1.0,
                      color: AppTheme.outline,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${subtotal.toStringAsFixed(2)}',
                    style: textTheme.displayMedium?.copyWith(
                      color: AppTheme.primary,
                      fontSize: 32,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isSecondary;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.isSecondary = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.outline),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isSecondary ? AppTheme.secondary : AppTheme.onSurface,
          ),
        ),
      ],
    );
  }
}
