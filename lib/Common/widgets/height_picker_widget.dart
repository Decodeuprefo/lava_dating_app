import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lava_dating_app/Common/constant/custom_tools.dart';
import '../constant/color_constants.dart';
import '../constant/common_text_style.dart';

class HeightPickerWidget extends StatefulWidget {
  final int minHeight;
  final int maxHeight;
  final Function(int) onMinHeightChanged;
  final Function(int) onMaxHeightChanged;
  final int minHeightLimit;
  final int maxHeightLimit;
  final RxBool isFtCm;

  HeightPickerWidget({
    Key? key,
    required this.minHeight,
    required this.maxHeight,
    required this.onMinHeightChanged,
    required this.onMaxHeightChanged,
    this.minHeightLimit = 4,
    this.maxHeightLimit = 7,
    RxBool? isFtCm,
  })  : isFtCm = isFtCm ?? false.obs,
        super(key: key);

  @override
  State<HeightPickerWidget> createState() => _HeightPickerWidgetState();
}

class _HeightPickerWidgetState extends State<HeightPickerWidget> {
  late FixedExtentScrollController _feetController;
  late FixedExtentScrollController _inchesController;
  late FixedExtentScrollController _centimeterController;
  late List<int> feetList;
  late List<int> inchesList;
  late List<int> centimeterList;

  @override
  void initState() {
    super.initState();
    // Feet list: 4 to 7 (or minHeightLimit to maxHeightLimit)
    feetList = List.generate(
      widget.maxHeightLimit - widget.minHeightLimit + 1,
      (index) => widget.minHeightLimit + index,
    );
    inchesList = List.generate(12, (index) => index);
    centimeterList = List.generate(71, (index) => 150 + index);

    // Initialize controllers based on current mode
    if (widget.isFtCm.value) {
      // Feet/Inches mode
      final feetIndex = feetList.indexOf(widget.minHeight);
      final inchesIndex = inchesList.indexOf(widget.maxHeight);
      _feetController = FixedExtentScrollController(
        initialItem: feetIndex >= 0 ? feetIndex : 0,
      );
      _inchesController = FixedExtentScrollController(
        initialItem: inchesIndex >= 0 ? inchesIndex : 0,
      );
      _centimeterController = FixedExtentScrollController(initialItem: 0);
    } else {
      // Centimeter mode
      int cmIndex = centimeterList.indexOf(widget.minHeight);
      // If value not found (e.g., feet value like 5), always default to 160
      if (cmIndex < 0 || widget.minHeight < 150 || widget.minHeight > 220) {
        cmIndex = centimeterList.indexOf(160);
        if (cmIndex < 0) cmIndex = 10; // 160 is at index 10 (160 - 150)
      }
      _centimeterController = FixedExtentScrollController(
        initialItem: cmIndex >= 0 ? cmIndex : 10,
      );
      _feetController = FixedExtentScrollController(initialItem: 0);
      _inchesController = FixedExtentScrollController(initialItem: 0);
    }
  }

  @override
  void didUpdateWidget(HeightPickerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Handle mode change
    if (oldWidget.isFtCm.value != widget.isFtCm.value) {
      if (widget.isFtCm.value) {
        // Switched to Feet/Inches mode
        final feetIndex = feetList.indexOf(widget.minHeight);
        final inchesIndex = inchesList.indexOf(widget.maxHeight);
        if (feetIndex >= 0 && _feetController.hasClients) {
          _feetController.jumpToItem(feetIndex);
        }
        if (inchesIndex >= 0 && _inchesController.hasClients) {
          _inchesController.jumpToItem(inchesIndex);
        }
      } else {
        // Switched to Centimeter mode
        // Always default to 160 when switching to centimeter mode
        int cmIndex = centimeterList.indexOf(160);
        if (cmIndex < 0) cmIndex = 10; // 160 is at index 10 (160 - 150)
        
        // Use post-frame callback to ensure controller is ready after widget rebuild
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_centimeterController.hasClients && cmIndex >= 0 && cmIndex < centimeterList.length) {
            _centimeterController.jumpToItem(cmIndex);
          }
        });
      }
    }

    // Handle value changes
    if (widget.isFtCm.value) {
      // Feet/Inches mode
      if (oldWidget.minHeight != widget.minHeight) {
        final index = feetList.indexOf(widget.minHeight);
        if (index >= 0 && _feetController.hasClients) {
          _feetController.jumpToItem(index);
        }
      }
      if (oldWidget.maxHeight != widget.maxHeight) {
        final index = inchesList.indexOf(widget.maxHeight);
        if (index >= 0 && _inchesController.hasClients) {
          _inchesController.jumpToItem(index);
        }
      }
    } else {
      // Centimeter mode
      if (oldWidget.minHeight != widget.minHeight || oldWidget.isFtCm.value != widget.isFtCm.value) {
        int index = centimeterList.indexOf(widget.minHeight);
        // If value not found or mode just changed, default to 160
        if (index < 0 || oldWidget.isFtCm.value != widget.isFtCm.value) {
          index = centimeterList.indexOf(160);
          if (index < 0) index = 10; // 160 is at index 10
        }
        // Use post-frame callback to ensure controller is ready
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_centimeterController.hasClients && index >= 0 && index < centimeterList.length) {
            _centimeterController.jumpToItem(index);
          }
        });
      }
    }
  }

  @override
  void dispose() {
    _feetController.dispose();
    _inchesController.dispose();
    _centimeterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color(0x752A1F3A),
            border: Border.all(
              color: const Color(0x66A898B8),
              width: 1.0,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 40).copyWith(top: 20),
          child: Obx(() {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: widget.isFtCm.value
                      ? MainAxisAlignment.spaceBetween
                      : MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.isFtCm.value ? "Feet" : "Centimeter",
                      style: CommonTextStyle.regular16w500,
                    ),
                    widget.isFtCm.value
                        ? const Text(
                            "Inches",
                            style: CommonTextStyle.regular16w500,
                          )
                        : const SizedBox(),
                  ],
                ),
                heightSpace(20),
                Image.asset(
                  "assets/images/border_line.png",
                  fit: BoxFit.fill,
                ),
                heightSpace(17),
                widget.isFtCm.value
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  height: 158,
                                  width: 30,
                                  child: Stack(
                                    children: [
                                      ListWheelScrollView.useDelegate(
                                        itemExtent: 55,
                                        physics: const FixedExtentScrollPhysics(),
                                        controller: _feetController,
                                        onSelectedItemChanged: (index) {
                                          if (index >= 0 && index < feetList.length) {
                                            final newFeet = feetList[index];
                                            widget.onMinHeightChanged(newFeet);
                                          }
                                        },
                                        childDelegate: ListWheelChildBuilderDelegate(
                                          builder: (context, index) {
                                            if (index >= feetList.length) return const SizedBox();
                                            final feet = feetList[index];
                                            final isSelected = feet == widget.minHeight;
                                            return Text(
                                              feet.toString(),
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
                                          childCount: feetList.length,
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
                                  height: 158,
                                  width: 40,
                                  child: Stack(
                                    children: [
                                      ListWheelScrollView.useDelegate(
                                        itemExtent: 55,
                                        physics: const FixedExtentScrollPhysics(),
                                        controller: _inchesController,
                                        onSelectedItemChanged: (index) {
                                          if (index >= 0 && index < inchesList.length) {
                                            final newInches = inchesList[index];
                                            widget.onMaxHeightChanged(newInches);
                                          }
                                        },
                                        childDelegate: ListWheelChildBuilderDelegate(
                                          builder: (context, index) {
                                            if (index >= inchesList.length) return const SizedBox();
                                            final inches = inchesList[index];
                                            final isSelected = inches == widget.maxHeight;
                                            return Text(
                                              inches.toString(),
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
                                          childCount: inchesList.length,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 158,
                            width: 80,
                            child: Stack(
                              children: [
                                ListWheelScrollView.useDelegate(
                                  itemExtent: 55,
                                  physics: const FixedExtentScrollPhysics(),
                                  controller: _centimeterController,
                                  onSelectedItemChanged: (index) {
                                    if (index >= 0 && index < centimeterList.length) {
                                      final newCm = centimeterList[index];
                                      widget.onMinHeightChanged(newCm);
                                    }
                                  },
                                  childDelegate: ListWheelChildBuilderDelegate(
                                    builder: (context, index) {
                                      if (index >= centimeterList.length) return const SizedBox();
                                      final cm = centimeterList[index];
                                      final isSelected = cm == widget.minHeight;
                                      return Text(
                                        cm.toString(),
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
                                    childCount: centimeterList.length,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
