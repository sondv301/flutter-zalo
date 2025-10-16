import Foundation
import ZaloSDK
import Flutter
import Security

class ZaloAPI {
    static let shared = ZaloAPI()
    
    func initialize(result: @escaping FlutterResult) {
        let zaloAppID = Bundle.main.object(forInfoDictionaryKey: "ZaloAppID") as? String
        ZaloSDK.sharedInstance()?.initialize(withAppId: zaloAppID)
        result(nil)
    }
    
    func login(result: @escaping FlutterResult, type: String?) {
        logout()
        Utilities.shared.genNewCode()
        ZaloSDK.sharedInstance()?.unauthenticate()
        if let rootViewController = UIApplication.shared.delegate?.window??.rootViewController {
            ZaloSDK.sharedInstance()?.authenticateZalo(
                with: type == "app" ? ZAZaloSDKAuthenTypeViaZaloAppOnly :
                       type == "web" ? ZAZaloSDKAuthenTypeViaWebViewOnly :
                       ZAZaloSDKAuthenTypeViaZaloAppAndWebView,
                parentController: rootViewController,
                codeChallenge: Utilities.shared.code_challenge,
                extInfo: Constant.EXT_INFO
            ) { (response) in
                self.authenticateListener(result: result, with: response)
            }
        }
    }
    
    func authenticateListener(result: @escaping FlutterResult, with response: ZOOauthResponseObject?) {
        if response?.isSucess != true {
            result(false)
            return
        }
        ZaloSDK.sharedInstance().getAccessToken(
            withOAuthCode: response?.oauthCode,
            codeVerifier: Utilities.shared.code_verifier
        ) { (tokenResponse) in
            if tokenResponse?.errorCode != 0 {
                result(false)
                return
            }
            self.saveTokenData(tokenResponse)
            result(true)
        }
    }
    
    func saveTokenData(_ tokenResponse: ZOTokenResponseObject?) {
        AppStorage.shared.saveToKeychain(forKey: UserDefaultsKeys.accessToken.rawValue, value: tokenResponse?.accessToken ?? "")
        AppStorage.shared.saveToKeychain(forKey: UserDefaultsKeys.refreshToken.rawValue, value: tokenResponse?.refreshToken ?? "")
        AppStorage.shared.saveToKeychain(forKey: UserDefaultsKeys.expriedTime.rawValue, value: tokenResponse?.expriedTime != nil ? String(tokenResponse!.expriedTime) : "")
    }
    
    func isAccessTokenValid() -> Bool {
        if let expriedTimeString = AppStorage.shared.getFromKeychain(forKey: UserDefaultsKeys.expriedTime.rawValue),
           let expriedTimeDouble = Double(expriedTimeString) {
            let expriedTimeInt = Int(expriedTimeDouble)
            return expriedTimeInt > Int(Date().timeIntervalSince1970)
        }
        return false
    }
    
    func getAccessToken() -> String? {
        let accessToken = AppStorage.shared.getFromKeychain(forKey: UserDefaultsKeys.accessToken.rawValue)
        return isAccessTokenValid() ? accessToken : nil
    }
    
    func refreshAccessToken(result: @escaping FlutterResult) {
        let refreshToken = AppStorage.shared.getFromKeychain(forKey: UserDefaultsKeys.refreshToken.rawValue)
        ZaloSDK.sharedInstance().getAccessToken(withRefreshToken: refreshToken) { (response) in
            if response?.errorCode != 0 {
                result(false)
                return
            }
            self.saveTokenData(response)
            result(true)
        }
    }
    
    func getProfile(result: @escaping FlutterResult) {
        let accessToken = getAccessToken()
        
        if accessToken == nil {
            result(nil)
            return
        }
        ZaloSDK.sharedInstance().getZaloUserProfile(withAccessToken: accessToken) { (response) in
            if response?.errorCode != 0 {
                result(nil)
                return
            }
            let name = response?.data["name"] as? String
            let id = response?.data["id"] as? String
            let picture = response?.data["picture"] as? [String: Any?]
            var url = ""
            if let picture = picture, let pictureData = picture["data"] as? [String: Any], let sUrl = pictureData["url"] as? String {
                url = sUrl
            }
            let profile = [
                "id": id,
                "name": name,
                "pictureUrl": url
            ]
            result(profile)
        }
    }
    
    func logout() {
        AppStorage.shared.deleteFromKeychain(forKey: UserDefaultsKeys.accessToken.rawValue)
        AppStorage.shared.deleteFromKeychain(forKey: UserDefaultsKeys.refreshToken.rawValue)
        AppStorage.shared.deleteFromKeychain(forKey: UserDefaultsKeys.expriedTime.rawValue)
        ZaloSDK.sharedInstance()?.unauthenticate()
    }
}
