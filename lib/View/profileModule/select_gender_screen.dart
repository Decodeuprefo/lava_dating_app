import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lava_dating_app/Common/widgets/custom_background.dart';
import 'package:lava_dating_app/View/profileModule/intro_video_screen.dart';
import '../../Common/constant/common_text_style.dart';
import '../../Common/constant/custom_tools.dart';
import '../../Common/widgets/custom_button.dart';
import 'add_profile_photos_screen.dart';

class SelectGenderScreen extends StatefulWidget {
  const SelectGenderScreen({super.key});

  @override
  State<SelectGenderScreen> createState() => _SelectGenderScreenState();
}

enum GenderOption { none, male, female }

class _SelectGenderScreenState extends State<SelectGenderScreen> {
  GenderOption selected = GenderOption.none;

  void _onSelect(GenderOption option) {
    setState(() {
      selected = option;
    });
  }

  @override
  Widget build(BuildContext context) {
    const double tileRadius = 14.0;
    return Scaffold(
      body: BackgroundContainer(
          child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                heightSpace(130),
                const Text(
                  'What’s Your Gender?',
                  style: CommonTextStyle.semiBold30w600,
                ),
                const Text(
                  "Choose the gender that best represents you. You can update this later in settings.",
                  style: CommonTextStyle.regular14w400,
                ),
                heightSpace(50),
                GenderTile(
                  label: 'I’m a man',
                  isSelected: selected == GenderOption.male,
                  borderRadius: tileRadius,
                  onTap: () => _onSelect(GenderOption.male),
                ),
                heightSpace(10),
                GenderTile(
                  label: 'I’m a woman',
                  isSelected: selected == GenderOption.female,
                  borderRadius: tileRadius,
                  onTap: () => _onSelect(GenderOption.female),
                ),
                const SizedBox(height: 24),
              ],
            ).marginSymmetric(horizontal: 20),
          ),
          AppButton(
            text: "Continue",
            textStyle: CommonTextStyle.regular16w500,
            onPressed: () {
              setState(() {});
              Get.to(() => const AddProfilePhotosScreen());
            },
          ).marginSymmetric(horizontal: 20, vertical: 20),
        ],
      )),
    );
  }
}

class GenderTile extends StatelessWidget {
  final String label;
  final bool isSelected;
  final double borderRadius;
  final VoidCallback onTap;

  const GenderTile({
    super.key,
    required this.label,
    required this.isSelected,
    this.borderRadius = 10.0,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // subtle scale when selected
    final double scale = isSelected ? 1.02 : 1.0;
    final double elevation = isSelected ? 14 : 6;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedScale(
        scale: scale,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
                child: Container(
                  color: Colors.transparent,
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(borderRadius),
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(isSelected ? 0.14 : 0.10),
                      Colors.white.withOpacity(isSelected ? 0.09 : 0.06),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(
                    color: Colors.white.withOpacity(isSelected ? 0.30 : 0.22),
                    width: isSelected ? 1.2 : 1.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(isSelected ? 0.12 : 0.06),
                      blurRadius: elevation,
                      offset: const Offset(0, 4),
                    ),
                    BoxShadow(
                      color: Colors.white.withOpacity(0.03),
                      blurRadius: 2,
                      offset: const Offset(-2, -2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          label,
                          style: CommonTextStyle.regular14w400,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

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

              // selected tick indicator (top-right)
              if (isSelected)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white.withOpacity(0.20)),
                    ),
                    child: const Icon(
                      Icons.check,
                      size: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
