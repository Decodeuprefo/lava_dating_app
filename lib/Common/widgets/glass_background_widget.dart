import 'dart:ui';
import 'package:flutter/material.dart';

class GlassBackgroundWidget extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final double blurSigma;

  const GlassBackgroundWidget({
    Key? key,
    required this.child,
    this.borderRadius = 15.0,
    this.padding,
    this.blurSigma = 15.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadius),
                color: Colors.transparent,
              ),
            ),
          ),
          Container(
            padding: padding,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              // Gradient overlay - lighter on top-left, darker on bottom-right
              // Very low opacity (0.15-0.25) to make background blur clearly visible
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  // Top-left: lighter purple with minimal opacity for glass shine
                  const Color(0xFF2A1F3A).withOpacity(0.15),
                  // Middle: base purple tint
                  const Color(0xFF2A1F3A).withOpacity(0.20),
                  // Bottom-right: slightly darker purple
                  const Color(0xFF2A1F3A).withOpacity(0.25),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
              // Light border for glass edge effect - more visible
              border: Border.all(
                color: Colors.white.withOpacity(0.25),
                width: 1.0,
              ),
            ),
            child: child,
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(borderRadius),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(borderRadius),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(0.25),
                        // Quick fade to transparent
                        Colors.white.withOpacity(0.12),
                        Colors.white.withOpacity(0.06),
                        // Fully transparent for rest of the card
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.10, 0.20, 1.0],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
