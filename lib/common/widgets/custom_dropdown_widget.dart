import 'dart:ui';
import 'package:flutter/material.dart';
import '../constant/color_constants.dart';
import '../constant/common_text_style.dart';

class CustomDropdownWidget extends StatelessWidget {
  final String? selectedValue;
  final List<String> items;
  final String hint;
  final Function(String?) onChanged;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;

  const CustomDropdownWidget({
    Key? key,
    this.selectedValue,
    required this.items,
    required this.hint,
    required this.onChanged,
    this.borderRadius,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double radius = borderRadius ?? 10.0;
    final EdgeInsetsGeometry containerPadding =
        padding ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 2);

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Stack(
          children: [
            Container(
              padding: containerPadding,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(radius),
                color: const Color(0x752A1F3A),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedValue,
                        hint: Text(
                          hint,
                          style: CommonTextStyle.regular14w400,
                        ),
                        isExpanded: true,
                        icon: Image.asset(
                          "assets/icons/drop_down_arrow.png",
                          fit: BoxFit.fill,
                          height: 30,
                          width: 30,
                        ),
                        style: CommonTextStyle.regular14w400,
                        dropdownColor: ColorConstants.bottomSheetBackgroundChange,
                        items: items.map((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item,
                              style: CommonTextStyle.regular14w400,
                            ),
                          );
                        }).toList(),
                        onChanged: onChanged,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned.fill(
              child: IgnorePointer(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(radius),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(radius),
                      border: Border.all(
                        color: const Color(0x66A898B8),
                        width: 1.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
