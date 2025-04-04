import 'package:flutter/material.dart';

Route createPageRoute1(Widget page) {
  // Transition from Lower to Upper
  return PageRouteBuilder(
    transitionDuration: Duration(milliseconds: 1500),
    reverseTransitionDuration: Duration(milliseconds: 1500),
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // Duration(seconds: 2);
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(position: animation.drive(tween), child: child);
    },
  );
}

Route createPageRoute2(Widget page) {
  // Fade Transition
  return PageRouteBuilder(
    transitionDuration: Duration(milliseconds: 200),
    reverseTransitionDuration: Duration(milliseconds: 200),
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = 0.0;
      const end = 1.0;
      const curve = Curves.easeIn;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var opacityAnimation = animation.drive(tween);

      return FadeTransition(
        opacity: opacityAnimation,
        child: child,
      );
    },
  );
}

Route createPageRoute3(Widget page) {
  // upper to lower
  return PageRouteBuilder(
    transitionDuration: Duration(milliseconds: 1600),
    reverseTransitionDuration: Duration(milliseconds: 1600),
    barrierColor: Colors.transparent,
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, -1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);

      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
  );
}

Route createPageRoute4(Widget page) {
  // Fade Transition - Quick
  return PageRouteBuilder(
    transitionDuration: Duration(milliseconds: 100),
    reverseTransitionDuration: Duration(milliseconds: 100),
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = 0.0;
      const end = 1.0;
      const curve = Curves.easeIn;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var opacityAnimation = animation.drive(tween);

      return FadeTransition(
        opacity: opacityAnimation,
        child: child,
      );
    },
  );
}