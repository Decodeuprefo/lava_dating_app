import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lava_dating_app/Common/constant/color_constants.dart';
import '../constant/common_text_style.dart';
import 'glassmorphic_background_widget.dart';

class TextFormFieldWidget extends StatefulWidget {
  final Widget? label;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Widget? counterWidget;
  final TextEditingController controller;
  final String? hint;
  final String titleLabelName;
  final String? helperText;
  final FocusNode? focusNode;
  final bool obscureText;
  final String? Function(String?)? validator;
  final Function(String)? onFieldSubmitted;
  final VoidCallback? onTap;
  final TextInputAction? textInputAction;
  final TextInputType? textInputType;
  final Color? filledColor;
  final Color? hintColor;
  final Color? helperTextColor;
  final double? radius;
  final bool readOnly;
  final bool autofocus;
  final bool showCursor;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final AutovalidateMode? autoValidateMode;
  final InputBorder? errorBorder;
  final InputBorder? focusedErrorBorder;
  final GlobalKey<FormFieldState<String>>? fieldKey;

  const TextFormFieldWidget(
      {super.key,
      this.label,
      required this.controller,
      this.hint = "",
      this.titleLabelName = "",
      this.helperText,
      this.focusNode,
      this.suffixIcon,
      this.obscureText = false,
      this.validator,
      this.onFieldSubmitted,
      this.textInputAction,
      this.textInputType,
      this.hintColor,
      this.helperTextColor,
      this.radius,
      this.onTap,
      this.inputFormatters,
      this.readOnly = false,
      this.onChanged,
      this.maxLines = 1,
      this.minLines,
      this.maxLength,
      this.autoValidateMode,
      this.errorBorder,
      this.focusedErrorBorder,
      this.counterWidget,
      this.prefixIcon,
      this.filledColor,
      this.fieldKey,
      this.autofocus = false,
      this.showCursor = true});

  @override
  State<TextFormFieldWidget> createState() => _TextFormFieldWidgetState();
}

class _TextFormFieldWidgetState extends State<TextFormFieldWidget> {
  // Internal key when caller doesn't provide one (preserves state across rebuilds).
  final GlobalKey<FormFieldState<String>> _internalFieldKey = GlobalKey<FormFieldState<String>>();

  GlobalKey<FormFieldState<String>> get _effectiveFieldKey => widget.fieldKey ?? _internalFieldKey;

  // Keep last observed error so we can trigger rebuild when error changes (so the external
  // error/helper widget below the glass updates in sync with the FormField's validation).
  String? _lastObservedError;

  @override
  void didUpdateWidget(covariant TextFormFieldWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If the user provided a new external fieldKey, sync the internal last error so display remains correct.
    if (oldWidget.fieldKey != widget.fieldKey) {
      _lastObservedError = _effectiveFieldKey.currentState?.errorText;
    }
  }

  @override
  Widget build(BuildContext context) {
    final double borderRadius = widget.radius ?? 8.0;

    // Build helper widget but we will render it *below* the glass container
    final String? helperText = widget.helperText;
    final Widget helperWidget = (helperText != null && helperText.isNotEmpty)
        ? Text(
            helperText,
            style: TextStyle(
              color: widget.helperTextColor ?? const Color(0xFF9E9E9E),
              fontSize: 13,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
              letterSpacing: -0.3,
              height: 18 / 13,
            ),
          )
        : const SizedBox.shrink();

    final InputDecoration effectiveDecoration = InputDecoration(
      label: widget.label,
      hintText: widget.hint,
      // IMPORTANT: do not set helper or helperText here — we render helper/error below the glass.
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10).copyWith(right: 0),
      hintStyle: CommonTextStyle.regular14w400
          .copyWith(color: widget.hintColor ?? ColorConstants.greyLight),
      counter: widget.counterWidget,
      // Make TextFormField's built-in error text not visible (we render error below).
      // This prevents duplicate error messages: the internal errorText remains tracked by FormFieldState,
      // but it's visually hidden from the InputDecoration.
      errorStyle: const TextStyle(
        height: 0.01,
        fontSize: 0.01,
        color: Colors.transparent,
      ),
      suffixIcon: widget.suffixIcon,
      filled: false,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        borderSide: BorderSide.none,
      ),
      /*   errorBorder: widget.errorBorder ??
          OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: const BorderSide(
              color: Color(0xFFD32F2F), // ColorConstants.colorBorderDangerStrong
              width: 1,
            ),
          ),*/
      /* focusedErrorBorder: widget.focusedErrorBorder ??
          OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: const BorderSide(
              color: Color(0xFFD32F2F),
              width: 1,
            ),
          ),*/
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        borderSide: BorderSide.none,
      ),
      errorMaxLines: 3,
    );

    // Schedule a post-frame check to detect error changes and rebuild so the external error/helper
    // widget updates in sync with the FormField's internal validation state.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final String? currentError = _effectiveFieldKey.currentState?.errorText;
      if (_lastObservedError != currentError) {
        _lastObservedError = currentError;
        if (mounted) {
          setState(() {
            // rebuild to update the external error/helper widget
          });
        }
      }
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title label (if any)
        if (widget.titleLabelName.isNotEmpty)
          Text(widget.titleLabelName,
              style: const TextStyle(
                  fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 14)),
        // The glass card
        // Note: we only clip the visual glass effect; the helper/error will be drawn **after** this widget.
        ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.centerLeft,
            children: [
              // Glassmorphic background
              Positioned.fill(
                child: GlassmorphicBackgroundWidget(
                  borderRadius: borderRadius,
                  padding: EdgeInsets.zero,
                  blur: 8.0,
                  border: 0.8,
                  child: const SizedBox.shrink(),
                ),
              ),
              // Content layer (TextFormField and other interactive elements)
              Row(
                children: [
                  widget.prefixIcon?.marginOnly(left: 20) ?? const SizedBox(),
                  Expanded(
                    child: TextFormField(
                      key: _effectiveFieldKey,
                      controller: widget.controller,
                      focusNode: widget.focusNode,
                      obscureText: widget.obscureText,
                      validator: widget.validator,
                      autovalidateMode: widget.autoValidateMode,
                      onFieldSubmitted: widget.onFieldSubmitted,
                      autofocus: widget.autofocus,
                      textInputAction: widget.textInputAction ?? TextInputAction.next,
                      keyboardType: widget.textInputType ?? TextInputType.text,
                      cursorColor: Colors.white,
                      cursorHeight: 22,
                      showCursor: widget.showCursor,
                      cursorErrorColor: Colors.white,
                      onTap: widget.onTap,
                      onChanged: (val) {
                        if (widget.onChanged != null) widget.onChanged!(val);
                        if (mounted) setState(() {});
                      },
                      style: CommonTextStyle.regular14w400,
                      readOnly: widget.readOnly,
                      inputFormatters: widget.inputFormatters,
                      maxLines: widget.maxLines,
                      minLines: widget.minLines,
                      maxLength: widget.maxLength,
                      decoration: effectiveDecoration,
                    ),
                  ),
                  Container(
                    width: 8,
                    height: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(borderRadius),
                        bottomRight: Radius.circular(borderRadius),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Colors.white.withOpacity(0.00),
                          Colors.white.withOpacity(0.04),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              // Visual overlay (non-interactive)
              Positioned.fill(
                child: IgnorePointer(
                  ignoring: true,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(borderRadius),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withOpacity(0.035),
                          Colors.white.withOpacity(0.00),
                        ],
                        stops: const [0.0, 0.6],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        Builder(builder: (ctx) {
          final String? errorText = _effectiveFieldKey.currentState?.errorText;
          if (errorText != null && errorText.isNotEmpty) {
            return Text(
              errorText,
              style: const TextStyle(
                color: Color(0xFFD32F2F),
                fontSize: 13,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                letterSpacing: -0.3,
                height: 18 / 13,
              ),
            ).marginOnly(bottom: 6);
          } else if (helperText != null && helperText.isNotEmpty) {
            return helperWidget;
          } else {
            return const SizedBox.shrink();
          }
        }),
      ],
    );
  }
}
