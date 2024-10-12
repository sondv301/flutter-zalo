import 'flutter_zalo_platform_interface.dart';

class FlutterZalo {
  Future<String?> init() {
    return FlutterZaloAPI.instance.init();
  }

  Future<bool?> logIn() {
    return FlutterZaloAPI.instance.logIn();
  }

  Future<bool?> isAccessTokenValid() {
    return FlutterZaloAPI.instance.isAccessTokenValid();
  }

  Future<String?> getAccessToken() {
    return FlutterZaloAPI.instance.getAccessToken();
  }

  Future<bool?> isRefreshAccessTokenValid() {
    return FlutterZaloAPI.instance.isRefreshAccessTokenValid();
  }

  Future<bool?> refreshAccessToken() {
    return FlutterZaloAPI.instance.refreshAccessToken();
  }

  Future<Map<String, dynamic>?> getProfile() {
    return FlutterZaloAPI.instance.getProfile();
  }

  Future<bool?> logOut() {
    return FlutterZaloAPI.instance.logOut();
  }
}
