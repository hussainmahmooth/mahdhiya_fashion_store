import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class OrderConfirmationScreen extends StatelessWidget {
  const OrderConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.8),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Text(
          'MAHDHIYA FASHION',
          style: textTheme.labelLarge?.copyWith(
            letterSpacing: 2.0,
            color: AppTheme.primary,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Success Hero
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: Color(0xFFE0E0FF),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                color: AppTheme.primary,
                size: 40,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Thank You for Your Order!',
              style: textTheme.displayMedium?.copyWith(
                color: AppTheme.primary,
                fontSize: 28,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'We\'ve received your request and are preparing it with care.',
              style: textTheme.bodyLarge?.copyWith(
                color: AppTheme.outline,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFBAEAFF).withOpacity(0.3),
                borderRadius: BorderRadius.circular(30),
              ),
              child: RichText(
                text: TextSpan(
                  style: textTheme.labelMedium?.copyWith(letterSpacing: 1.0),
                  children: [
                    const TextSpan(text: 'ORDER NUMBER: ', style: TextStyle(color: AppTheme.secondary)),
                    TextSpan(
                      text: '#MF-88291',
                      style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 64),
            
            // Order Summary
            Container(
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
                    'Order Summary (2 items)',
                    style: textTheme.headlineMedium?.copyWith(
                      color: AppTheme.primary,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const _ConfirmationItem(
                    name: 'Silk Wrap Midi Dress',
                    details: 'Champagne / Medium',
                    price: r'$240.00',
                    imageUrl: 'assets/images/champagne_midi_dress.jpg',
                  ),
                  const SizedBox(height: 16),
                  const _ConfirmationItem(
                    name: 'Essential Link Bracelet',
                    details: '18k Gold Plated / One Size',
                    price: r'$115.00',
                    imageUrl: 'assets/images/essential_link_bracelet.jpg',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Logistics info
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.primary,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primary.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.local_shipping_outlined, color: Color(0xFF89D0ED)),
                      SizedBox(width: 12),
                      Text(
                        'DELIVERY ESTIMATE',
                        style: TextStyle(
                          color: Colors.white,
                          letterSpacing: 1.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Oct 24 - Oct 26',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Express Shipping via DHL International',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Shipping Address
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFF6F3F2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF1A237E).withOpacity(0.05)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.location_on_outlined, color: AppTheme.primary),
                      SizedBox(width: 12),
                      Text(
                        'SHIPPING ADDRESS',
                        style: TextStyle(
                          color: AppTheme.primary,
                          letterSpacing: 1.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Eleanor Pemberton\n42 Highgrove Gardens\nKensington, London W8 5LE\nUnited Kingdom',
                    style: TextStyle(
                      color: AppTheme.onSurfaceVariant,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 48),
            
            // Actions
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 64),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.inventory_2_outlined, size: 20),
                  SizedBox(width: 8),
                  Text('TRACK ORDER'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.primary,
                side: BorderSide(color: AppTheme.primary.withOpacity(0.2)),
                minimumSize: const Size(double.infinity, 64),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('CONTINUE SHOPPING'),
            ),
            const SizedBox(height: 64),
            
            // Need Help
            const Divider(),
            const SizedBox(height: 32),
            Text(
              'Need assistance with your order?',
              style: textTheme.headlineSmall?.copyWith(color: AppTheme.primary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Our customer concierge is available 24/7 for you.',
              style: textTheme.bodyMedium?.copyWith(color: AppTheme.outline),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: const Color(0xFF1A237E).withOpacity(0.05)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.mail_outline, size: 16, color: AppTheme.primary),
                  SizedBox(width: 8),
                  Text('support@mahdhiya.com', style: TextStyle(fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: const Color(0xFF1A237E).withOpacity(0.05)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.call_outlined, size: 16, color: AppTheme.primary),
                  SizedBox(width: 8),
                  Text('+44 20 7946 0123', style: TextStyle(fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConfirmationItem extends StatelessWidget {
  final String name;
  final String details;
  final String price;
  final String imageUrl;

  const _ConfirmationItem({
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
          width: 70,
          height: 90,
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
