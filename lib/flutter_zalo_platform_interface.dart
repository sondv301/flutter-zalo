import 'flutter_zalo_method_channel.dart';

abstract class FlutterZaloAPI {
  static FlutterZaloAPI _instance = MethodChannelFlutterZalo();

  static FlutterZaloAPI get instance => _instance;

  static set instance(FlutterZaloAPI instance) {
    _instance = instance;
  }

  Future<void> init() {
    throw UnimplementedError('init() has not been implemented.');
  }

  Future<bool?> logIn({String? type}) {
    throw UnimplementedError('logIn() has not been implemented.');
  }

  Future<bool?> isAccessTokenValid() {
    throw UnimplementedError('isAccessTokenValid() has not been implemented.');
  }

  Future<String?> getAccessToken() {
    throw UnimplementedError('getAccessToken() has not been implemented.');
  }

  Future<bool?> refreshAccessToken() {
    throw UnimplementedError('refreshAccessToken() has not been implemented.');
  }

  Future<Map<String, dynamic>?> getProfile() {
    throw UnimplementedError('getProfile() has not been implemented.');
  }

  Future<bool?> logOut() {
    throw UnimplementedError('logOut() has not been implemented.');
  }
}
