import Foundation

#if os(Linux)
import Crypto
#else
import CommonCrypto
#endif

class Utilities {
    static let shared = Utilities()
    var code_challenge = ""
    var code_verifier = ""

    func genNewCode() {
        self.code_verifier = genCodeVerifier() ?? ""
        self.code_challenge = genCodeChallenge(codeVerifier: self.code_verifier) ?? ""
    }

    /// Generating a code verifier for PKCE
    public func genCodeVerifier() -> String? {
        var buffer = [UInt8](repeating: 0, count: 32)
        _ = SecRandomCopyBytes(kSecRandomDefault, buffer.count, &buffer)
       let codeVerifier = Data(buffer).base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
            .trimmingCharacters(in: .whitespaces)

        return codeVerifier
    }

    /// Generating a code challenge for PKCE
    public func genCodeChallenge(codeVerifier: String?) -> String? {
        guard let verifier = codeVerifier, let data = verifier.data(using: .utf8) else { return nil }

        #if !os(Linux)
        var buffer = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA256($0.baseAddress, CC_LONG(data.count), &buffer)
        }
        let hash = Data(buffer)
        #else
        let buffer = [UInt8](repeating: 0, count: SHA256.byteCount)
        let sha = Array(HMAC<SHA256>.authenticationCode(for: buffer, using: SymmetricKey(size: .bits256)))
        let hash = Data(sha)
        #endif

        let challenge = hash.base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
            .trimmingCharacters(in: .whitespaces)

        return challenge
    }

}
