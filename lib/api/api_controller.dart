import 'package:get/get.dart';
import 'package:get/get_connect/http/src/multipart/form_data.dart';
import '../Common/services/storage_service.dart';

class ApiController extends GetConnect {
  @override
  void onInit() {
    // httpClient.baseUrl = "http://54.68.144.58/api";
    httpClient.baseUrl = "http://44.236.88.158:3000/api";
    httpClient.timeout = const Duration(seconds: 30);
    httpClient.defaultContentType = "application/json";

    // Add request modifier to include Authorization header for authenticated requests
    httpClient.addRequestModifier<void>((request) {
      final token = StorageService.getAccessToken();
      /*  final token =
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI2OTRkMDMyNjZmYWRkOTNmOTNlYThhZmYiLCJlbWFpbCI6ImZyb250ZW5kLmRlbW9AbGF2YWFwcC5jb20iLCJpYXQiOjE3NjY5ODc0MjksImV4cCI6MTc2NzU5MjIyOX0.7JSAkDTg2WDGWb5AaMp7083LlcpljpaosIQdpZF68Ao";*/
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      return request;
    });

    super.onInit();
  }

  Future<Response> userLoginIn(Map<String, dynamic> body) => post('/auth/login', body);

  Future<Response> userSignUp(Map<String, dynamic> body) => post('/auth/signup', body);

  Future<Response> forgotPassword(Map<String, dynamic> body) => post('/auth/forgot-password', body);

  Future<Response> socialLogin(Map<String, dynamic> body) => post('/auth/social', body);

  Future<Response> logout() => post('/auth/logout', {});

  Future<Response> updateUserProfile(Map<String, dynamic> body) {
    return put('/users/profile', body);
  }

  Future<Response> uploadIntroVideo(FormData formData) {
    return post('/users/intro-video', formData);
  }

  Future<Response> uploadBulkPhotos(FormData formData) {
    return post('/users/photos/bulk', formData);
  }

  Future<Response> getHomeScreenData() {
    return get('/matches/home');
  }

  Future<Response> getCurrentUser() {
    return get('/auth/me');
  }

  Future<Response> getSwipeDeck({
    int limit = 20,
    int skip = 0,
    int? minAge,
    int? maxAge,
    double? maxDistance,
    String? genders,
    String? location,
  }) {
    final Map<String, String> queryParams = {
      'limit': limit.toString(),
      'skip': skip.toString(),
    };

    // Add filter parameters if provided
    if (minAge != null) {
      queryParams['minAge'] = minAge.toString();
    }
    if (maxAge != null) {
      queryParams['maxAge'] = maxAge.toString();
    }
    if (maxDistance != null) {
      queryParams['maxDistance'] = maxDistance.toInt().toString();
    }
    if (genders != null && genders.isNotEmpty) {
      queryParams['genders'] = genders;
    }
    if (location != null && location.isNotEmpty) {
      queryParams['location'] = location;
    }

    return get(
      '/matches/deck',
      query: queryParams,
    );
  }

  Future<Response> swipeUser({
    required String targetUserId,
    required String action,
  }) {
    return post(
      '/matches/swipe',
      {
        'targetUserId': targetUserId,
        'action': action,
      },
    );
  }

  Future<Response> skipUser(String targetUserId) {
    return post('/matches/skip/$targetUserId', {});
  }

  Future<Response> undoLastAction() {
    return post('/matches/undo', {});
  }

  Future<Response> getRemainingSwipes() {
    return get('/matches/remaining-swipes');
  }

  String getErrorMessage(Response response) {
    try {
      if (response.body != null && response.body is Map) {
        final body = response.body as Map<String, dynamic>;
        if (body.containsKey('message')) {
          return body['message'] as String? ?? 'Something went wrong';
        }
        if (body.containsKey('error')) {
          return body['error'] as String? ?? 'Something went wrong';
        }
      }
    } catch (e) {
      // Handle parsing errors
    }

    // Default error messages based on status code
    switch (response.statusCode) {
      case 400:
        return 'Bad request. Please check your input.';
      case 401:
        return 'Unauthorized. Please check your credentials.';
      case 403:
        return 'Forbidden. You don\'t have permission.';
      case 404:
        return 'Not found. Please try again.';
      case 409:
        return 'Conflict. This resource already exists.';
      case 500:
        return 'Server error. Please try again later.';
      case 503:
        return 'Service unavailable. Please try again later.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }
}
