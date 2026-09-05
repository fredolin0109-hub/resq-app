import 'package:flutter/material.dart';

/// Clean and simple fade transition route without custom animation overhead.
class RescueFadeRoute<T> extends PageRouteBuilder<T> {
  final Widget page;

  RescueFadeRoute({
    required this.page,
    super.settings,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 300),
          reverseTransitionDuration: const Duration(milliseconds: 250),
        );
}
