package com.zunsakai.flutter_zalo.flutter_zalo

import android.content.Context
import android.util.Base64
import android.content.pm.PackageInfo
import android.content.pm.PackageManager

import java.security.MessageDigest
import java.security.SecureRandom

class Utilities {
    companion object {
        lateinit var code_challenge: String
        lateinit var code_verifier: String

        fun genNewCode() {
            code_verifier = genCodeVerifier()
            code_challenge = genCodeChallenge(code_verifier)
        }

        private fun genCodeVerifier(): String {
            val sr = SecureRandom()
            val code = ByteArray(32)
            sr.nextBytes(code)
            return Base64.encodeToString(code, Base64.URL_SAFE or Base64.NO_WRAP or Base64.NO_PADDING)
        }

        private fun genCodeChallenge(codeVerifier: String): String {
            var result = ""
            try {
                val bytes = codeVerifier.toByteArray(charset("US-ASCII"))
                val md = MessageDigest.getInstance("SHA-256")
                md.update(bytes, 0, bytes.size)
                val digest = md.digest()
                result = Base64.encodeToString(
                    digest,
                    Base64.URL_SAFE or Base64.NO_WRAP or Base64.NO_PADDING
                )
            } catch (_: Exception) {
            }
            return result
        }
    }
}