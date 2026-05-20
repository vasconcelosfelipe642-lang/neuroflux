import 'package:flutter/material.dart';

class FadePageRoute<T> extends PageRouteBuilder<T> {
  FadePageRoute({required Widget child, RouteSettings? settings})
      : super(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 400),
        );
}
