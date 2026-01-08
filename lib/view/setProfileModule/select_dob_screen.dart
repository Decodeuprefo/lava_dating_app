import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lava_dating_app/Controller/setProfileControllers/select_dob_screen_controller.dart';
import '../../Common/constant/common_text_style.dart';
import '../../Common/constant/custom_tools.dart';
import '../../Common/widgets/custom_background.dart';
import '../../Common/widgets/custom_button.dart';
import '../../Common/widgets/text_form_field_widget.dart';
import '../../Common/widgets/shimmers/select_dob_screen_shimmer_widget.dart';
import 'interests_and_hobbies.dart';

class SelectDobScreen extends StatefulWidget {
  final bool? fromEdit;

  const SelectDobScreen({super.key, this.fromEdit});

  @override
  State<SelectDobScreen> createState() => _SelectDobScreenState();
}

class _SelectDobScreenState extends State<SelectDobScreen> {
  late SelectDobScreenController controller;
  final Rx<DateTime> _displayedMonth = DateTime(1998, 3, 1).obs;
  final Rx<DateTime> _selectedDate = DateTime(1998, 3, 14).obs;
  final Color _accentOrange = const Color(0xFFFF4A00);

  @override
  void initState() {
    super.initState();
    if (Get.isRegistered<SelectDobScreenController>()) {
      try {
        Get.delete<SelectDobScreenController>();
      } catch (e) {}
    }
    controller = Get.put(SelectDobScreenController(), permanent: false);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SelectDobScreenController>(
      builder: (controller) {
        if (controller.isLoading) {
          return const Scaffold(
            body: BackgroundContainer(
              child: SafeArea(
                child: SelectDobScreenShimmerWidget(),
              ),
            ),
          );
        }
        return Scaffold(
          body: BackgroundContainer(
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          heightSpace(13),
                          // Hide back button if this is the root/first screen
                          Builder(
                            builder: (context) {
                              final route = ModalRoute.of(context);
                              final isFirstRoute = route?.isFirst ?? false;
                              final canPop = Navigator.of(context).canPop();

                              // Show back button only if:
                              // 1. This is NOT the first route in navigation stack
                              // 2. AND Navigator can pop (has previous route)
                              if (!isFirstRoute && canPop) {
                                return InkWell(
                                  onTap: Get.back,
                                  child: SvgPicture.asset(
                                    "assets/icons/back_arrow.svg",
                                    height: 30,
                                    width: 30,
                                    fit: BoxFit.fill,
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                          heightSpace(90),
                          const CommonTextWidget(
                            text: "When's Your Birthday?",
                            textType: TextType.head,
                          ),
                          const CommonTextWidget(
                            text:
                                'Your age will appear on your profile." You must be at least 18 years old to use Lava.',
                            textType: TextType.des,
                          ),
                          heightSpace(20),
                          TextFormFieldWidget(
                            controller: controller.dobController,
                            hint: "Select Date of Birth",
                            suffixIcon: InkWell(
                              onTap: () => _showDobBottomSheet(context),
                              child: Padding(
                                padding: const EdgeInsets.all(9.0),
                                child: SvgPicture.asset(
                                  "assets/icons/calendar_icon.svg",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            readOnly: true,
                            showCursor: false,
                            onTap: () => _showDobBottomSheet(context),
                          ),
                        ],
                      ).marginSymmetric(horizontal: 20),
                    ),
                  ),
                  AppButton(
                    text: widget.fromEdit == true ? "Save" : "Continue",
                    textStyle: CommonTextStyle.regular16w500,
                    onPressed: controller.isLoading
                        ? null
                        : () {
                            if (controller.selectedDate == null) {
                              showSnackBar(context, 'Please select your date of birth.',
                                  isErrorMessageDisplay: true);
                              return;
                            }
                            controller.updateDateOfBirth(context, widget.fromEdit);
                          },
                  ).marginSymmetric(horizontal: 20, vertical: 20)
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showDobBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return DraggableScrollableSheet(
          expand: false,
          maxChildSize: 0.95,
          initialChildSize: 0.75,
          minChildSize: 0.4,
          builder: (_, scrollController) {
            return Builder(
              builder: (bottomSheetContext) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.9),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(18),
                      topRight: Radius.circular(18),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // drag indicator
                      Center(
                        child: Container(
                          width: 60,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        "Date of Birth",
                        style: CommonTextStyle.regular20w600,
                      ),
                      heightSpace(30),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Obx(
                                  () => Row(
                                    children: [
                                      Text(
                                        _monthLabel(_displayedMonth.value),
                                        style: CommonTextStyle.regular20w600,
                                      ),
                                      const Text(
                                        ", ",
                                        style: CommonTextStyle.regular20w600,
                                      ),
                                      GestureDetector(
                                        onTap: () => _showYearPicker(bottomSheetContext),
                                        child: Text(
                                          _displayedMonth.value.year.toString(),
                                          style: CommonTextStyle.regular20w600.copyWith(
                                            decoration: TextDecoration.underline,
                                            decorationColor: Colors.white.withOpacity(0.5),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    _circleNavButton("left", () {
                                      final current = _displayedMonth.value;
                                      _displayedMonth.value = DateTime(
                                        current.year,
                                        current.month - 1,
                                        1,
                                      );
                                    }),
                                    widthSpace(20),
                                    _circleNavButton("right", () {
                                      final current = _displayedMonth.value;
                                      _displayedMonth.value = DateTime(
                                        current.year,
                                        current.month + 1,
                                        1,
                                      );
                                    }),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      heightSpace(80),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"]
                            .map((d) => Expanded(
                                  child: Center(
                                    child: Text(
                                      d,
                                      style: CommonTextStyle.regular18w600,
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                      const SizedBox(height: 8),

                      Expanded(
                        child: SingleChildScrollView(
                          controller: scrollController,
                          child: Obx(() => _buildDaysGrid(_displayedMonth.value)),
                        ),
                      ),

                      const SizedBox(height: 16),

                      AppButton(
                        text: "Select",
                        textStyle: CommonTextStyle.regular16w500,
                        onPressed: () {
                          final sel = _selectedDate.value;
                          // Access the state's controller
                          final dobController = Get.find<SelectDobScreenController>();
                          dobController.setSelectedDate(sel);
                          Navigator.of(context).pop();
                        },
                        // style to match screenshot: orange background and large rounded corners
                      ).marginSymmetric(horizontal: 0, vertical: 8),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _circleNavButton(String icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: icon == "right"
          ? Image.asset(
              "assets/icons/right_arrow_button.png",
              height: 30,
              width: 30,
            )
          : Image.asset(
              "assets/icons/left_arrow_button.png",
              height: 30,
              width: 30,
            ),
    );
  }

  Widget _buildDaysGrid(DateTime displayedMonth) {
    final year = displayedMonth.year;
    final month = displayedMonth.month;
    final firstOfMonth = DateTime(year, month, 1);
    final leadingEmpty = (firstOfMonth.weekday % 7);
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final totalCells = leadingEmpty + daysInMonth;
    final cellsToAdd = (totalCells % 7 == 0) ? totalCells : (totalCells + (7 - (totalCells % 7)));

    final List<Widget> allCells = [];

    for (int i = 0; i < leadingEmpty; i++) {
      allCells.add(const SizedBox());
    }

    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(year, month, day);
      final bool isSelected = _selectedDate.value.year == date.year &&
          _selectedDate.value.month == date.month &&
          _selectedDate.value.day == date.day;

      allCells.add(
        GestureDetector(
          onTap: () {
            _selectedDate.value = date;
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: Center(
              child: Container(
                width: 44,
                height: 44,
                decoration: isSelected
                    ? BoxDecoration(
                        color: _accentOrange,
                        shape: BoxShape.circle,
                      )
                    : null,
                child: Center(
                  child: Text(
                    day.toString(),
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    final trailing = cellsToAdd - totalCells;
    for (int i = 0; i < trailing; i++) {
      allCells.add(const SizedBox());
    }

    final rows = <Widget>[];
    for (int r = 0; r < allCells.length; r += 7) {
      final rowCells = allCells.sublist(r, r + 7);
      rows.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: rowCells
            .map((w) => Expanded(
                  child: Center(child: w),
                ))
            .toList(),
      ));
    }

    return Column(
      children: rows,
    );
  }

  String _monthLabel(DateTime dt) {
    final monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return monthNames[dt.month - 1];
  }

  void _showYearPicker(BuildContext context) {
    final currentYear = _displayedMonth.value.year;
    final currentDate = DateTime.now();
    final minYear = currentDate.year - 100; // 100 years back
    final maxYear = currentDate.year - 18; // At least 18 years old

    final yearList = List.generate(
      maxYear - minYear + 1,
      (index) => minYear + index,
    );

    final initialIndex = yearList.indexOf(currentYear);
    late FixedExtentScrollController yearController;
    yearController = FixedExtentScrollController(
        initialItem: initialIndex >= 0 ? initialIndex : yearList.length - 1);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          height: 300,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.95),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(18),
              topRight: Radius.circular(18),
            ),
          ),
          child: Column(
            children: [
              // drag indicator
              Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  width: 60,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const Text(
                "Select Year",
                style: CommonTextStyle.regular20w600,
              ),
              heightSpace(20),
              Expanded(
                child: ListWheelScrollView.useDelegate(
                  itemExtent: 50,
                  physics: const FixedExtentScrollPhysics(),
                  controller: yearController,
                  onSelectedItemChanged: (index) {
                    if (index >= 0 && index < yearList.length) {
                      final selectedYear = yearList[index];
                      final current = _displayedMonth.value;
                      _displayedMonth.value = DateTime(
                        selectedYear,
                        current.month,
                        1,
                      );
                    }
                  },
                  childDelegate: ListWheelChildBuilderDelegate(
                    builder: (context, index) {
                      if (index >= yearList.length) return const SizedBox();
                      final year = yearList[index];
                      final isSelected = year == currentYear;
                      return Center(
                        child: Text(
                          year.toString(),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? _accentOrange : Colors.white.withOpacity(0.7),
                            fontFamily: 'Poppins',
                          ),
                        ),
                      );
                    },
                    childCount: yearList.length,
                  ),
                ),
              ),
              heightSpace(20),
            ],
          ),
        );
      },
    ).then((_) {
      yearController.dispose();
    });
  }

  @override
  void dispose() {
    try {
      if (Get.isRegistered<SelectDobScreenController>()) {
        Get.delete<SelectDobScreenController>();
      }
    } catch (e) {}
    super.dispose();
  }
}
