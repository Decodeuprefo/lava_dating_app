import 'package:get/get.dart';
import '../Api/api_controller.dart';
import '../Model/home_screen_model.dart';

class HomeScreenController extends GetxController {
  final ApiController _apiController = Get.find<ApiController>();

  bool isLoading = false;
  HomeScreenModel? homeData;

  @override
  void onInit() {
    super.onInit();
    fetchHomeScreenData();
  }

  Future<void> fetchHomeScreenData() async {
    if (isLoading) return;

    isLoading = true;
    update();

    try {
      final response = await _apiController.getHomeScreenData();
      isLoading = false;
      update();

      if (response.statusCode == 200 && response.body != null) {
        try {
          homeData = HomeScreenModel.fromJson(response.body);
          update();
        } catch (e) {
          print('Error parsing home screen data: $e');
        }
      } else {
        final errorMessage = _apiController.getErrorMessage(response);
        print('Error fetching home screen data: $errorMessage');
      }
    } catch (e) {
      isLoading = false;
      update();
      print('Network error fetching home screen data: $e');
    }
  }
}
