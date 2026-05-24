import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

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
        leading: TextButton.icon(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A237E), size: 20),
          label: Text(
            'CART',
            style: textTheme.labelMedium?.copyWith(
              color: const Color(0xFF1A237E),
              letterSpacing: 1.0,
            ),
          ),
        ),
        title: Text(
          'MAHDHIYA FASHION',
          style: textTheme.labelLarge?.copyWith(
            letterSpacing: 2.0,
            color: AppTheme.primary,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: const Color(0xFF1A237E).withOpacity(0.05),
            height: 1,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 120),
        child: Column(
          children: [
            // Stepper
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _StepIndicator(label: 'Shipping', isActive: true),
                _StepDivider(),
                _StepIndicator(label: 'Payment'),
                _StepDivider(),
                _StepIndicator(label: 'Review'),
              ],
            ),
            const SizedBox(height: 48),
            
            // Shipping Section
            const _SectionTitle(title: 'Shipping Address'),
            const SizedBox(height: 24),
            const _CheckoutTextField(label: 'Full Name', hint: 'Eleanor Thompson'),
            const SizedBox(height: 16),
            const _CheckoutTextField(label: 'Street Address', hint: '123 Serene Lane, Apartment 4B'),
            const SizedBox(height: 16),
            Row(
              children: const [
                Expanded(child: _CheckoutTextField(label: 'City', hint: 'New York')),
                SizedBox(width: 16),
                Expanded(child: _CheckoutTextField(label: 'Zip Code', hint: '10001')),
              ],
            ),
            const SizedBox(height: 48),
            
            // Payment Section
            const _SectionTitle(title: 'Payment Method'),
            const SizedBox(height: 24),
            Row(
              children: const [
                Expanded(child: _PaymentOption(icon: Icons.credit_card, label: 'Credit Card', isSelected: true)),
                SizedBox(width: 12),
                Expanded(child: _PaymentOption(icon: Icons.account_balance_wallet, label: 'PayPal')),
                SizedBox(width: 12),
                Expanded(child: _PaymentOption(icon: Icons.contactless, label: 'Apple Pay')),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF1A237E).withOpacity(0.05)),
              ),
              child: Column(
                children: [
                  const _CheckoutTextField(label: 'Card Number', hint: 'xxxx xxxx xxxx xxxx'),
                  const SizedBox(height: 16),
                  Row(
                    children: const [
                      Expanded(child: _CheckoutTextField(label: 'Expiry Date', hint: 'MM/YY')),
                      SizedBox(width: 16),
                      Expanded(child: _CheckoutTextField(label: 'CVV', hint: '123')),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 48),
            
            // Order Summary Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.6),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1A237E).withOpacity(0.04),
                    blurRadius: 32,
                    offset: const Offset(0, 8),
                  ),
                ],
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
                  const _SummaryItem(
                    name: 'Midnight Silk Gown',
                    details: 'Size: M | Color: Navy',
                    price: r'$249.00',
                    imageUrl: 'assets/images/midnight_silk_gown.jpg',
                  ),
                  const SizedBox(height: 16),
                  const _SummaryItem(
                    name: 'Classic Tote Bag',
                    details: 'Material: Calfskin',
                    price: r'$185.00',
                    imageUrl: 'assets/images/classic_tote_bag.jpg',
                  ),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 24),
                  _SummaryRow(label: 'Subtotal', value: r'$434.00'),
                  const SizedBox(height: 12),
                  _SummaryRow(label: 'Shipping', value: 'Free', isSecondary: true),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total', style: textTheme.headlineMedium?.copyWith(color: AppTheme.primary)),
                      Text(r'$434.00', style: textTheme.headlineMedium?.copyWith(color: AppTheme.primary, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F7FF),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFBAE1FF).withOpacity(0.5)),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.verified_user, size: 16, color: AppTheme.primary),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'SECURE CHECKOUT WITH ENCRYPTED 256-BIT SSL PROTECTION.',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.primary,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          border: Border(top: BorderSide(color: const Color(0xFF1A237E).withOpacity(0.05))),
        ),
        child: ElevatedButton(
          onPressed: () => Navigator.pushNamed(context, '/order_confirmation'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primary,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 64),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 8,
            shadowColor: AppTheme.primary.withOpacity(0.2),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'PLACE ORDER',
                style: textTheme.labelLarge?.copyWith(
                  color: Colors.white,
                  letterSpacing: 2.0,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.lock, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepIndicator extends StatelessWidget {
  final String label;
  final bool isActive;
  const _StepIndicator({required this.label, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: isActive ? AppTheme.primary : AppTheme.outline,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        if (isActive) ...[
          const SizedBox(height: 4),
          Container(
            width: 4,
            height: 4,
            decoration: const BoxDecoration(
              color: AppTheme.primary,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ],
    );
  }
}

class _StepDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 1,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      color: const Color(0xFFC6C5D4).withOpacity(0.5),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
        color: AppTheme.primary,
        fontSize: 22,
      ),
    );
  }
}

class _CheckoutTextField extends StatelessWidget {
  final String label;
  final String hint;
  const _CheckoutTextField({required this.label, required this.hint});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppTheme.outline,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: AppTheme.outline.withOpacity(0.3)),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: const Color(0xFF1A237E).withOpacity(0.1)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: const Color(0xFF1A237E).withOpacity(0.1)),
            ),
          ),
        ),
      ],
    );
  }
}

class _PaymentOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;

  const _PaymentOption({
    required this.icon,
    required this.label,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFF0F7FF).withOpacity(0.3) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? AppTheme.primary : const Color(0xFF1A237E).withOpacity(0.05),
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: isSelected ? AppTheme.primary : AppTheme.outline, size: 32),
          const SizedBox(height: 12),
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: isSelected ? AppTheme.primary : AppTheme.outline,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String name;
  final String details;
  final String price;
  final String imageUrl;

  const _SummaryItem({
    required this.name,
    required this.details,
    required this.price,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 80,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: const Color(0xFFF6F3F2),
          ),
          clipBehavior: Clip.antiAlias,
          child: Image.asset(imageUrl, fit: BoxFit.cover),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF1A237E)),
              ),
              const SizedBox(height: 4),
              Text(details, style: TextStyle(color: AppTheme.outline, fontSize: 12)),
              const SizedBox(height: 8),
              Text(price, style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primary)),
            ],
          ),
        ),
      ],
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
        Text(label, style: const TextStyle(color: AppTheme.outline)),
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
