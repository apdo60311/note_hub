import 'package:flutter/material.dart';

class AnimatedTransitionRoute extends PageRouteBuilder {
  AnimatedTransitionRoute({
    required Widget page,
    RouteSettings? settings,
  }) : super(
            pageBuilder: (context, firstAnimation, secondAnimation) => page,
            settings: settings,
            transitionsBuilder:
                (context, firstAnimation, secondAnimation, child) {
              var tween = Tween(begin: 0.0, end: 1.0);
              var offsetAnimation = firstAnimation.drive(tween);

              return FadeTransition(
                opacity: offsetAnimation,
                child: child,
              );
            });
}
