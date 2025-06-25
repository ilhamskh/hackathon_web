import 'package:flutter/material.dart';

class AppAnimations {
  // Duration constants
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration verySlow = Duration(milliseconds: 800);

  // Curves
  static const Curve defaultCurve = Curves.easeInOutCubic;
  static const Curve bounceCurve = Curves.elasticOut;
  static const Curve smoothCurve = Curves.easeOutQuart;

  // Slide animations
  static Widget slideInFromLeft(
    Widget child, {
    Duration? duration,
    Curve? curve,
  }) {
    return TweenAnimationBuilder<Offset>(
      duration: duration ?? normal,
      curve: curve ?? defaultCurve,
      tween: Tween(begin: const Offset(-1.0, 0.0), end: Offset.zero),
      builder: (context, offset, child) {
        return SlideTransition(
          position: AlwaysStoppedAnimation(offset),
          child: child!,
        );
      },
      child: child,
    );
  }

  static Widget slideInFromRight(
    Widget child, {
    Duration? duration,
    Curve? curve,
  }) {
    return TweenAnimationBuilder<Offset>(
      duration: duration ?? normal,
      curve: curve ?? defaultCurve,
      tween: Tween(begin: const Offset(1.0, 0.0), end: Offset.zero),
      builder: (context, offset, child) {
        return SlideTransition(
          position: AlwaysStoppedAnimation(offset),
          child: child!,
        );
      },
      child: child,
    );
  }

  static Widget slideInFromBottom(
    Widget child, {
    Duration? duration,
    Curve? curve,
  }) {
    return TweenAnimationBuilder<Offset>(
      duration: duration ?? normal,
      curve: curve ?? defaultCurve,
      tween: Tween(begin: const Offset(0.0, 1.0), end: Offset.zero),
      builder: (context, offset, child) {
        return SlideTransition(
          position: AlwaysStoppedAnimation(offset),
          child: child!,
        );
      },
      child: child,
    );
  }

  // Fade animations
  static Widget fadeIn(Widget child, {Duration? duration, Curve? curve}) {
    return TweenAnimationBuilder<double>(
      duration: duration ?? normal,
      curve: curve ?? defaultCurve,
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, opacity, child) {
        return Opacity(opacity: opacity, child: child!);
      },
      child: child,
    );
  }

  // Scale animations
  static Widget scaleIn(Widget child, {Duration? duration, Curve? curve}) {
    return TweenAnimationBuilder<double>(
      duration: duration ?? normal,
      curve: curve ?? bounceCurve,
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, scale, child) {
        return Transform.scale(scale: scale, child: child!);
      },
      child: child,
    );
  }

  // Staggered list animations
  static Widget staggeredList({
    required List<Widget> children,
    Duration? duration,
    Duration? delay,
  }) {
    return Column(
      children: children.asMap().entries.map((entry) {
        int index = entry.key;
        Widget child = entry.value;

        return TweenAnimationBuilder<double>(
          duration: (duration ?? normal) + Duration(milliseconds: index * 100),
          curve: defaultCurve,
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(0, 50 * (1 - value)),
              child: Opacity(opacity: value, child: child!),
            );
          },
          child: child,
        );
      }).toList(),
    );
  }

  // Shimmer effect for loading
  static Widget shimmer({
    required Widget child,
    Color? baseColor,
    Color? highlightColor,
  }) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1500),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                baseColor ?? Colors.grey[300]!,
                highlightColor ?? Colors.grey[100]!,
                baseColor ?? Colors.grey[300]!,
              ],
              stops: [0.0, value, 1.0],
            ).createShader(bounds);
          },
          child: child!,
        );
      },
      child: child,
    );
  }

  // Floating action
  static Widget floatingAction(Widget child, {Duration? duration}) {
    return TweenAnimationBuilder<double>(
      duration: duration ?? const Duration(seconds: 2),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 10 * (0.5 - (value - 0.5).abs())),
          child: child!,
        );
      },
      child: child,
    );
  }
}
