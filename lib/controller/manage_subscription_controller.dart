import 'package:get/get.dart';
import '../View/blogsSpotlightModule/spotlight_your_profile.dart';
import '../View/blogsSpotlightModule/Island_hop_screen.dart';
import '../View/blogsSpotlightModule/super_spotlight_screen.dart';
import '../View/blogsSpotlightModule/travel_visa_screen.dart';

class SubscriptionBenefit {
  final String number;
  final String label;
  final String subLabel;

  SubscriptionBenefit({
    required this.number,
    required this.label,
    required this.subLabel,
  });
}

class ManageSubscriptionController extends GetxController {
  final RxString userName = "Jennifer Burk".obs;
  final RxString profileImageUrl = "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400".obs;

  final RxList<SubscriptionBenefit> benefits = <SubscriptionBenefit>[
    SubscriptionBenefit(
      number: "7",
      label: "\"Lei\"",
      subLabel: "Per Week",
    ),
    SubscriptionBenefit(
      number: "1",
      label: "Spotlight",
      subLabel: "(Weekly)",
    ),
    SubscriptionBenefit(
      number: "1",
      label: "Super Spotlight",
      subLabel: "(Yearly)",
    ),
    SubscriptionBenefit(
      number: "10",
      label: "Prioritized",
      subLabel: "Likes",
    ),
  ].obs;

  final RxList<String> actionButtons = <String>[
    "Spotlight Me",
    "Island Hop",
    "Super Spotlight",
    "Travel Visa",
  ].obs;

  void onActionButtonTap(String buttonName) {
    switch (buttonName) {
      case "Spotlight Me":
        Get.to(() => const SpotlightYourProfile());
        break;
      case "Island Hop":
        Get.to(() => const IslandHopScreen());
        break;
      case "Super Spotlight":
        Get.to(() => const SuperSpotlightScreen());
        break;
      case "Travel Visa":
        Get.to(() => const TravelVisaScreen());
        break;
    }
  }

  void onUpdateSubscriptionTap() {
    // Handle update subscription action
  }
}
