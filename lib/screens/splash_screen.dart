import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize products from Firestore
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppProvider>().initializeDemoProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      body: Stack(
        children: [
          // Background Imagery
          Positioned.fill(
            child: Image.asset(
              'assets/images/splash_image.jpg',
              fit: BoxFit.cover,
            ),
          ),
          // Glass Overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF1A237E).withOpacity(0.1),
                    const Color(0xFFF5F9FF).withOpacity(0.95),
                  ],
                  stops: const [0.0, 0.85],
                ),
              ),
            ),
          ),
          // Branding & Typography Shell
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo Section
                    Column(
                      children: [
                        Text(
                          'MAHDHIYA',
                          style: theme.textTheme.headlineLarge?.copyWith(
                            fontSize: 42,
                            letterSpacing: 8.0,
                            color: AppTheme.primary,
                            shadows: [
                              const Shadow(
                                offset: Offset(0, 2),
                                blurRadius: 4,
                                color: Colors.black12,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          width: 48,
                          height: 1,
                          color: const Color(0xFF9AE1FF),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'FASHION',
                          style: theme.textTheme.labelLarge?.copyWith(
                            letterSpacing: 6.0,
                            color: AppTheme.secondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 48),
                    // Tagline Section
                    Column(
                      children: [
                        Text(
                          'Timeless Elegance',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.displayMedium?.copyWith(
                            color: const Color(0xFF1A237E),
                            height: 1.1,
                          ),
                        ),
                        Text(
                          'in Every Stitch',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.displayMedium?.copyWith(
                            color: AppTheme.secondary,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.normal,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(
                            'Discover a curated collection where heritage craftsmanship meets contemporary silhouettes.',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: const Color(0xFF454652).withOpacity(0.8),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 80),
                    // Actions
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: () => Navigator.pushNamed(context, '/home'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primary,
                            foregroundColor: AppTheme.onPrimary,
                            minimumSize: const Size(double.infinity, 64),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 8,
                            shadowColor: AppTheme.primary.withOpacity(0.3),
                          ),
                          child: const Text(
                            'GET STARTED',
                            style: TextStyle(
                              letterSpacing: 2.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        OutlinedButton(
                          onPressed: () => Navigator.pushNamed(context, '/login'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppTheme.primary,
                            side: const BorderSide(color: Color(0xFFC6C5D4)),
                            minimumSize: const Size(double.infinity, 64),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'LOG IN',
                            style: TextStyle(
                              letterSpacing: 2.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 80),
                    // Pagination Indicator
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 32,
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppTheme.primary,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Container(
                          width: 8,
                          height: 4,
                          decoration: BoxDecoration(
                            color: const Color(0xFFC6C5D4),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Container(
                          width: 8,
                          height: 4,
                          decoration: BoxDecoration(
                            color: const Color(0xFFC6C5D4),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Footer
          Positioned(
            bottom: 32,
            left: 0,
            right: 0,
            child: Text(
              'EST. 2024 • LUXURY READY-TO-WEAR',
              textAlign: TextAlign.center,
              style: theme.textTheme.labelSmall?.copyWith(
                letterSpacing: 2.0,
                color: AppTheme.outline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
