import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lava_dating_app/Common/constant/common_text_style.dart';
import 'package:lava_dating_app/Common/constant/custom_tools.dart';
import 'package:lava_dating_app/Common/constant/color_constants.dart';
import 'package:lava_dating_app/Common/widgets/custom_background.dart';
import 'package:lava_dating_app/Common/widgets/glass_background_widget.dart';
import 'package:lava_dating_app/Controller/free_game_friday_controller.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FreeGameFridayScreen extends StatelessWidget {
  const FreeGameFridayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FreeGameFridayController());

    return Scaffold(
      body: BackgroundContainer(
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              heightSpace(10),
              _buildPromotionalBanner(),
              heightSpace(20),
              Expanded(
                child: _buildGameArticlesList(controller),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            children: [
              InkWell(
                onTap: () => Get.back(),
                child: SvgPicture.asset(
                  "assets/icons/back_arrow.svg",
                  height: 30,
                  width: 30,
                  fit: BoxFit.fill,
                ),
              ),
            ],
          ),
          _buildTitle(),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Center(
      child: Text(
        "Free Game Friday's",
        style: CommonTextStyle.regular30w600.copyWith(
          color: ColorConstants.lightOrange,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildPromotionalBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 13),
        decoration: BoxDecoration(
          color: ColorConstants.lightOrange,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Image.asset(
              "assets/icons/game_white_icon.png",
              height: 30,
              width: 30,
            ),
            widthSpace(25),
            Expanded(
              child: Text(
                "Discover free games every Friday — play, share, and bond!",
                style: CommonTextStyle.regular16w500.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameArticlesList(FreeGameFridayController controller) {
    return Obx(
      () => ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: controller.gameArticles.length,
        itemBuilder: (context, index) {
          final article = controller.gameArticles[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _buildGameArticleCard(article),
          );
        },
      ),
    );
  }

  Widget _buildGameArticleCard(Map<String, dynamic> article) {
    return GlassBackgroundWidget(
      borderRadius: 10,
      padding: const EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildArticleImage(article['image'] as String),
          widthSpace(10),
          Expanded(
            child: _buildArticleContent(article),
          ),
        ],
      ),
    );
  }

  Widget _buildArticleImage(String imagePath) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      child: Image.asset(
        imagePath,
        width: 100,
        height: 100,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 100,
            height: 100,
            color: Colors.grey.withOpacity(0.3),
            child: const Icon(
              Icons.image,
              color: Colors.white54,
              size: 40,
            ),
          );
        },
      ),
    );
  }

  Widget _buildArticleContent(Map<String, dynamic> article) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          article['title'] as String,
          style: CommonTextStyle.regular14w500,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        heightSpace(12),
        Image.asset(
          "assets/images/border_line.png",
          height: 2,
          fit: BoxFit.fill,
        ),
        heightSpace(10),
        Text("Posted by: ${article['author'] as String}", style: CommonTextStyle.regular10w500),
        heightSpace(5),
        _buildMetadataRow(article),
      ],
    );
  }

  Widget _buildMetadataRow(Map<String, dynamic> article) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildMetadataItem(
          imagePath: "assets/icons/calendar_icon.svg",
          text: article['date'] as String,
        ),
        const Spacer(),
        _buildMetadataItem(
          imagePath: "assets/icons/dash_message.png",
          text: "${article['comments']}",
        ),
        widthSpace(15),
        _buildMetadataItem(
          imagePath: "assets/icons/dash_heart.png",
          text: "${article['likes']}",
        ),
      ],
    );
  }

  Widget _buildMetadataItem({required String imagePath, required String text}) {
    final bool isSvg = imagePath.endsWith('.svg');

    return Row(
      children: [
        isSvg
            ? SvgPicture.asset(
                imagePath,
                width: 15,
                height: 15,
                colorFilter: const ColorFilter.mode(
                  Color(0xFFD3D3D3),
                  BlendMode.srcIn,
                ),
              )
            : ColorFiltered(
                colorFilter: const ColorFilter.mode(
                  Color(0xFFD3D3D3),
                  BlendMode.srcIn,
                ),
                child: Image.asset(
                  imagePath,
                  width: 15,
                  height: 15,
                ),
              ),
        widthSpace(10),
        Text(text, style: CommonTextStyle.regular10w500),
      ],
    );
  }
}
