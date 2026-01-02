import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';

class _ContentSizedGlassmorphic extends StatefulWidget {
  final double borderRadius;
  final double blur;
  final double border;
  final Alignment alignment;
  final LinearGradient? linearGradient;
  final LinearGradient? borderGradient;
  final Widget child;

  const _ContentSizedGlassmorphic({
    required this.borderRadius,
    required this.blur,
    required this.border,
    required this.alignment,
    this.linearGradient,
    this.borderGradient,
    required this.child,
  });

  @override
  State<_ContentSizedGlassmorphic> createState() => _ContentSizedGlassmorphicState();
}

class _ContentSizedGlassmorphicState extends State<_ContentSizedGlassmorphic> {
  final GlobalKey _measureKey = GlobalKey();
  double? _contentWidth;
  double? _contentHeight;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateSize());
  }

  void _updateSize() {
    final RenderBox? box = _measureKey.currentContext?.findRenderObject() as RenderBox?;
    if (box != null && box.hasSize && mounted) {
      final width = box.size.width;
      final height = box.size.height;
      if (width.isFinite && height.isFinite && width > 0 && height > 0) {
        if (_contentWidth != width || _contentHeight != height) {
          setState(() {
            _contentWidth = width;
            _contentHeight = height;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateSize());

    if (_contentWidth != null &&
        _contentHeight != null &&
        _contentWidth! > 0 &&
        _contentHeight! > 0 &&
        _contentWidth!.isFinite &&
        _contentHeight!.isFinite) {
      return GlassmorphicContainer(
        width: _contentWidth!,
        height: _contentHeight!,
        borderRadius: widget.borderRadius,
        blur: widget.blur,
        border: widget.border,
        alignment: widget.alignment,
        linearGradient: widget.linearGradient ??
            LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color.fromRGBO(255, 255, 255, 0.1).withOpacity(0.08),
                const Color.fromRGBO(255, 255, 255, 0.1).withOpacity(0.08),
                const Color.fromRGBO(255, 255, 255, 0.1).withOpacity(0.08),
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
        borderGradient: widget.borderGradient ??
            LinearGradient(
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
        child: widget.child,
      );
    }

    return Opacity(
      opacity: 0.0,
      child: Container(
        key: _measureKey,
        child: widget.child,
      ),
    );
  }
}

class _GlassmorphicDynamicHeight extends StatefulWidget {
  final double? width;
  final double borderRadius;
  final double blur;
  final double border;
  final Alignment alignment;
  final LinearGradient? linearGradient;
  final LinearGradient? borderGradient;
  final Widget child;

  const _GlassmorphicDynamicHeight({
    this.width,
    required this.borderRadius,
    required this.blur,
    required this.border,
    required this.alignment,
    this.linearGradient,
    this.borderGradient,
    required this.child,
  });

  @override
  State<_GlassmorphicDynamicHeight> createState() => _GlassmorphicDynamicHeightState();
}

class _GlassmorphicDynamicHeightState extends State<_GlassmorphicDynamicHeight> {
  final GlobalKey _measureKey = GlobalKey();
  double? _contentHeight;
  double? _contentWidth;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateSize());
  }

  void _updateSize() {
    final RenderBox? box = _measureKey.currentContext?.findRenderObject() as RenderBox?;
    if (box != null && mounted) {
      final height = box.size.height;
      final width = widget.width ?? box.size.width;
      if (_contentHeight != height || _contentWidth != width) {
        setState(() {
          _contentHeight = height;
          _contentWidth = width;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateSize());

    final containerWidth = widget.width;
    final containerHeight = _contentHeight ?? 0.0;

    if (containerWidth == null) {
      return _ContentSizedGlassmorphic(
        borderRadius: widget.borderRadius,
        blur: widget.blur,
        border: widget.border,
        alignment: widget.alignment,
        linearGradient: widget.linearGradient,
        borderGradient: widget.borderGradient,
        child: widget.child,
      );
    }

    return Stack(
      children: [
        Offstage(
          child: SizedBox(
            width: widget.width,
            child: Container(
              key: _measureKey,
              child: widget.child,
            ),
          ),
        ),
        GlassmorphicContainer(
          width: containerWidth,
          height: containerHeight,
          borderRadius: widget.borderRadius,
          blur: widget.blur,
          border: widget.border,
          alignment: widget.alignment,
          linearGradient: widget.linearGradient ??
              LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color.fromRGBO(255, 255, 255, 0.1).withOpacity(0.08),
                  const Color.fromRGBO(255, 255, 255, 0.1).withOpacity(0.08),
                  const Color.fromRGBO(255, 255, 255, 0.1).withOpacity(0.08),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
          borderGradient: widget.borderGradient ??
              LinearGradient(
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
          child: widget.child,
        ),
      ],
    );
  }
}

class GlassmorphicBackgroundWidget extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final double blur;
  final double border;
  final Alignment? alignment;
  final LinearGradient? linearGradient;
  final LinearGradient? borderGradient;
  final double? width;
  final double? height;

  const GlassmorphicBackgroundWidget({
    Key? key,
    required this.child,
    this.borderRadius = 15.0,
    this.padding,
    this.blur = 8.0,
    this.border = 0.8,
    this.alignment,
    this.linearGradient,
    this.borderGradient,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget content = padding != null
        ? Padding(
            padding: padding!,
            child: child,
          )
        : child;

    if (width == null) {
      return _ContentSizedGlassmorphic(
        borderRadius: borderRadius,
        blur: blur,
        border: border,
        alignment: alignment ?? Alignment.center,
        linearGradient: linearGradient,
        borderGradient: borderGradient,
        child: content,
      );
    }

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final containerWidth = width ??
            (constraints.maxWidth.isFinite &&
                    constraints.maxWidth > 0 &&
                    constraints.maxWidth != double.infinity
                ? constraints.maxWidth
                : MediaQuery.of(context).size.width);

        if (height != null) {
          return GlassmorphicContainer(
            width: containerWidth,
            height: height!,
            borderRadius: borderRadius,
            blur: blur,
            border: border,
            alignment: alignment ?? Alignment.center,
            linearGradient: linearGradient ??
                LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color.fromRGBO(255, 255, 255, 0.1).withOpacity(0.08),
                    const Color.fromRGBO(255, 255, 255, 0.1).withOpacity(0.08),
                    const Color.fromRGBO(255, 255, 255, 0.1).withOpacity(0.08),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
            borderGradient: borderGradient ??
                LinearGradient(
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
            child: content,
          );
        }

        return ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: containerWidth,
            maxWidth: containerWidth,
            minHeight: 0,
            maxHeight: constraints.maxHeight.isFinite && constraints.maxHeight > 0
                ? constraints.maxHeight
                : double.infinity,
          ),
          child: _GlassmorphicDynamicHeight(
            width: containerWidth,
            borderRadius: borderRadius,
            blur: blur,
            border: border,
            alignment: alignment ?? Alignment.center,
            linearGradient: linearGradient,
            borderGradient: borderGradient,
            child: content,
          ),
        );
      },
    );
  }
}
