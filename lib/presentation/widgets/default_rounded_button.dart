import 'dart:async';
import 'dart:developer';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';

class DefaultRoundedButton extends StatefulWidget {
  const DefaultRoundedButton({
    super.key,
    required this.label,
    required this.onClick,
    this.width,
    this.height,
  });

  final String label;

  final void Function() onClick;

  final double? width;
  final double? height;

  @override
  State<DefaultRoundedButton> createState() => _DefaultRoundedButtonState();
}

class _DefaultRoundedButtonState extends State<DefaultRoundedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  late Animation _squeezeAnimation;

  late double _width, _height;

  @override
  void initState() {
    _width = widget.width ?? 200;
    _height = widget.height ?? 55;

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..addListener(() {
        setState(() {});
      });

    _squeezeAnimation = Tween(begin: _width, end: 60.0).animate(CurvedAnimation(
        parent: _animationController, curve: const Interval(0.0, 0.250)));

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _playAnimationAndDoClickMethod() async {
    try {
      await _animationController.forward();
      widget.onClick();
      await _animationController.reverse();
    } on TickerCanceled {
      log('error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _playAnimationAndDoClickMethod();
      },
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        width: _squeezeAnimation.value,
        height: _height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Colors.blue,
        ),
        child: ConditionalBuilder(
          condition: _squeezeAnimation.value < 70,
          builder: (BuildContext context) => const Center(
              child: CircularProgressIndicator(
            strokeWidth: 1,
            color: Colors.white,
          )),
          fallback: (BuildContext context) => Center(
            child: Text(
              widget.label,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
                overflow: TextOverflow.fade,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
