// import 'package:flutter/material.dart';

// class PageAnimation extends StatefulWidget {
//   const PageAnimation({super.key});

//   @override
//   State<PageAnimation> createState() => _PageAnimationState();
// }

// class _PageAnimationState extends State<PageAnimation> {
//   PageRouteBuilder pageAnimation(Widget page) {
//     return PageRouteBuilder(
//       transitionDuration: Duration(seconds: 2),
//       pageBuilder: (context, animation, secondaryAnimation) => page,
//       transitionsBuilder: (context, animation, secondaryAnimation, child) {
//         const begin = Offset(0.1, 0.0);
//         const end = Offset.zero;
//         const curve = Curves.ease;

//         var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
//         var offsetAnimation = animation.drive(tween);

//         return SlideTransition(
//           position: offsetAnimation,
//           child: child,
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(); // Placeholder for the widget tree
//   }
// }

// // Function to be called from other pages
// PageRouteBuilder pageAnimation1(Widget page) {
//   return PageRouteBuilder(
//     transitionDuration: Duration(seconds: 5),
//     pageBuilder: (context, animation, secondaryAnimation) => page,
//     transitionsBuilder: (context, animation, secondaryAnimation, child) {
//       const begin = Offset(0.1, 0.0);
//       const end = Offset.zero;
//       final tween = Tween(begin: begin, end: end);
//       final offsetAnimation = animation.drive(tween);

//     var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

//     return SlideTransition(position: animation.drive(tween), child: child);
//       },);
//     }

import 'package:flutter/material.dart';

Route createPageRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      Duration(seconds: 2);
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(position: animation.drive(tween), child: child);
    },
  );
}