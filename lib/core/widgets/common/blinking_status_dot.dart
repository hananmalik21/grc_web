import 'package:flutter/material.dart';

import 'digify_status_dot.dart';

class BlinkingStatusDot extends StatefulWidget {
  const BlinkingStatusDot({
    super.key,
    required this.color,
    this.size = 7,
    this.duration = const Duration(milliseconds: 900),
  });

  final Color color;
  final double size;
  final Duration duration;

  @override
  State<BlinkingStatusDot> createState() => _BlinkingStatusDotState();
}

class _BlinkingStatusDotState extends State<BlinkingStatusDot> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(
        begin: 0.25,
        end: 1,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut)),
      child: DigifyStatusDot(color: widget.color, size: widget.size),
    );
  }
}
