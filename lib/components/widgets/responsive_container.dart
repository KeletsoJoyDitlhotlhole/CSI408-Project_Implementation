import 'package:flutter/material.dart';

class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final double maxHeight;
  final BorderRadius? borderRadius;
  final Color backgroundColor;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.maxWidth = 360,
    this.maxHeight = 800,
    this.borderRadius,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 640;

    return Container(
      width: isSmallScreen ? screenSize.width : maxWidth,
      height: isSmallScreen ? screenSize.height : maxHeight,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius ?? BorderRadius.circular(25),
      ),
      child: child,
    );
  }
}
