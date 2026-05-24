import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final provider = context.watch<AppProvider>();

    if (!provider.isLoggedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/home');
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.8),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Color(0xFF1A237E)),
          onPressed: () {},
        ),
        title: Text(
          'MAHDHIYA FASHION',
          style: textTheme.labelLarge?.copyWith(
            letterSpacing: 2.0,
            color: AppTheme.primary,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_bag_outlined, color: Color(0xFF1A237E)),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 40, 24, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'WISHLIST',
              style: textTheme.displayLarge?.copyWith(
                color: AppTheme.primary,
                fontSize: 48,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            Consumer<AppProvider>(
              builder: (context, provider, _) {
                final wishlistProducts = provider.wishlistProducts;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CURATED PIECES (${wishlistProducts.length})',
                      style: textTheme.labelSmall?.copyWith(
                        color: AppTheme.outline,
                        letterSpacing: 2.0,
                      ),
                    ),
                    const SizedBox(height: 48),
                    if (wishlistProducts.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 40),
                          child: Text('Your wishlist is empty.'),
                        ),
                      )
                    else
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.6,
                          mainAxisSpacing: 32,
                          crossAxisSpacing: 24,
                        ),
                        itemCount: wishlistProducts.length,
                        itemBuilder: (context, index) {
                          final product = wishlistProducts[index];
                          return GestureDetector(
                            onTap: () => Navigator.pushNamed(
                              context, 
                              '/product_detail',
                              arguments: product.id,
                            ),
                            child: _WishlistItemCard(
                              id: product.id!,
                              name: product.name,
                              category: product.category,
                              price: product.price,
                              imageUrl: product.imageUrl,
                            ),
                          );
                        },
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: _BottomNavBar(),
    );
  }
}

class _WishlistItemCard extends StatelessWidget {
  final String id;
  final String name;
  final String category;
  final double price;
  final String imageUrl;

  const _WishlistItemCard({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: const Color(0xFFF6F3F2),
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.asset(imageUrl, fit: BoxFit.cover, height: double.infinity, width: double.infinity),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: GestureDetector(
                  onTap: () => context.read<AppProvider>().toggleWishlist(id),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.4),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.favorite, color: AppTheme.secondary, size: 20),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                    ),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      final provider = context.read<AppProvider>();
                      if (!provider.isLoggedIn) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Login Required'),
                            content: const Text('Please login to your account to add items to your cart and proceed with your purchase.'),
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
                      provider.addToCart(id, name, '\$${price.toStringAsFixed(2)}', imageUrl);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Added to Cart')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    child: const Text(
                      'ADD TO CART',
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primary, fontSize: 14),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    category,
                    style: TextStyle(color: AppTheme.outline, fontSize: 10),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '\$${price.toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.secondary),
            ),
          ],
        ),
      ],
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 12,
        bottom: MediaQuery.of(context).padding.bottom + 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1A237E).withOpacity(0.05),
            blurRadius: 24,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavBarItem(icon: Icons.home_outlined, label: 'Home', route: '/home'),
          _NavBarItem(icon: Icons.storefront, label: 'Shop', route: '/product_listing'),
          _NavBarItem(icon: Icons.favorite, label: 'Wishlist', isActive: true, route: '/wishlist'),
          _NavBarItem(icon: Icons.shopping_bag_outlined, label: 'Cart', route: '/cart'),
          _NavBarItem(icon: Icons.person_outline, label: 'Profile', route: '/profile'),
        ],
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;

  final String route;

  const _NavBarItem({
    required this.icon,
    required this.label,
    required this.route,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Protected routes check
        if (route == '/cart' || route == '/profile' || route == '/wishlist') {
          final provider = context.read<AppProvider>();
          if (!provider.isLoggedIn) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Login Required'),
                content: Text('Please login to access your $label and other exclusive features.'),
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
        }
        Navigator.pushReplacementNamed(context, route);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: isActive ? BoxDecoration(
          color: const Color(0xFFF0F7FF),
          borderRadius: BorderRadius.circular(12),
        ) : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? AppTheme.primary : AppTheme.outline.withOpacity(0.6),
            ),
            const SizedBox(height: 4),
            Text(
              label.toUpperCase(),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: isActive ? AppTheme.primary : AppTheme.outline,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
