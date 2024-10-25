import Flutter
import UIKit
import ZaloSDK

public class FlutterZaloPlugin: NSObject, FlutterPlugin {
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_zalo", binaryMessenger: registrar.messenger())
        let instance = FlutterZaloPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "init":
            ZaloAPI.shared.initialize(result: result)
        case "logIn":
            ZaloAPI.shared.login(result: result)
        case "isAccessTokenValid":
            result(ZaloAPI.shared.isAccessTokenValid())
        case "getAccessToken":
            result(ZaloAPI.shared.getAccessToken())
        case "refreshAccessToken":
            ZaloAPI.shared.refreshAccessToken(result: result)
        case "getProfile":
            ZaloAPI.shared.getProfile(result: result)
        case "logOut":
            ZaloAPI.shared.logout()
            result(true)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
