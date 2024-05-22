import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomShimmer extends StatelessWidget {
  final Widget child;

  const CustomShimmer({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFCDCDCD),
          Color(0xFFE6E6E6),
          Color(0xFFCDCDCD),
        ],
        stops: [
          0.35,
          0.5,
          0.65,
        ],
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: child,
      ),
    );
  }
}

class ShimmerContainer extends StatelessWidget {
  final double borderRadius;
  final Widget? child;
  final double opacity;

  const ShimmerContainer({
    super.key,
    this.borderRadius = 5.0,
    this.child,
    this.opacity = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(borderRadius),
        ),
        color: Colors.white.withOpacity(opacity),
      ),
      child: child,
    );
  }
}
