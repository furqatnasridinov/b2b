import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// [SlideRouteTransition]
///
/// Slides a [child] in from the right and slides out to the left.
class SlideRouteTransition extends CustomTransitionPage<void> {
  SlideRouteTransition({
    required super.key,
    required super.child,
    bool hideReverseAnimation = false,
  }) : super(
          transitionDuration: const Duration(milliseconds: 150),
          reverseTransitionDuration: hideReverseAnimation ? Duration.zero : 
            const Duration(milliseconds: 200),
          transitionsBuilder: (
            context,
            animation,
            secondaryAnimation,
            child,
          ) {
            // if animation is reverse, return child without animation
            if (animation.status == AnimationStatus.reverse && hideReverseAnimation) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            }
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1, 0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: Curves.fastOutSlowIn,
                  reverseCurve: Curves.easeOutQuad,
                ),
              ),
              child: child,
            );
          },
          
        );
}

/// [SlideUpRouteTransition]
///
/// Slides a [child] in from the bottom and slides out to the top for
/// modal-like transition.
class SlideUpRouteTransition extends CustomTransitionPage<void> {
  SlideUpRouteTransition({
    required super.key,
    required super.child,
  }) : super(
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (
            context,
            animation,
            secondaryAnimation,
            child,
          ) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 1),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: Curves.fastOutSlowIn,
                  reverseCurve: Curves.easeOut,
                ),
              ),
              child: child,
            );
          },
        );
}

/// [FadeRouteTransition]
///
/// Fades a [child] in and out
class FadeRouteTransition extends CustomTransitionPage<dynamic> {
  FadeRouteTransition({
    required super.key,
    required super.child,
  }) : super(
          transitionsBuilder: (
            context,
            animation,
            secondaryAnimation,
            child,
          ) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 500),
          reverseTransitionDuration: const Duration(milliseconds: 500),
        );
}

/// [DualSlideRouteTransition]
///
/// Combines two slide transitions simultaneously that exits [exitChild]
/// and enters [enterChild].
class DualSlideRouteTransition extends CustomTransitionPage<void> {
  DualSlideRouteTransition({
    required super.key,
    required this.exitChild,
    required this.enterChild,
  }) : super(
          child: Container(),
          transitionsBuilder: (
            context,
            animation,
            secondaryAnimation,
            child,
          ) {
            return Stack(
              children: <Widget>[
                SlideTransition(
                  position: Tween<Offset>(
                    begin: Offset.zero,
                    end: const Offset(-0.3, 0),
                  ).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeInOut,
                    ),
                  ),
                  child: exitChild,
                ),
                SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1, 0),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeInOut,
                    ),
                  ),
                  child: enterChild,
                ),
              ],
            );
          },
          transitionDuration: const Duration(milliseconds: 500),
          reverseTransitionDuration: const Duration(milliseconds: 500),
          barrierColor: Colors.black87,
        );

  final Widget enterChild;
  final Widget exitChild;
}
