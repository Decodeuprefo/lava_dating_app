import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BackgroundContainer extends StatelessWidget {
  final Widget child;

  const BackgroundContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final Size screen = MediaQuery.of(context).size;
    final double dpr = MediaQuery.of(context).devicePixelRatio;
    final int cacheW = (screen.width * dpr).round();
    final int cacheH = (screen.height * dpr).round();
    final fullScreenSize = MediaQuery.of(context).size;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: IgnorePointer(
              child: SizedBox(
                width: fullScreenSize.width,
                height: fullScreenSize.height,
                child: RepaintBoundary(
                  child: Image.asset(
                    'assets/images/app_background.jpg',
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.none,
                    cacheWidth: cacheW,
                    cacheHeight: cacheH,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(color: Colors.black);
                    },
                  ),
                ),
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}
