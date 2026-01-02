import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MembershipController extends GetxController {
  final RxInt selectedPlanIndex = 1.obs;
  final PageController pageController = PageController(initialPage: 1);

  final List<String> boombasticFeatures = [
    'Unlimited swipes, matches, filters',
    'Video/voice call + Read receipts',
    'Unlimited "Double Back"',
    'Unlimited "See Who Likes You"',
    '7 "Lei" per week',
    'Spotlight (weekly) + Super Spotlight (yearly)',
    'Island Hop & Travel Visa',
    '"Out the Way" (Incognito mode)',
    'Prioritized likes (10/week)',
  ];

  final List<String> premiumFeatures = [
    'Unlimited Swipes, matches, messages',
    'Ad-free',
    'Video, voice calling',
    'Read Receipts',
    'Advanced Filters',
    '10 "Double Back" Undo\'s/Week',
    'See 10 People Who Liked You',
    '1 "Lai" Per Week',
    'Skip Profiles',
  ];

  final List<String> freePlanFeatures = [
    'Create Profile',
    'Local Only',
    'Messaging (limited)',
    'Browse Profiles',
    'swipes (limited)',
  ];

  final List<Map<String, String>> addOns = [
    {
      'name': 'Spotlight',
      'price': '\$2.99',
      'period': '/ Day',
    },
    {
      'name': 'Travel Visa',
      'price': '\$2.99',
      'period': '/ Day',
    },
  ];

  final RxInt selectedDurationIndex = 0.obs;

  final RxList<PlanDuration> planDurations = <PlanDuration>[
    PlanDuration(
      id: '1',
      duration: '1 Month',
      price: '\$9.99',
      showSaveBadge: false,
      saveText: '',
      showBestValueBadge: false,
    ),
    PlanDuration(
      id: '2',
      duration: '3 Month',
      price: '\$23.99',
      showSaveBadge: true,
      saveText: 'SAVE 20%',
      showBestValueBadge: false,
    ),
    PlanDuration(
      id: '3',
      duration: '12 Month',
      price: '\$71.99',
      showSaveBadge: false,
      saveText: '',
      showBestValueBadge: true,
    ),
  ].obs;

  final RxList<MembershipPlan> plans = <MembershipPlan>[
    MembershipPlan(
      id: '1',
      name: 'LAVA',
      planType: 'Free Plan',
      features: [
        'Create Profile',
        'Local Only',
        'Messaging (limited)',
        'Browse Profiles',
        'swipes (limited)',
      ],
      isCurrentPlan: false,
      buttonText: 'Upgrade to Lava Lava',
    ),
    MembershipPlan(
      id: '2',
      name: 'LAVA',
      planType: 'Free Plan',
      features: [
        'Create Profile',
        'Local Only',
        'Messaging (limited)',
        'Browse Profiles',
        'swipes (limited)',
      ],
      isCurrentPlan: true,
      buttonText: 'Current Plan',
    ),
    MembershipPlan(
      id: '3',
      name: 'LAVA',
      planType: 'Free Plan',
      features: [
        'Create Profile',
        'Local Only',
        'Messaging (limited)',
        'Browse Profiles',
        'swipes (limited)',
        'Premium Features',
        'Unlimited Swipes',
        'Global Access',
      ],
      isCurrentPlan: false,
      buttonText: 'Upgrade to Lava Lava',
    ),
  ].obs;

  @override
  void onInit() {
    super.onInit();
    pageController.addListener(_onPageChanged);
  }

  void _onPageChanged() {
    if (pageController.page != null) {
      selectedPlanIndex.value = pageController.page!.round();
    }
  }

  void onPlanSelected(int index) {
    selectedPlanIndex.value = index;
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void onUpgradeTap(String planId) {
    Get.snackbar('Upgrade', 'Upgrading to plan: $planId');
  }

  void onViewAddOnsTap() {
    Get.snackbar('Add-Ons', 'Viewing add-on options...');
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}

class MembershipPlan {
  final String id;
  final String name;
  final String planType;
  final List<String> features;
  final bool isCurrentPlan;
  final String buttonText;

  MembershipPlan({
    required this.id,
    required this.name,
    required this.planType,
    required this.features,
    required this.isCurrentPlan,
    required this.buttonText,
  });
}

class AddOnItem {
  final String id;
  final String name;
  final String price;
  final String period;

  AddOnItem({
    required this.id,
    required this.name,
    required this.price,
    required this.period,
  });
}

class PlanDuration {
  final String id;
  final String duration;
  final String price;
  final bool showSaveBadge;
  final String saveText;
  final bool showBestValueBadge;

  PlanDuration({
    required this.id,
    required this.duration,
    required this.price,
    required this.showSaveBadge,
    required this.saveText,
    required this.showBestValueBadge,
  });
}
