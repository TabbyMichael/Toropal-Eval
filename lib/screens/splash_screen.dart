import 'package:flutter/material.dart';
// Remove Riverpod import
import 'package:toropal_clone/screens/increment_screen.dart';

// SplashScreen is a stateful widget that shows a splash animation and navigates to IncrementScreen.
class SplashScreen extends StatefulWidget {
  // Change from ConsumerStatefulWidget
  final Duration splashDuration;
  const SplashScreen({
    super.key,
    this.splashDuration = const Duration(seconds: 3),
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState(); // Change from ConsumerState
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller; // Controls the animation timing.
  late Animation<double> _fadeAnimation; // Animation for fading in the logo.

  @override
  void initState() {
    super.initState();
    // Initialize the animation controller with a 2-second duration.
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // Define a fade-in animation from opacity 0 to 1.
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0, // Fix: should fade in to 1.0
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    // Start the fade-in animation.
    _controller.forward();

    // After the splash duration, navigate to the IncrementScreen.
    Future.delayed(widget.splashDuration, () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const IncrementScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    // Dispose the animation controller to free resources.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Use safe fallback colors for the gradient.
    final Color color1 = Colors.white;
    final Color color2 = Colors.white;

    // Scaffold provides the basic visual layout structure.
    return Scaffold(
      body: Container(
        // Gradient background for the splash screen.
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [color1, color2],
          ),
        ),
        child: Center(
          // FadeTransition animates the opacity of the logo image.
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Semantics(
              label: 'App Logo',
              child: Image.asset(
                'assets/images/logo.png', // Use your custom icon here
                width: 600,
                height: 600,
                fit:
                    BoxFit
                        .contain, // Prevents distortion if image is not square.
              ),
            ),
          ),
        ),
      ),
    );
  }
}
