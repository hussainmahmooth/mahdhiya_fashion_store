import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import 'dart:convert';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isEditing = false;
  late TextEditingController _nameController;
  
  @override
  void initState() {
    super.initState();
    final provider = context.read<AppProvider>();
    _nameController = TextEditingController(text: provider.userName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _handleImagePick() async {
    final provider = context.read<AppProvider>();
    final base64Image = await provider.pickAndConvertImage();
    if (base64Image != null) {
      await provider.updateProfile(base64Image: base64Image);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile image updated successfully.')),
      );
    }
  }

  Future<void> _handleProfileUpdate() async {
    final provider = context.read<AppProvider>();
    try {
      await provider.updateProfile(fullName: _nameController.text);
      setState(() => _isEditing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Update failed: $e')),
      );
    }
  }

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
          if (_isEditing)
            IconButton(
              icon: const Icon(Icons.check, color: AppTheme.primary),
              onPressed: _handleProfileUpdate,
            )
          else
            IconButton(
              icon: const Icon(Icons.edit_note, color: AppTheme.primary),
              onPressed: () => setState(() => _isEditing = true),
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
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 40),
        child: Column(
          children: [
            // Profile Header
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFF1A237E).withOpacity(0.05)),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1A237E).withOpacity(0.04),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: _handleImagePick,
                    child: Stack(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFFBAEAFF), width: 3),
                            image: provider.profileImageUrl != null
                                ? DecorationImage(
                                    image: MemoryImage(base64Decode(provider.profileImageUrl!)),
                                    fit: BoxFit.cover,
                                  )
                                : const DecorationImage(
                                    image: AssetImage('assets/images/profile_avatar.jpg'),
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          child: provider.isLoading 
                            ? const Center(child: CircularProgressIndicator(strokeWidth: 2)) 
                            : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: AppTheme.primary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_isEditing)
                          TextField(
                            controller: _nameController,
                            style: textTheme.headlineLarge?.copyWith(fontSize: 20),
                            decoration: const InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(vertical: 8),
                            ),
                          )
                        else
                          Text(
                            provider.userName,
                            style: textTheme.headlineLarge?.copyWith(
                              color: AppTheme.primary,
                              fontSize: 24,
                            ),
                          ),
                        const SizedBox(height: 4),
                        Text(
                          provider.userEmail,
                          style: textTheme.bodySmall?.copyWith(color: AppTheme.outline),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          children: [
                            const _ProfileBadge(label: 'Gold Member', color: Color(0xFFBAEAFF)),
                            const _ProfileBadge(label: '12 Orders', color: Color(0xFFF0EDED)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 48),
            
            // Menu Sections
            _MenuSection(
              title: 'ACCOUNT SETTINGS',
              items: [
                _MenuItem(icon: Icons.history, label: 'Order History', onTap: () {}),
                _MenuItem(icon: Icons.location_on_outlined, label: 'Saved Addresses', onTap: () {}),
                _MenuItem(icon: Icons.payments_outlined, label: 'Payment Methods', onTap: () {}),
                _MenuItem(icon: Icons.favorite_border, label: 'Wishlist', onTap: () => Navigator.pushNamed(context, '/wishlist')),
                _MenuItem(icon: Icons.notifications_none, label: 'Notifications', isLast: true, onTap: () {}),
              ],
            ),
            
            const SizedBox(height: 48),
            
            // Logout Button
            OutlinedButton(
              onPressed: () {
                context.read<AppProvider>().logout();
                Navigator.pushReplacementNamed(context, '/login');
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.secondary,
                side: const BorderSide(color: Color(0xFF9AE1FF), width: 2),
                minimumSize: const Size(200, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
              child: const Text('LOGOUT'),
            ),
            const SizedBox(height: 16),
            Text(
              'MAHDHIYA FASHION v2.4.0',
              style: textTheme.labelSmall?.copyWith(
                color: AppTheme.outline.withOpacity(0.5),
                letterSpacing: 1.0,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _BottomNavBar(),
    );
  }
}

class _ProfileBadge extends StatelessWidget {
  final String label;
  final Color color;
  const _ProfileBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: AppTheme.primary.withOpacity(0.8),
        ),
      ),
    );
  }
}

class _MenuSection extends StatelessWidget {
  final String title;
  final List<Widget> items;
  const _MenuSection({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 12),
          child: Text(
            title,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: AppTheme.outline,
              letterSpacing: 2.0,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF1A237E).withOpacity(0.05)),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(children: items),
        ),
      ],
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isLast;

  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: isLast ? null : Border(
          bottom: BorderSide(color: const Color(0xFFF0EDED).withOpacity(0.5)),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
        leading: Icon(icon, color: AppTheme.secondary, size: 22),
        title: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: AppTheme.onSurface,
          ),
        ),
        trailing: const Icon(Icons.chevron_right, color: Color(0xFFC6C5D4)),
        onTap: onTap,
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
          _NavBarItem(icon: Icons.storefront, label: 'Shop', route: '/product_listing'),
          _NavBarItem(icon: Icons.shopping_bag_outlined, label: 'Cart', route: '/cart'),
          _NavBarItem(icon: Icons.person, label: 'Profile', isActive: true, route: '/profile'),
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
