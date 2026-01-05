import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lava_dating_app/Common/constant/common_text_style.dart';
import 'package:lava_dating_app/Common/constant/custom_tools.dart';
import 'package:lava_dating_app/Common/constant/color_constants.dart';
import 'package:lava_dating_app/Common/widgets/custom_button.dart';
import 'package:lava_dating_app/Common/widgets/custom_background.dart';
import 'package:lava_dating_app/View/homeModule/dashboard_screen.dart';

class PaymentSuccessScreen extends StatelessWidget {
  const PaymentSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundContainer(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                heightSpace(100),
                _buildDoneImage(),
                heightSpace(110),
                _buildFirstText(),
                heightSpace(30),
                _buildSecondText(),
                const Spacer(),
                _buildStartMatchingButton(),
                heightSpace(20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDoneImage() {
    return SizedBox(
        width: 200,
        height: 200,
        child: Image.asset(
          "assets/images/pay_done.png",
        ));
  }

  Widget _buildFirstText() {
    return const Text(
      "You've successfully\nupgraded to Lava\nLava Premium (1 Month).",
      style: CommonTextStyle.regular22w400,
      textAlign: TextAlign.center,
    );
  }

  Widget _buildSecondText() {
    return Text(
      "Enjoy unlimited access and exclusive features!",
      style: CommonTextStyle.regular24w700.copyWith(
        color: Colors.white,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildStartMatchingButton() {
    return AppButton(
      text: 'Start Matching!',
      onPressed: () {
        Get.off(() => const DashboardScreen());
      },
      backgroundColor: ColorConstants.lightOrange,
      textStyle: CommonTextStyle.regular16w500.copyWith(
        color: Colors.white,
      ),
      borderRadius: 10,
      width: double.infinity,
      elevation: 0,
      padding: const EdgeInsets.symmetric(vertical: 16),
    );
  }
}

class CheckmarkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(size.width * 0.25, size.height * 0.5);
    path.lineTo(size.width * 0.45, size.height * 0.7);
    path.lineTo(size.width * 0.75, size.height * 0.3);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
