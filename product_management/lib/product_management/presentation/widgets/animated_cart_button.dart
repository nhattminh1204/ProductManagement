import 'package:flutter/material.dart';

class AnimatedCartButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget icon;

  const AnimatedCartButton({
    super.key, 
    required this.onPressed, 
    this.icon = const Icon(Icons.shopping_cart_outlined, color: Colors.white, size: 16),
  });

  @override
  State<AnimatedCartButton> createState() => _AnimatedCartButtonState();
}

class _AnimatedCartButtonState extends State<AnimatedCartButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.8).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFE91E63), // AppColors.primary
          shape: BoxShape.circle,
          boxShadow: [
             BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(0, 4),
            )
          ]
        ),
        child: IconButton(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          icon: widget.icon,
          onPressed: () async {
            await _controller.forward();
            widget.onPressed();
            await _controller.reverse();
          },
        ),
      ),
    );
  }
}
