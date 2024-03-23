import 'package:flutter/material.dart';

class NoteShimmerEffect extends StatefulWidget {
  const NoteShimmerEffect({super.key});

  @override
  State<NoteShimmerEffect> createState() => _NoteShimmerEffectState();
}

class _NoteShimmerEffectState extends State<NoteShimmerEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3500),
    )..repeat();

    _animation = Tween<double>(begin: 0.2, end: 0.4).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.grey.withOpacity(_animation.value),
        ),
      ),
    );
  }
}
