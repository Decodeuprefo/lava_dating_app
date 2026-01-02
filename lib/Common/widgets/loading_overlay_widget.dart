import 'package:flutter/material.dart';
import '../constant/color_constants.dart';

class LoadingOverlayWidget extends StatelessWidget {
  final bool isLoading;
  final double opacity;

  const LoadingOverlayWidget({
    Key? key,
    required this.isLoading,
    this.opacity = 0.5,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!isLoading) return const SizedBox.shrink();

    return Container(
      color: Colors.black.withOpacity(opacity),
      child: const Center(
        child: CircularProgressIndicator(
          color: ColorConstants.lightOrange,
        ),
      ),
    );
  }
}
