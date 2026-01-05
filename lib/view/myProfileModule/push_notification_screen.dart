import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lava_dating_app/Common/constant/common_text_style.dart';
import 'package:lava_dating_app/Common/constant/custom_tools.dart';
import 'package:lava_dating_app/Common/widgets/custom_background.dart';
import 'package:lava_dating_app/Common/widgets/custom_toggle_switch.dart';

class PushNotificationScreen extends StatefulWidget {
  const PushNotificationScreen({super.key});

  @override
  State<PushNotificationScreen> createState() => _PushNotificationScreenState();
}

class _PushNotificationScreenState extends State<PushNotificationScreen> {
  bool remainingDailySwipe = true;
  bool chatMessages = true;
  bool someoneLikesYou = true;
  bool someoneReallyLikesYou = true;
  bool matchMade = true;
  bool someoneLookedAtProfile = true;

  List<Map<String, dynamic>> get notificationItems => [
        {
          'title': 'Remaining daily swipe',
          'value': remainingDailySwipe,
          'onChanged': (bool value) {
            setState(() {
              remainingDailySwipe = value;
            });
          },
        },
        {
          'title': 'Chat messages',
          'value': chatMessages,
          'onChanged': (bool value) {
            setState(() {
              chatMessages = value;
            });
          },
        },
        {
          'title': 'Someone likes you',
          'value': someoneLikesYou,
          'onChanged': (bool value) {
            setState(() {
              someoneLikesYou = value;
            });
          },
        },
        {
          'title': 'Someone really likes you',
          'value': someoneReallyLikesYou,
          'onChanged': (bool value) {
            setState(() {
              someoneReallyLikesYou = value;
            });
          },
        },
        {
          'title': 'Match made',
          'value': matchMade,
          'onChanged': (bool value) {
            setState(() {
              matchMade = value;
            });
          },
        },
        {
          'title': 'Someone looked at your profile',
          'value': someoneLookedAtProfile,
          'onChanged': (bool value) {
            setState(() {
              someoneLookedAtProfile = value;
            });
          },
        },
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundContainer(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              heightSpace(20),
              _buildHeader(),
              heightSpace(30),
              Expanded(
                child: _buildNotificationList(),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: Get.back,
            child: SvgPicture.asset(
              "assets/icons/back_arrow.svg",
              height: 30,
              width: 30,
              fit: BoxFit.fill,
            ),
          ),
          heightSpace(70),
          const Text(
            "Push Notification",
            style: CommonTextStyle.semiBold30w600,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: notificationItems.length,
      itemBuilder: (context, index) {
        final item = notificationItems[index];
        return _buildNotificationItem(
          title: item['title'] as String,
          value: item['value'] as bool,
          onChanged: item['onChanged'] as ValueChanged<bool>,
        );
      },
    );
  }

  Widget _buildNotificationItem({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: CommonTextStyle.regular16w500,
            ),
          ),
          widthSpace(20),
          CustomToggleSwitch(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
