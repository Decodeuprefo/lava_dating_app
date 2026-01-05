import 'package:get_storage/get_storage.dart';

class StorageService {
  static final GetStorage _storage = GetStorage();

  // Token keys
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';

  // Initialize storage
  static Future<void> init() async {
    await GetStorage.init();
  }

  // Save access token
  static Future<void> saveAccessToken(String token) async {
    await _storage.write(_accessTokenKey, token);
  }

  // Get access token
  static String? getAccessToken() {
    return _storage.read<String>(_accessTokenKey);
  }

  // Save refresh token
  static Future<void> saveRefreshToken(String token) async {
    await _storage.write(_refreshTokenKey, token);
  }

  // Get refresh token
  static String? getRefreshToken() {
    return _storage.read<String>(_refreshTokenKey);
  }

  // Save both tokens
  static Future<void> saveTokens(String accessToken, String refreshToken) async {
    await _storage.write(_accessTokenKey, accessToken);
    await _storage.write(_refreshTokenKey, refreshToken);
  }

  // Clear all tokens
  static Future<void> clearTokens() async {
    await _storage.remove(_accessTokenKey);
    await _storage.remove(_refreshTokenKey);
  }

  // Check if user is logged in
  static bool isLoggedIn() {
    return getAccessToken() != null;
  }

  // Welcome screen completion key
  static const String _welcomeCompletedKey = 'welcome_completed';

  // Mark welcome screens as completed
  static Future<void> setWelcomeCompleted() async {
    await _storage.write(_welcomeCompletedKey, true);
  }

  // Check if welcome screens are completed
  static bool isWelcomeCompleted() {
    return _storage.read<bool>(_welcomeCompletedKey) ?? false;
  }

  // Clear welcome completion (for testing/logout if needed)
  static Future<void> clearWelcomeCompleted() async {
    await _storage.remove(_welcomeCompletedKey);
  }

  // Profile step key
  static const String _profileStepKey = 'profile_step';
  static const String _profileCompleteKey = 'profile_complete';

  // Save profile step (next screen index)
  static Future<void> setProfileStep(int step) async {
    await _storage.write(_profileStepKey, step);
  }

  // Get profile step (0 = start from SelectGender, -1 = profile complete)
  static int getProfileStep() {
    // Check if profile is marked as complete
    if (_storage.read<bool>(_profileCompleteKey) == true) {
      return -1; // Profile complete
    }
    return _storage.read<int>(_profileStepKey) ?? 0;
  }

  // Mark profile as complete (when LocationPermission is done)
  static Future<void> setProfileComplete() async {
    await _storage.write(_profileCompleteKey, true);
    await _storage.remove(_profileStepKey);
  }

  // Clear profile step (when profile is complete)
  static Future<void> clearProfileStep() async {
    await _storage.remove(_profileStepKey);
    await _storage.remove(_profileCompleteKey);
  }

  // Safety dialog keys
  static const String _safetyDialogFirstLaunchKey = 'safety_dialog_first_launch';
  static const String _appKilledFlagKey = 'app_killed_flag';

  // Check if safety dialog was shown on first launch
  static bool isSafetyDialogShownOnFirstLaunch() {
    return _storage.read<bool>(_safetyDialogFirstLaunchKey) ?? false;
  }

  // Mark safety dialog as shown on first launch
  static Future<void> setSafetyDialogShownOnFirstLaunch() async {
    await _storage.write(_safetyDialogFirstLaunchKey, true);
  }

  // Set app killed flag (call when app goes to background)
  static Future<void> setAppKilledFlag() async {
    await _storage.write(_appKilledFlagKey, true);
  }

  // Check and clear app killed flag (returns true if app was killed)
  static Future<bool> checkAndClearAppKilledFlag() async {
    final wasKilled = _storage.read<bool>(_appKilledFlagKey) ?? false;
    if (wasKilled) {
      await _storage.remove(_appKilledFlagKey);
    }
    return wasKilled;
  }

  // Clear app killed flag (call when app resumes normally)
  static Future<void> clearAppKilledFlag() async {
    await _storage.remove(_appKilledFlagKey);
  }
}
