import 'package:flutter/material.dart';

class BackgroundContainer extends StatelessWidget {
  final Widget child;

  const BackgroundContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final Size screen = MediaQuery.of(context).size;
    final double dpr = MediaQuery.of(context).devicePixelRatio;
    // Request an image decode roughly at screen resolution (in physical pixels)
    final int cacheW = (screen.width * dpr).round();
    final int cacheH = (screen.height * dpr).round();

    return Stack(
      fit: StackFit.expand,
      children: [
        // RepaintBoundary is fine to keep; but ensure image decode & sampling are safe
        RepaintBoundary(
          child: Image.asset(
            'assets/images/app_background.jpg',
            fit: BoxFit.cover,
            // IMPORTANT: reduce filterQuality so the engine avoids mipmap sampling
            filterQuality: FilterQuality.none,
            // Provide a reasonable decode size to avoid runtime scaling/mip requirements
            cacheWidth: cacheW,
            cacheHeight: cacheH,
            errorBuilder: (context, error, stackTrace) {
              return Container(color: Colors.black);
            },
          ),
        ),
        child,
      ],
    );
  }
}
