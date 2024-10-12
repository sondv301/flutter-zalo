package com.zunsakai.flutter_zalo.flutter_zalo

import android.app.Activity
import android.content.Context
import android.text.TextUtils
import android.util.Log
import com.zing.zalo.zalosdk.ZaloOAuthResultCode
import com.zing.zalo.zalosdk.oauth.LoginVia
import com.zing.zalo.zalosdk.oauth.OAuthCompleteListener
import com.zing.zalo.zalosdk.oauth.OauthResponse
import com.zing.zalo.zalosdk.oauth.ZaloOpenAPICallback
import com.zing.zalo.zalosdk.oauth.ZaloSDK
import com.zing.zalo.zalosdk.oauth.model.ErrorResponse
import com.zunsakai.flutter_zalo.flutter_zalo.data.AppStorage
import com.zunsakai.flutter_zalo.flutter_zalo.data.UserData
import org.json.JSONObject

class ZaloAPI {
    private val LOG_TAG = ZaloAPI::class.java.simpleName
    private var mUserData: UserData? = null
    private lateinit var context: Context

    fun setContext(context: Context) {
        this.context = context
    }

    fun logIn(activity: Activity) {
        logout()
        Utilities.genNewCode()
        ZaloSDK.Instance.authenticateZaloWithAuthenType(
            activity,
            LoginVia.APP_OR_WEB,
            Utilities.code_challenge,
            listener
        )
    }

    private val listener: OAuthCompleteListener = object : OAuthCompleteListener() {
        override fun onAuthenError(response: ErrorResponse) {
            super.onAuthenError(response)
            Log.e(LOG_TAG, "Login failed: ${response.errorCode} - ${response.errorMsg}")
        }

        override fun onGetOAuthComplete(response: OauthResponse) {
            super.onGetOAuthComplete(response)
            ZaloSDK.Instance.getAccessTokenByOAuthCode(
                context, response.oauthCode, Utilities.code_verifier, onResult
            )
        }
    }

    private fun saveTokenData(data: JSONObject) {
        try {
            val accessToken = data.optString("access_token")
            val expiresIn = data.optString("expires_in").toLong()
            val refreshToken = data.optString("refresh_token")
            val refreshTokenExpiresIn = data.optString("refresh_token_expires_in").toLong()

            if (TextUtils.isEmpty(accessToken)) {
                Log.e(LOG_TAG, "Access token is empty")
                return
            }

            val timeExpire = System.currentTimeMillis() + expiresIn * 1000
            val timeRefreshExpire = System.currentTimeMillis() + refreshTokenExpiresIn * 1000

            AppStorage.getInstance(context).setAccessToken(accessToken)
            AppStorage.getInstance(context).setExpiresIn(timeExpire)
            AppStorage.getInstance(context).setRefreshToken(refreshToken)
            AppStorage.getInstance(context).setRefreshTokenExpiresIn(timeRefreshExpire)

            Log.d(LOG_TAG, "Login successfull!")
        } catch (e: Exception) {
            Log.e(LOG_TAG, "Error while saving token data: ${e.message}")
        }
    }

    private var onResult = ZaloOpenAPICallback { data ->
        val err = data.optInt("extCode", ZaloOAuthResultCode.ERR_UNKNOWN_ERROR)
        if (err != 0) {
            val msg = data.optString("errorMsg", "")
            Log.e(LOG_TAG, "Login failed: $msg")
        } else {
            saveTokenData(data)
        }
    }

    fun isAccessTokenValid(): Boolean {
        val accessToken = AppStorage.getInstance(context).getAccessToken()
        val timeExpire = AppStorage.getInstance(context).getExpiresIn()
        return !TextUtils.isEmpty(accessToken) && timeExpire > System.currentTimeMillis()
    }

    fun getAccessToken(): String? {
        val accessToken = AppStorage.getInstance(context).getAccessToken()
        return if (isAccessTokenValid()) accessToken else null
    }

    fun isRefreshAccessTokenValid(): Boolean {
        val refreshToken = AppStorage.getInstance(context).getRefreshToken()
        val timeExpire = AppStorage.getInstance(context).getRefreshTokenExpiresIn()
        return !TextUtils.isEmpty(refreshToken) && timeExpire > System.currentTimeMillis()
    }

    fun refreshAccessToken(): Boolean {
        try {
            if (!isRefreshAccessTokenValid()) {
                return false
            }
            ZaloSDK.Instance.getAccessTokenByRefreshToken(
                context,
                AppStorage.getInstance(context).getRefreshToken(),
                onResult
            )
            return true
        } catch (_: Exception) {
            return false
        }
    }

    fun getProfile(callback: (UserData) -> Unit) {
        val accessToken = getAccessToken()
        if (accessToken == null) {
            Log.e(LOG_TAG, "Access token is empty")
            return
        }
        val fields =
            arrayOf("id", "picture.type(large)", "name")
        ZaloSDK.Instance.getProfile(context, accessToken,
            { data ->
                mUserData = UserData()
                mUserData?.fromJson(data)
                callback(mUserData!!)
            }, fields
        )
    }

    fun logout(): Boolean {
        try {
            AppStorage.getInstance(context).clear()
            ZaloSDK.Instance.unauthenticate()
            mUserData = UserData()
            return true
        } catch (_: Exception) {
            return false
        }
    }
}