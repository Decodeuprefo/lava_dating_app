import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lava_dating_app/Common/constant/common_text_style.dart';
import 'package:lava_dating_app/Common/constant/custom_tools.dart';
import 'package:lava_dating_app/Common/constant/color_constants.dart';
import 'package:lava_dating_app/Common/services/storage_service.dart';
import 'package:lava_dating_app/Common/widgets/custom_button.dart';
import 'package:lava_dating_app/Common/widgets/custom_background.dart';
import 'package:lava_dating_app/View/authModule/login_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<WelcomePageData> _pages = [
    WelcomePageData(
      title: "Many Islands,\nOne Village",
      imagePath: "assets/images/welcome1.png",
      imageWidth: 300,
      imageHeight: 300,
      description:
          "Lava is where we come together to honor 🤲🏽 the strength and beauty of every Pasifika island 🏝️. Meet new people, uplift one another, and build community with Pasifika Islanders from every shore 🤙🏾.",
      buttonText: "Next",
    ),
    WelcomePageData(
      title: "Navigating\nLove",
      imagePath: "assets/images/welcome2.png",
      imageWidth: 300,
      imageHeight: 300,
      description:
          "Across oceans and beneath the same stars ✨, our wayfinder hearts discover one another. Catch the wave 🌊 and ride 🏄🏽‍♀️ our sea's currents to your perfect connection ⚡️.",
      buttonText: "Next",
    ),
    WelcomePageData(
      title: "FAITH-fully Yours",
      imagePath: "assets/images/welcome3.png",
      imageWidth: 235,
      imageHeight: 352,
      description:
          "🙏🏽 Faithful to God first so we can be faithful to the one we're blessed 😇 to love.",
      buttonText: "Next",
    ),
    WelcomePageData(
      title: "Upgrade",
      imagePath: "assets/images/welcome4.png",
      imageWidth: 300,
      imageHeight: 300,
      description:
          "Lava UP\nUpgrade to explore beyond the horizon. Unlock premium features that make it easier for new matches to find, see, and connect with you 🥰",
      buttonText: "Get Started",
      isRichText: true,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _handleGetStarted();
    }
  }

  void _handleGetStarted() async {
    await StorageService.setWelcomeCompleted();
    Get.off(
      () => const LoginScreen(),
      transition: Transition.cupertino,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundContainer(
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    return _buildPage(_pages[index]);
                  },
                ),
              ),
              heightSpace(30),
              _buildButton(),
              heightSpace(20),
              _buildStepper(),
              heightSpace(20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPage(WelcomePageData pageData) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          heightSpace(100),
          _buildTitle(pageData.title),
          heightSpace(33),
          _buildCenterImage(
            pageData.imagePath,
            pageData.imageWidth,
            pageData.imageHeight,
          ),
          heightSpace(35),
          Expanded(
            child: _buildDescriptionText(
              pageData.description,
              pageData.isRichText ?? false,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle(String title) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 0.3),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      child: Text(
        title,
        key: ValueKey<String>(title),
        style: CommonTextStyle.regular30w600.copyWith(
          color: ColorConstants.lightOrange,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildCenterImage(String imagePath, double width, double height) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(
              begin: 0.8,
              end: 1.0,
            ).animate(animation),
            child: child,
          ),
        );
      },
      child: SizedBox(
        key: ValueKey<String>(imagePath),
        width: width,
        height: height,
        child: Image.asset(
          imagePath,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.image,
                size: 100,
                color: Colors.white54,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDescriptionText(String description, bool isRichText) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 0.2),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      child: Center(
        key: ValueKey<String>(description),
        child: isRichText
            ? RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Lava UP",
                      style: CommonTextStyle.regular22w600.copyWith(
                        color: ColorConstants.lightOrange,
                      ),
                    ),
                    TextSpan(
                      text:
                          "\nUpgrade to explore beyond the horizon. Unlock premium features that make it easier for new matches to find, see, and connect with you 🥰 ",
                      style: CommonTextStyle.regular14w400.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              )
            : Text(
                description,
                style: CommonTextStyle.regular14w400,
              ),
      ),
    );
  }

  Widget _buildButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: AppButton(
        text: _pages[_currentPage].buttonText,
        onPressed: _nextPage,
        backgroundColor: ColorConstants.lightOrange,
        textStyle: CommonTextStyle.regular16w500.copyWith(
          color: Colors.white,
        ),
        borderRadius: 10,
        width: double.infinity,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 10),
      ),
    );
  }

  Widget _buildStepper() {
    const int totalSteps = 4;
    const double totalWidth = 100.0;
    const double height = 5.0;
    const double gap = 2.0;

    const double totalGapWidth = (totalSteps - 1) * gap;
    const double availableWidth = totalWidth - totalGapWidth;
    const double singleStepWidth = availableWidth / totalSteps;

    List<Widget> children = [];

    if (_currentPage > 0) {
      int count = _currentPage;
      double width = (count * singleStepWidth) + ((count - 1) * gap);

      children.add(_buildSegment(
        color: const Color.fromRGBO(217, 217, 217, 1),
        height: height,
        width: width,
      ));
      children.add(const SizedBox(width: gap));
    }

    children.add(_buildSegment(
      color: ColorConstants.lightOrange,
      height: height,
      width: singleStepWidth,
    ));

    if (_currentPage < totalSteps - 1) {
      children.add(const SizedBox(width: gap));

      int count = totalSteps - 1 - _currentPage;
      double width = (count * singleStepWidth) + ((count - 1) * gap);

      children.add(_buildSegment(
        color: const Color.fromRGBO(217, 217, 217, 1),
        height: height,
        width: width,
      ));
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      child: SizedBox(
        key: ValueKey<int>(_currentPage),
        width: totalWidth,
        height: height,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: children,
        ),
      ),
    );
  }

  Widget _buildSegment({
    required Color color,
    required double height,
    required double width,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(height),
      ),
    );
  }
}

class WelcomePageData {
  final String title;
  final String imagePath;
  final double imageWidth;
  final double imageHeight;
  final String description;
  final String buttonText;
  final bool? isRichText;

  WelcomePageData({
    required this.title,
    required this.imagePath,
    required this.imageWidth,
    required this.imageHeight,
    required this.description,
    required this.buttonText,
    this.isRichText,
  });
}

