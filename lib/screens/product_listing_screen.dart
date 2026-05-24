import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class ProductListingScreen extends StatelessWidget {
  const ProductListingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // Top Bar
              SliverAppBar(
                floating: true,
                pinned: true,
                elevation: 0,
                backgroundColor: Colors.white.withOpacity(0.8),
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

              // Page Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 24.0),
                  child: Column(
                    children: [
                      Text(
                        'Dresses',
                        style: textTheme.headlineLarge?.copyWith(
                          color: AppTheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Elevated essentials for every occasion',
                        style: textTheme.bodySmall?.copyWith(
                          color: AppTheme.outline,
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Filter Toolbar
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        decoration: BoxDecoration(
                          border: Border.symmetric(
                            horizontal: BorderSide(
                              color: const Color(0xFF1A237E).withOpacity(0.05),
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                _FilterButton(
                                  icon: Icons.tune,
                                  label: 'Filter',
                                  active: true,
                                ),
                                const SizedBox(width: 8),
                                _FilterButton(
                                  label: 'Category',
                                  icon: Icons.expand_more,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  'SORT BY: ',
                                  style: textTheme.labelSmall?.copyWith(
                                    letterSpacing: 1.0,
                                    color: AppTheme.outline,
                                  ),
                                ),
                                _FilterButton(
                                  label: 'Newest',
                                  icon: Icons.swap_vert,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Product Grid
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.65,
                    mainAxisSpacing: 24,
                    crossAxisSpacing: 24,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final products = context.watch<AppProvider>().allProducts;
                      final product = products[index % products.length];
                      
                      return GestureDetector(
                        onTap: () => Navigator.pushNamed(
                          context,
                          '/product_detail',
                          arguments: product.id,
                        ),
                        child: _ProductCard(
                          id: product.id ?? '',
                          name: product.name,
                          price: product.price,
                          imageUrl: product.imageUrl,
                        ),
                      );
                    },
                    childCount: 12,
                  ),
                ),
              ),
              
              // Load More
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 120.0),
                  child: Center(
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.secondary,
                        side: const BorderSide(color: AppTheme.secondary),
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        'EXPLORE MORE',
                        style: textTheme.labelLarge?.copyWith(
                          color: AppTheme.secondary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          // Bottom Navigation
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _BottomNavBar(),
          ),
        ],
      ),
    );
  }
}

class _FilterButton extends StatelessWidget {
  final IconData? icon;
  final String label;
  final bool active;

  const _FilterButton({
    this.icon,
    required this.label,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: active ? const Color(0xFFF0F7FF) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: active ? const Color(0xFFBAE1FF) : const Color(0xFFC6C5D4).withOpacity(0.5),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 18,
              color: active ? AppTheme.secondary : AppTheme.outline,
            ),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: active ? AppTheme.secondary : AppTheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final String id;
  final String name;
  final double price;
  final String imageUrl;

  const _ProductCard({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF1A237E).withOpacity(0.03),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Consumer<AppProvider>(
                    builder: (context, provider, _) {
                      final isFavorite = provider.isInWishlist(id);
                      return Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (!provider.isLoggedIn) {
                                _showLoginDialog(context);
                                return;
                              }
                              provider.addToCart(id, name, '\$${price.toStringAsFixed(2)}', imageUrl);
                              Navigator.pushNamed(context, '/cart');
                            },
                            child: Container(
                              height: 36,
                              width: 36,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.8),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.add_shopping_cart, size: 18, color: AppTheme.secondary),
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              if (!provider.isLoggedIn) {
                                _showLoginDialog(context);
                                return;
                              }
                              provider.toggleWishlist(id);
                            },
                            child: Container(
                              height: 36,
                              width: 36,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.8),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                isFavorite ? Icons.favorite : Icons.favorite_border,
                                size: 20,
                                color: isFavorite ? Colors.red : AppTheme.secondary,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          name,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontSize: 16,
            color: AppTheme.primary,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          '\$${price.toStringAsFixed(2)}',
          style: theme.textTheme.labelLarge?.copyWith(
            color: AppTheme.secondary,
          ),
        ),
      ],
    );
  }

  void _showLoginDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Login Required'),
        content: const Text('Please login to access your account features.'),
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
          _NavBarItem(icon: Icons.storefront, label: 'Shop', isActive: true, route: '/product_listing'),
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
              style: GoogleFonts.notoSerif(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: isActive ? AppTheme.primary : AppTheme.outline.withOpacity(0.6),
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
