import 'package:flutter/material.dart';
import 'package:lava_dating_app/Common/constant/color_constants.dart';
import 'package:lava_dating_app/Common/constant/common_text_style.dart';

class AnimatedWhiteButton extends StatefulWidget {
  final String label;
  final VoidCallback? onTap;
  final double width;
  final double height;

  const AnimatedWhiteButton({
    Key? key,
    required this.label,
    this.onTap,
    this.width = 100,
    this.height = 35,
  }) : super(key: key);

  @override
  _AnimatedWhiteButtonState createState() => _AnimatedWhiteButtonState();
}

class _AnimatedWhiteButtonState extends State<AnimatedWhiteButton> {
  bool _pressed = false;

  void _onTapDown(TapDownDetails details) {
    setState(() => _pressed = true);
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _pressed = false);
  }

  void _onTapCancel() {
    setState(() => _pressed = false);
  }

  @override
  Widget build(BuildContext context) {
    // scale slightly when pressed
    final scale = _pressed ? 0.97 : 1.0;
    // subtle shadow when not pressed
    final boxShadow = _pressed
        ? <BoxShadow>[]
        : <BoxShadow>[
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ];

    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: _onTapDown,
        onTapUp: (details) {
          _onTapUp(details);
          Future.microtask(() => widget.onTap?.call());
        },
        onTapCancel: _onTapCancel,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
          width: widget.width,
          height: widget.height,
          transform: Matrix4.identity()..scale(scale, scale),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 255, 255),
            borderRadius: BorderRadius.circular(12),
            boxShadow: boxShadow,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              onTap: widget.onTap,
              child: Center(
                child: Text(
                  widget.label,
                  style: CommonTextStyle.regular12w400.copyWith(color: ColorConstants.lightOrange),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
