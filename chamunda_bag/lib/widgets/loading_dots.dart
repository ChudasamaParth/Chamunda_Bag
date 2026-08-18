import 'package:flutter/material.dart';

class LoadingDots extends StatefulWidget {
  const LoadingDots({super.key});

  @override
  State<LoadingDots> createState() => _LoadingDotsState();
}

class _LoadingDotsState extends State<LoadingDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget buildDot(int index) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        final value = (_controller.value * 3 - index).clamp(0.0, 1.0);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Transform.scale(
            scale: 0.7 + value * 0.5,
            child: Opacity(
              opacity: 0.3 + value * 0.7,
              child: const CircleAvatar(
                radius: 4,
                backgroundColor: Color(0xff6F4E37),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [buildDot(0), buildDot(1), buildDot(2)],
    );
  }
}
