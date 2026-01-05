import 'package:flutter/material.dart';
import 'glassmorphic_background_widget.dart';

class GlassBackgroundWidget extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final double blurSigma;

  const GlassBackgroundWidget({
    Key? key,
    required this.child,
    this.borderRadius = 10.0,
    this.padding,
    this.blurSigma = 15.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GlassmorphicBackgroundWidget(
      borderRadius: borderRadius,
      padding: padding,
      blur: 8.0,
      border: 0.8,
      linearGradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color.fromRGBO(255, 255, 255, 0.11),
          Color.fromRGBO(255, 255, 255, 0.11),
        ],
        stops: [0.5, 0.5],
      ),
      borderGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          const Color.fromRGBO(255, 255, 255, 0.1).withOpacity(0.2),
          const Color.fromRGBO(255, 255, 255, 0.1).withOpacity(0.2),
          const Color.fromRGBO(255, 255, 255, 0.1).withOpacity(0.2),
          const Color.fromRGBO(255, 255, 255, 0.1).withOpacity(0.2),
          const Color.fromRGBO(255, 255, 255, 0.1).withOpacity(0.2),
          const Color.fromRGBO(255, 255, 255, 0.1).withOpacity(0.2),
          const Color.fromRGBO(255, 255, 255, 0.1).withOpacity(0.2),
        ],
        stops: const [0.0, 0.5, 1.0, 0.55, 0.70, 0.85, 1.00],
      ),
      child: child,
    );
  }
}
