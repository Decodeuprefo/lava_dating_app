import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lava_dating_app/Common/constant/common_text_style.dart';
import 'package:lava_dating_app/Common/constant/custom_tools.dart';
import 'package:lava_dating_app/Common/constant/color_constants.dart';
import 'package:lava_dating_app/Common/widgets/custom_background.dart';
import 'package:lava_dating_app/Common/widgets/glass_background_widget.dart';
import 'package:lava_dating_app/Controller/notification_list_controller.dart';

class NotificationListScreen extends StatelessWidget {
  const NotificationListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NotificationListController());

    return Scaffold(
      body: BackgroundContainer(
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              heightSpace(30),
              Expanded(
                child: Obx(() {
                  controller.notifications.length;
                  return _buildNotificationList(controller);
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20).copyWith(top: 20),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: SvgPicture.asset(
              "assets/icons/back_arrow.svg",
              height: 30,
              width: 30,
              fit: BoxFit.fill,
            ),
          ),
          const Spacer(),
          Text(
            'Notifications',
            style: CommonTextStyle.regular18w500.copyWith(
              color: ColorConstants.lightOrange,
            ),
          ),
          const Spacer(),
          const SizedBox(width: 30),
        ],
      ),
    );
  }

  Widget _buildNotificationList(NotificationListController controller) {
    final sections = controller.getSections();
    final notifications = controller.notifications.toList();

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: sections.length,
      itemBuilder: (context, sectionIndex) {
        final section = sections[sectionIndex];
        final sectionNotifications =
            notifications.where((notification) => notification.section == section).toList();

        if (sectionNotifications.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              section,
              style: CommonTextStyle.regular14w500.copyWith(
                color: ColorConstants.lightOrange,
              ),
            ),
            heightSpace(8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: sectionNotifications.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding:
                      EdgeInsets.only(bottom: index < sectionNotifications.length - 1 ? 12 : 0),
                  child: _buildNotificationCard(sectionNotifications[index], controller),
                );
              },
            ),
            heightSpace(30),
          ],
        );
      },
    );
  }

  Widget _buildNotificationCard(
      NotificationItem notification, NotificationListController controller) {
    return GestureDetector(
      onTap: () {
        controller.markAsRead(notification.id);
      },
      child: GlassBackgroundWidget(
        borderRadius: 10,
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                notification.userImageUrl,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    width: 50,
                    height: 50,
                    color: Colors.grey.shade900,
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                        color: ColorConstants.lightOrange,
                        strokeWidth: 2,
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 50,
                    height: 50,
                    color: Colors.grey.shade900,
                    child: const Icon(
                      Icons.person,
                      size: 30,
                      color: Colors.white54,
                    ),
                  );
                },
              ),
            ),
            widthSpace(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: RichText(
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                            style: CommonTextStyle.regular14w400,
                            children: [
                              TextSpan(
                                text: notification.userName,
                                style: CommonTextStyle.regular14w600,
                              ),
                              TextSpan(
                                text: ' ${notification.mainText}',
                                style: CommonTextStyle.regular14w400,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Text(
                        notification.timestamp,
                        style: CommonTextStyle.regular12w400.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                      widthSpace(5),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: notification.isRead ? Colors.grey : Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                  if (notification.secondaryText.isNotEmpty) ...[
                    heightSpace(4),
                    Text(
                      notification.secondaryText,
                      style: CommonTextStyle.regular13w400,
                      maxLines: 1,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
