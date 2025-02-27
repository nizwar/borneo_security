package id.laskarmedia.borneo.security

import android.content.Context
import com.google.android.gms.tasks.Task
import com.google.android.play.core.integrity.IntegrityManager
import com.google.android.play.core.integrity.IntegrityManagerFactory
import com.google.android.play.core.integrity.IntegrityTokenRequest
import com.google.android.play.core.integrity.IntegrityTokenResponse
import com.google.android.play.core.integrity.StandardIntegrityManager
import io.flutter.plugin.common.MethodChannel

class BorneoPlayIntegrity(val context: Context) {
    var initialized: Boolean = false
    lateinit var integrityManager: IntegrityManager
    lateinit var integrityRequester: IntegrityTokenRequest.Builder

    fun initialize(projectId: Long, nonce: String): IntegrityManager {
        if (initialized) {
            throw Exception("Play Integrity already initialized")
        }
        integrityManager = IntegrityManagerFactory.create(context)
        integrityRequester = IntegrityTokenRequest.builder()
        integrityRequester.setCloudProjectNumber(projectId)
        integrityRequester.setNonce(nonce)
        initialized = true
        return integrityManager
    }

    fun getPlayIntegrityToken(): Task<IntegrityTokenResponse> {
        if (!initialized) {
            throw Exception("Play Integrity not initialized")
        }
        return integrityManager.requestIntegrityToken(integrityRequester.build())
    }
}