import 'package:get/get.dart';

class FreeGameFridayController extends GetxController {
  final RxList<Map<String, dynamic>> gameArticles = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadGameArticles();
  }

  void _loadGameArticles() {
    gameArticles.value = [
      {
        'id': 1,
        'title': 'Top 10 Romantic Games to Play With Your Match',
        'author': 'Emily Carter',
        'date': '17 Nov 2025',
        'comments': 15,
        'likes': 50,
        'image': 'assets/images/example_image.jpg',
      },
      {
        'id': 2,
        'title': 'Best Two-Player Games for Date Night',
        'author': 'Michael Torres',
        'date': '15 Nov 2025',
        'comments': 23,
        'likes': 78,
        'image': 'assets/images/game2.png',
      },
      {
        'id': 3,
        'title': 'How to Bond Through Gaming Together',
        'author': 'Sarah Johnson',
        'date': '12 Nov 2025',
        'comments': 31,
        'likes': 92,
        'image': 'assets/images/game3.png',
      },
      {
        'id': 4,
        'title': 'Cooperative Games That Strengthen Relationships',
        'author': 'David Kim',
        'date': '10 Nov 2025',
        'comments': 18,
        'likes': 65,
        'image': 'assets/images/game4.png',
      },
      {
        'id': 5,
        'title': 'Fun Mobile Games to Play Together Anytime',
        'author': 'Lisa Martinez',
        'date': '8 Nov 2025',
        'comments': 27,
        'likes': 84,
        'image': 'assets/images/game5.png',
      },
    ];
  }
}
