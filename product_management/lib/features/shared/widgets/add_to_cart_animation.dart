import 'package:flutter/material.dart';

class AddToCartAnimation {
  static void run(
    BuildContext context, {
    required GlobalKey imageKey,
    required GlobalKey cartKey,
    required String imageUrl,
    VoidCallback? onComplete,
  }) {
    final OverlayState? overlayState = Overlay.of(context);
    final RenderBox? renderBox =
        imageKey.currentContext?.findRenderObject() as RenderBox?;
    final RenderBox? cartRenderBox =
        cartKey.currentContext?.findRenderObject() as RenderBox?;

    if (overlayState == null || renderBox == null || cartRenderBox == null) {
      onComplete?.call();
      return;
    }

    final startOffset = renderBox.localToGlobal(Offset.zero);
    final endOffset = cartRenderBox.localToGlobal(Offset.zero);
    final Size imageSize = renderBox.size;

    late OverlayEntry overlayEntry;
    
    // Create an AnimationController-like effect using a StatefulWidget in Overlay
    overlayEntry = OverlayEntry(
      builder: (context) => _AnimationWidget(
        startOffset: startOffset,
        endOffset: endOffset,
        imageSize: imageSize,
        imageUrl: imageUrl,
        onComplete: () {
          overlayEntry.remove();
          onComplete?.call();
        },
      ),
    );

    overlayState.insert(overlayEntry);
  }
}

class _AnimationWidget extends StatefulWidget {
  final Offset startOffset;
  final Offset endOffset;
  final Size imageSize;
  final String imageUrl;
  final VoidCallback onComplete;

  const _AnimationWidget({
    required this.startOffset,
    required this.endOffset,
    required this.imageSize,
    required this.imageUrl,
    required this.onComplete,
  });

  @override
  State<_AnimationWidget> createState() => _AnimationWidgetState();
}

class _AnimationWidgetState extends State<_AnimationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _positionX;
  late Animation<double> _positionY;
  late Animation<double> _scale;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 800), vsync: this);

    _positionX = Tween<double>(
      begin: widget.startOffset.dx,
      end: widget.endOffset.dx,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _positionY = Tween<double>(
      begin: widget.startOffset.dy,
      end: widget.endOffset.dy,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _scale = Tween<double>(begin: 1.0, end: 0.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _opacity = Tween<double>(begin: 1.0, end: 0.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward().then((_) => widget.onComplete());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Positioned(
          left: _positionX.value,
          top: _positionY.value,
          child: Opacity(
            opacity: _opacity.value,
            child: Transform.scale(
              scale: _scale.value,
              child: SizedBox(
                width: widget.imageSize.width,
                height: widget.imageSize.height,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    widget.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
