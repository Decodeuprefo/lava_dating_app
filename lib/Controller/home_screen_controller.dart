import 'package:get/get.dart';

class HomeScreenController extends GetxController{
  final List<Map<String, String>> suggestions = [
    {
      'firstLine': 'This user likes you',
      'secondLine': 'Liam Parker',
    },
    {
      'firstLine': 'This user really likes you',
      'secondLine': 'Liam Parker',
    },
    {
      'firstLine': 'This user likes you',
      'secondLine': 'Noah',
    },
    {
      'firstLine': 'This user really likes you',
      'secondLine': 'Emma Wilson',
    },
    {
      'firstLine': 'This user likes you',
      'secondLine': 'James Brown',
    },
  ];

  final List<Map<String, String?>> matches = [
    {
      'name': 'James Carter',
      'age': 'Age 25',
      'imageUrl': null,
    },
    {
      'name': 'William Scott',
      'age': 'Age 28',
      'imageUrl': null,
    },
    {
      'name': 'Benjamin Harris',
      'age': 'Age 26',
      'imageUrl': null,
    },
    {
      'name': 'Alexander',
      'age': 'Age 24',
      'imageUrl': null,
    },
    {
      'name': 'Michael Brown',
      'age': 'Age 27',
      'imageUrl': null,
    },
  ];

}