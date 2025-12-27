import 'package:flutter/material.dart';

class MaskButton extends StatefulWidget {
  final bool isConnected;
  final bool isConnecting;
  final bool isDisconnecting;
  final VoidCallback onTap;

  const MaskButton({
    super.key,
    required this.isConnected,
    required this.isConnecting,
    required this.isDisconnecting,
    required this.onTap,
  });

  @override
  State<MaskButton> createState() => _MaskButtonState();
}

class _MaskButtonState extends State<MaskButton> 
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
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
    final isLoading = widget.isConnecting || widget.isDisconnecting;
    
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        if (!isLoading) widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: widget.isConnected 
                    ? Colors.green.withOpacity(0.3)
                    : Colors.black.withOpacity(0.3),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Mask image
              ClipOval(
                child: Image.asset(
                  widget.isConnected 
                      ? 'assets/images/mask-two.png'
                      : 'assets/images/mask.png',
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback if images not found
                    return Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.1),
                        border: Border.all(
                          color: widget.isConnected 
                              ? Colors.green 
                              : Colors.white24,
                          width: 3,
                        ),
                      ),
                      child: Icon(
                        widget.isConnected 
                            ? Icons.lock_open 
                            : Icons.lock,
                        size: 80,
                        color: widget.isConnected 
                            ? Colors.green 
                            : Colors.white54,
                      ),
                    );
                  },
                ),
              ),
              
              // Loading overlay
              if (isLoading)
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black.withOpacity(0.5),
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class AnimatedBuilder extends AnimatedWidget {
  final Widget Function(BuildContext, Widget?) builder;
  final Widget? child;

  const AnimatedBuilder({
    super.key,
    required Animation<double> animation,
    required this.builder,
    this.child,
  }) : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    return builder(context, child);
  }
}

