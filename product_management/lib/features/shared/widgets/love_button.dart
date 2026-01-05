import 'package:flutter/material.dart';
import 'dart:math' as math;

class LoveButton extends StatefulWidget {
  final bool isLiked;
  final VoidCallback onTap;
  final double size;

  const LoveButton({
    super.key,
    required this.isLiked,
    required this.onTap,
    this.size = 20,
  });

  @override
  State<LoveButton> createState() => _LoveButtonState();
}

class _LoveButtonState extends State<LoveButton> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _outerCircleAnimation;
  late Animation<double> _innerCircleAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _bubblesAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);

    _initAnimations();
  }

  void _initAnimations() {
    _outerCircleAnimation = Tween<double>(begin: 0.1, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
      ),
    );

    _innerCircleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.4, curve: Curves.easeOut),
      ),
    );

    _scaleAnimation = TweenSequence([
      TweenSequenceItem(
          tween: Tween<double>(begin: 1.0, end: 0.6), weight: 35),
      TweenSequenceItem(
          tween: Tween<double>(begin: 0.6, end: 1.4)
              .chain(CurveTween(curve: Curves.easeOut)), weight: 35),
      TweenSequenceItem(
          tween: Tween<double>(begin: 1.4, end: 1.0)
              .chain(CurveTween(curve: Curves.elasticOut)), weight: 30),
    ]).animate(
        CurvedAnimation(parent: _controller, curve: const Interval(0.0, 1.0)));

    _bubblesAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.1, 0.9, curve: Curves.decelerate),
      ),
    );
  }

  @override
  void didUpdateWidget(covariant LoveButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLiked && !oldWidget.isLiked) {
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap();
        // Optimistic update animation
        if (!widget.isLiked) {
           _controller.reset();
           _controller.forward();
        }
      },
      behavior: HitTestBehavior.opaque,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return SizedBox(
             width: widget.size * 2, 
             height: widget.size * 2,
             child: CustomPaint(
               painter: _LovePainter(
                 progress: _controller.value,
                 outerCircleProgress: _outerCircleAnimation.value,
                 innerCircleProgress: _innerCircleAnimation.value,
                 bubblesProgress: _bubblesAnimation.value,
                 isLiked: widget.isLiked,
                 heartColor: const Color(0xFFE91E63), // Pink
               ),
               child: Center(
                 child: Transform.scale(
                   scale: widget.isLiked && _controller.isAnimating ? _scaleAnimation.value : 1.0,
                   child: Icon(
                     widget.isLiked ? Icons.favorite : Icons.favorite_border,
                     color: widget.isLiked ? const Color(0xFFE91E63) : Colors.grey,
                     size: widget.size,
                   ),
                 ),
               ),
             ),
          );
        },
      ),
    );
  }
}

class _LovePainter extends CustomPainter {
  final double progress;
  final double outerCircleProgress;
  final double innerCircleProgress;
  final double bubblesProgress;
  final bool isLiked;
  final Color heartColor;

  _LovePainter({
    required this.progress,
    required this.outerCircleProgress,
    required this.innerCircleProgress,
    required this.bubblesProgress,
    required this.isLiked,
    required this.heartColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (!isLiked || progress == 0 || progress == 1) return;

    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width / 2;

    // 1. Ring Animation
    final Paint circlePaint = Paint()
      ..color = heartColor
      ..style = PaintingStyle.fill;

    double currentOuterRadius = maxRadius * 0.9 * outerCircleProgress;
    double currentInnerRadius = maxRadius * 0.9 * innerCircleProgress;

    if (outerCircleProgress > 0 && innerCircleProgress < 1.0) {
       Path path = Path()
        ..addOval(Rect.fromCircle(center: center, radius: currentOuterRadius))
        ..addOval(Rect.fromCircle(center: center, radius: currentInnerRadius));
      path.fillType = PathFillType.evenOdd;
      
       // Fade out as it expands
      double opacity = 1.0;
      if (innerCircleProgress > 0.6) {
         opacity = 1.0 - ((innerCircleProgress - 0.6) * 2.5);
      }
      circlePaint.color = circlePaint.color.withOpacity(opacity.clamp(0.0, 1.0));

      canvas.drawPath(path, circlePaint);
    }

    // 2. Bubbles/Particles
    // We only draw bubbles if bubblesProgress is active
    if (bubblesProgress > 0) {
      final Paint dotPaint = Paint()..style = PaintingStyle.fill;
      final List<Color> dotColors = [
        const Color(0xFFFFC107), // Amber
        const Color(0xFF4DB6AC), // Teal
        const Color(0xFF9575CD), // Purple
        const Color(0xFFF06292), // Pink
      ];

      int dotCount = 7;
      double ringRadius = maxRadius * (0.8 + (0.3 * bubblesProgress)); 
      double dotSize = (maxRadius * 0.15) * (1.0 - bubblesProgress);

      for (int i = 0; i < dotCount; i++) {
          // Angle logic: spread around circle
          double angle = (i * 2 * math.pi) / dotCount - (math.pi / 2); 
          
          double dx = center.dx + ringRadius * math.cos(angle);
          double dy = center.dy + ringRadius * math.sin(angle);

          dotPaint.color = dotColors[i % dotColors.length].withOpacity((1.0 - bubblesProgress).clamp(0.0, 1.0));
          canvas.drawCircle(Offset(dx, dy), dotSize, dotPaint);
          
          // Secondary smaller dots (optional, keeping it simple for now)
      }
    }
  }

  @override
  bool shouldRepaint(covariant _LovePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
