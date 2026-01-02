import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lava_dating_app/Common/constant/custom_tools.dart';
import '../constant/color_constants.dart';
import '../constant/common_text_style.dart';
import '../widgets/glassmorphic_background_widget.dart';

class AgeRangePickerWidget extends StatefulWidget {
  final int minAge;
  final int maxAge;
  final Function(int) onMinAgeChanged;
  final Function(int) onMaxAgeChanged;
  final int minAgeLimit;
  final int maxAgeLimit;

  const AgeRangePickerWidget({
    Key? key,
    required this.minAge,
    required this.maxAge,
    required this.onMinAgeChanged,
    required this.onMaxAgeChanged,
    this.minAgeLimit = 18,
    this.maxAgeLimit = 100,
  }) : super(key: key);

  @override
  State<AgeRangePickerWidget> createState() => _AgeRangePickerWidgetState();
}

class _AgeRangePickerWidgetState extends State<AgeRangePickerWidget> {
  late FixedExtentScrollController _minController;
  late FixedExtentScrollController _maxController;
  late List<int> ageList;

  @override
  void initState() {
    super.initState();
    ageList = List.generate(
      widget.maxAgeLimit - widget.minAgeLimit + 1,
      (index) => widget.minAgeLimit + index,
    );
    _minController = FixedExtentScrollController(
      initialItem: ageList.indexOf(widget.minAge),
    );
    _maxController = FixedExtentScrollController(
      initialItem: ageList.indexOf(widget.maxAge),
    );
  }

  @override
  void didUpdateWidget(AgeRangePickerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.minAge != widget.minAge) {
      final index = ageList.indexOf(widget.minAge);
      if (index >= 0 && _minController.hasClients) {
        _minController.jumpToItem(index);
      }
    }
    if (oldWidget.maxAge != widget.maxAge) {
      final index = ageList.indexOf(widget.maxAge);
      if (index >= 0 && _maxController.hasClients) {
        _maxController.jumpToItem(index);
      }
    }
  }

  @override
  void dispose() {
    _minController.dispose();
    _maxController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GlassmorphicBackgroundWidget(
      borderRadius: 10,
      padding: const EdgeInsets.symmetric(horizontal: 40).copyWith(top: 20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Min",
                  style: CommonTextStyle.regular16w500,
                ),
                Text(
                  "Max",
                  style: CommonTextStyle.regular16w500,
                ),
              ],
            ),
            heightSpace(20),
            Image.asset(
              "assets/images/border_line.png",
              fit: BoxFit.fill,
            ),
            heightSpace(15),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 162,
                        width: 30,
                        child: Stack(
                          children: [
                            ListWheelScrollView.useDelegate(
                              itemExtent: 55,
                              physics: const FixedExtentScrollPhysics(),
                              controller: _minController,
                              onSelectedItemChanged: (index) {
                                final newMinAge = ageList[index];
                                if (newMinAge <= widget.maxAge) {
                                  widget.onMinAgeChanged(newMinAge);
                                }
                              },
                              childDelegate: ListWheelChildBuilderDelegate(
                                builder: (context, index) {
                                  if (index >= ageList.length) return const SizedBox();
                                  final age = ageList[index];
                                  final isSelected = age == widget.minAge;
                                  final isValid = age <= widget.maxAge;
                                  return Text(
                                    age.toString(),
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: isSelected
                                          ? ColorConstants.lightOrange
                                          : (Colors.white.withOpacity(0.6)),
                                      fontFamily: 'Poppins',
                                    ),
                                  );
                                },
                                childCount: ageList.length,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: 162,
                        width: 30,
                        child: Stack(
                          children: [
                            ListWheelScrollView.useDelegate(
                              itemExtent: 55,
                              physics: const FixedExtentScrollPhysics(),
                              controller: _maxController,
                              onSelectedItemChanged: (index) {
                                final newMaxAge = ageList[index];
                                if (newMaxAge >= widget.minAge) {
                                  widget.onMaxAgeChanged(newMaxAge);
                                }
                              },
                              childDelegate: ListWheelChildBuilderDelegate(
                                builder: (context, index) {
                                  if (index >= ageList.length) return const SizedBox();
                                  final age = ageList[index];
                                  final isSelected = age == widget.maxAge;
                                  final isValid = age >= widget.minAge;

                                  return Text(
                                    age.toString(),
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: isSelected
                                          ? ColorConstants.lightOrange
                                          : (Colors.white.withOpacity(0.6)),
                                      fontFamily: 'Poppins',
                                    ),
                                  );
                                },
                                childCount: ageList.length,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
