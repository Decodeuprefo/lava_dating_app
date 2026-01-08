import 'package:get/get.dart';
import '../Api/api_controller.dart';
import '../Model/signup_model.dart';

class EditProfileController extends GetxController {
  final ApiController _apiController = Get.find<ApiController>();

  bool isLoading = false;
  User? userProfile;

  @override
  void onInit() {
    super.onInit();
    getProfileData();
  }

  Future<void> getProfileData() async {
    isLoading = true;
    update();

    try {
      final response = await _apiController.getUserProfileData();
      isLoading = false;

      if (response.statusCode == 200) {
        if (response.body != null && response.body['user'] != null) {
          userProfile = User.fromJson(response.body['user']);
          print("userProfile>>>>>${userProfile}");
        }
      } else {
        print("Error fetching profile: ${response.statusCode}");
      }
    } catch (e) {
      isLoading = false;
      print("Exception fetching profile: $e");
    }
    update();
  }
}
