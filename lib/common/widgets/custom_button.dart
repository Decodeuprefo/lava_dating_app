import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constant/color_constants.dart';
import '../constant/common_text_style.dart';

enum AppButtonShape { rounded, circle, stadium }

enum _IconPosition { start, end }

class AppButton extends StatelessWidget {
  /// Text label to show. Use empty string for icon-only buttons.
  final String text;

  /// Optional text style (font size, weight, letter spacing overrides).
  final TextStyle? textStyle;

  /// Optional icon (IconData).
  final IconData? icon;

  /// Optional image (ImageProvider). Takes precedence over [icon] when provided.
  final ImageProvider? image;

  /// If true, show a CircularProgressIndicator instead of text/icon.
  final bool isLoading;

  /// Callback when pressed.
  final VoidCallback? onPressed;

  /// Callback when long pressed.
  final VoidCallback? onLongPress;

  /// Explicit width (pixels). If null, width determined by content, constraints, or adaptive flag.
  final double? width;

  /// Explicit height (pixels). If null, height is inferred from padding & text size.
  final double? height;

  /// Minimum width constraint.
  final double? minWidth;

  /// Maximum width constraint.
  final double? maxWidth;

  /// Minimum height constraint.
  final double? minHeight;

  /// Maximum height constraint.
  final double? maxHeight;

  /// Internal content padding.
  final EdgeInsetsGeometry padding;

  /// External margin around button.
  final EdgeInsetsGeometry margin;

  /// Background color when enabled.
  final Color backgroundColor;

  /// Background color when disabled.
  final Color disabledColor;

  /// Border color. If null and an outline style is desired, pass transparent background via backgroundColor.
  final Color? borderColor;

  /// Border radius for rounded shape. If null, default is 8.0 for rounded.
  final double? borderRadius;

  /// Elevation (shadow). For flat look set to 0.
  final double elevation;

  /// Whether the button is interactive.
  final bool enabled;

  /// Visual shape of the button.
  final AppButtonShape shape;

  /// If true, on small screens the button becomes full-width (minus margin).
  /// On larger screens it respects [width] or intrinsic size.
  final bool adaptive;

  /// Breakpoint (in logical pixels) for adaptive behavior. If screen width <= breakpoint, full-width is used.
  final double adaptiveBreakpoint;

  /// Semantic label for accessibility. Falls back to [text] if null.
  final String? semanticLabel;

  /// Tooltip text. If provided, a Material tooltip will wrap the button.
  final String? tooltip;

  /// Whether to show the icon/image at start (left) or end (right). Use `_IconPosition.start` or `.end`.
  final _IconPosition _iconPosition;

  /// Progress indicator size when [isLoading] is true.
  final double loadingIndicatorSize;

  /// Color for progress indicator when [isLoading].
  final Color? loadingIndicatorColor;

  /// Constructor.
  const AppButton({
    Key? key,
    required this.text,
    this.textStyle,
    this.icon,
    this.image,
    this.isLoading = false,
    this.onPressed,
    this.onLongPress,
    this.width,
    this.height,
    this.minWidth,
    this.maxWidth,
    this.minHeight,
    this.maxHeight,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.margin = EdgeInsets.zero,
    this.backgroundColor = ColorConstants.lightOrange,
    this.disabledColor = const Color(0xFFBBBBBB),
    this.borderColor,
    this.borderRadius,
    this.elevation = 2.0,
    this.enabled = true,
    this.shape = AppButtonShape.rounded,
    this.adaptive = true,
    this.adaptiveBreakpoint = 480,
    this.semanticLabel,
    this.tooltip,
    String iconPosition = 'start',
    this.loadingIndicatorSize = 18.0,
    this.loadingIndicatorColor,
  })  : _iconPosition = (iconPosition == 'end') ? _IconPosition.end : _IconPosition.start,
        super(key: key);

  bool get _hasVisualIcon => image != null || icon != null;

  @override
  Widget build(BuildContext context) {
    final bool isInteractive = enabled && onPressed != null && !isLoading;

    // Colors
    // final Color effectiveBg = isInteractive ? backgroundColor : disabledColor;
    final Color effectiveBg = backgroundColor;
    final Color effectiveLoadingColor =
        loadingIndicatorColor ?? _foregroundColorForBackground(effectiveBg);

    Widget buttonChild = _buildChild(context, effectiveLoadingColor);

    // Apply padding inside visual material
    buttonChild = Padding(padding: padding, child: buttonChild);

    // Determine decoration shape & radius
    final BorderRadius resolvedRadius = _resolveBorderRadius();

    // Wrap with Material for elevation and InkWell for touch ripple
    final Widget materialButton = Material(
      color: (shape == AppButtonShape.stadium) ? effectiveBg : effectiveBg,
      elevation: elevation,
      shape: _buildShape(resolvedRadius),
      child: InkWell(
        onTap: isInteractive ? onPressed : null,
        onLongPress: (enabled && onLongPress != null) ? onLongPress : null,
        customBorder: _buildShape(resolvedRadius),
        child: ConstrainedBox(
          constraints: _buildConstraints(context),
          child: SizedBox(
            width: _computedWidth(context),
            height: height,
            child: Center(child: buttonChild),
          ),
        ),
      ),
    );

    // Apply border if needed by wrapping in Container with decoration
    Widget decorated = Container(
      margin: margin,
      decoration: _buildBorderDecoration(resolvedRadius, effectiveBg),
      child: materialButton,
    );

    // Tooltip (optional)
    if (tooltip != null && tooltip!.isNotEmpty) {
      decorated = Tooltip(message: tooltip!, child: decorated);
    }

    // Semantics for accessibility
    return Semantics(
      button: true,
      label: semanticLabel ?? text,
      enabled: enabled,
      child: decorated,
    );
  }

  /// Builds the inner child: loading indicator or Row with icon/image and text.
  Widget _buildChild(BuildContext context, Color loadingColor) {
    if (isLoading) {
      return SizedBox(
        width: loadingIndicatorSize,
        height: loadingIndicatorSize,
        child: CircularProgressIndicator(
          strokeWidth: 2.0,
          valueColor: AlwaysStoppedAnimation<Color>(loadingColor),
        ),
      );
    }

    final TextStyle defaultStyle = Get.theme.textTheme.labelLarge?.copyWith(
          color: _foregroundColorForBackground(backgroundColor),
        ) ??
        TextStyle(color: _foregroundColorForBackground(backgroundColor), fontSize: 16);

    final TextStyle effectiveTextStyle = defaultStyle.merge(textStyle);

    Widget? visual;
    if (image != null) {
      visual = Image(
        image: image!,
        width: (effectiveTextStyle.fontSize ?? 16) != 0 ? (effectiveTextStyle.fontSize! + 6) : 20,
        height: (effectiveTextStyle.fontSize ?? 16) != 0 ? (effectiveTextStyle.fontSize! + 6) : 20,
        fit: BoxFit.contain,
      );
    } else if (icon != null) {
      visual = Icon(
        icon,
        size: (effectiveTextStyle.fontSize ?? 16) + 6,
        color: effectiveTextStyle.color,
      );
    }

    final List<Widget> children = [];

    // Plain text widget (NOT wrapped with Flexible here)
    final Widget textWidget = Text(
      text,
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      textAlign: TextAlign.center,
      style: textStyle ?? CommonTextStyle.regular16w500,
    );

    // If icon at start, add it
    if (_hasVisualIcon && _iconPosition == _IconPosition.start && visual != null) {
      children.add(visual);
      children.add(const SizedBox(width: 8));
    }

    // Add text (plain) only if non-empty
    if (text.isNotEmpty) {
      children.add(textWidget);
    } else {
      // no text - if there is visual, center it
      if (visual != null && children.isEmpty) {
        children.add(visual);
      }
    }

    // If icon at end, add it
    if (_hasVisualIcon && _iconPosition == _IconPosition.end && visual != null) {
      if (children.isNotEmpty && text.isNotEmpty) children.add(const SizedBox(width: 8));
      children.add(visual);
    }

    // If only one child, return it directly (no Flexible) — avoids ParentDataWidget errors
    if (children.length == 1) {
      return children.first;
    }

    // If there are multiple children (icon + text, or text + icon) we want the text to be flexible.
    // Replace the plain text widget in the list with Flexible(textWidget) so it can ellipsize correctly.
    for (int i = 0; i < children.length; i++) {
      if (identical(children[i], textWidget)) {
        children[i] = Flexible(child: textWidget);
        break;
      }
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }

  /// Compute width considering adaptive behavior.
  double? _computedWidth(BuildContext context) {
    if (!adaptive) return width;
    final double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= adaptiveBreakpoint) {
      // return full width minus horizontal margins
      final double horizontalMargin = (margin.horizontal).clamp(0.0, double.infinity);
      final double full = screenWidth - horizontalMargin;
      // if explicit width given, prefer explicit but not larger than full
      if (width != null) {
        return width! <= full ? width : full;
      }
      return full;
    } else {
      // larger screens: use explicit width or intrinsic
      return width;
    }
  }

  /// Build BoxConstraints from min/max values.
  BoxConstraints _buildConstraints(BuildContext context) {
    final double minW = minWidth ?? 0.0;
    final double maxW = maxWidth ?? double.infinity;
    final double minH = minHeight ?? 0.0;
    final double maxH = maxHeight ?? double.infinity;
    return BoxConstraints(
      minWidth: minW,
      maxWidth: maxW,
      minHeight: minH,
      maxHeight: maxH,
    );
  }

  /// Resolve border radius depending on selected [shape].
  BorderRadius _resolveBorderRadius() {
    if (shape == AppButtonShape.circle) {
      return BorderRadius.circular(9999);
    } else if (shape == AppButtonShape.stadium) {
      return BorderRadius.circular(9999);
    } else {
      return BorderRadius.circular(borderRadius ?? 8.0);
    }
  }

  /// Build appropriate shape for Material / InkWell.
  ShapeBorder _buildShape(BorderRadius resolvedRadius) {
    if (shape == AppButtonShape.circle) {
      return const CircleBorder(side: BorderSide.none);
    } else if (shape == AppButtonShape.stadium) {
      return const StadiumBorder();
    } else {
      return RoundedRectangleBorder(borderRadius: resolvedRadius);
    }
  }

  /// Build decoration for border (outline) and background clipping.
  BoxDecoration? _buildBorderDecoration(BorderRadius radius, Color effectiveBg) {
    if (borderColor != null) {
      // If border is requested explicitly
      return BoxDecoration(
        borderRadius: radius,
        border: Border.all(color: borderColor!),
        // keep background color on container to ensure border appears (Material will overlay)
        color: Colors.transparent,
      );
    }
    // No additional decoration needed
    return null;
  }

  /// Simple contrast-check: choose a readable foreground color for given background.
  Color _foregroundColorForBackground(Color bg) {
    // Compute luminance; threshold tuned for readability
    return bg.computeLuminance() > 0.5 ? Colors.black : Colors.white;
  }
}

/// Example 1: Icon-only small button.
class ExampleIconOnlySmall extends StatelessWidget {
  const ExampleIconOnlySmall({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppButton(
      text: '',
      icon: Icons.login,
      // small padding + explicit small size
      padding: const EdgeInsets.all(8),
      width: 44,
      height: 44,
      backgroundColor: Colors.deepOrange,
      onPressed: () {
        // handle press
      },
      tooltip: 'Login',
      semanticLabel: 'Login button',
      shape: AppButtonShape.circle,
      elevation: 4,
    );
  }
}

/// Example 2: Large filled button with bold larger font.
class ExampleLargeFilledBold extends StatelessWidget {
  const ExampleLargeFilledBold({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppButton(
      text: 'Apply',
      icon: Icons.send,
      iconPosition: 'end',
      textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, letterSpacing: 0.4),
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
      width: 320,
      backgroundColor: Colors.redAccent,
      borderColor: null,
      onPressed: () {
        // perform apply
      },
      tooltip: 'Apply now',
      semanticLabel: 'Apply button',
      elevation: 6,
      shape: AppButtonShape.rounded,
    );
  }
}

/// Example 3: Outline button with image icon.
class ExampleOutlineWithImage extends StatelessWidget {
  const ExampleOutlineWithImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppButton(
      text: 'Upgrade to Premium',
      // sample network image (replace with AssetImage if you prefer)
      image: NetworkImage('https://via.placeholder.com/24'),
      iconPosition: 'start',
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
      backgroundColor: Colors.transparent,
      borderColor: Colors.deepOrange,
      elevation: 0,
      onPressed: () {
        // upgrade flow
      },
      tooltip: 'Upgrade',
      semanticLabel: 'Upgrade to premium',
      shape: AppButtonShape.rounded,
    );
  }
}

class ExampleLoadingAndDisabled extends StatelessWidget {
  const ExampleLoadingAndDisabled({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Loading button (shows spinner)
        AppButton(
          text: 'Saving...',
          isLoading: true,
          onPressed: () {},
          backgroundColor: Colors.blue,
          loadingIndicatorColor: Colors.white,
        ),
        const SizedBox(height: 12),
        // Disabled button (no onPressed or enabled=false)
        AppButton(
          text: 'Submit',
          onPressed: null,
          enabled: false,
          backgroundColor: Colors.green,
          disabledColor: Colors.green.shade200,
        ),
      ],
    );
  }
}
