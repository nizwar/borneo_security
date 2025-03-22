package id.laskarmedia.borneo.security

import android.content.Context
import com.google.android.gms.tasks.Task
import com.google.android.play.core.integrity.IntegrityManager
import com.google.android.play.core.integrity.IntegrityManagerFactory
import com.google.android.play.core.integrity.IntegrityTokenRequest
import com.google.android.play.core.integrity.IntegrityTokenResponse
import com.google.android.play.core.integrity.StandardIntegrityManager
import com.google.android.play.core.integrity.StandardIntegrityManager.StandardIntegrityTokenProvider
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CompletableDeferred
import kotlinx.coroutines.CompletableJob

class BorneoPlayIntegrity(val context: Context) {
    var initialized: Boolean = false
    lateinit var integrityManager: StandardIntegrityManager
    private lateinit var integrityTokenProvider: StandardIntegrityTokenProvider

    fun initialize(cloudProjectNumber: Long): Task<StandardIntegrityTokenProvider> {
        if (initialized) {
            throw Exception("Play Integrity already initialized")
        }
        integrityManager = IntegrityManagerFactory.createStandard(context)
        val prepare = integrityManager.prepareIntegrityToken(
            StandardIntegrityManager.PrepareIntegrityTokenRequest.builder()
                .setCloudProjectNumber(cloudProjectNumber).build()
        )
        prepare.addOnSuccessListener { tokenProvider ->
            integrityTokenProvider = tokenProvider
            initialized = true
        }.addOnFailureListener { exception ->
            throw Exception("Failed to prepare integrity token: ${exception.message}")
        }

        return prepare;
    }

    fun getPlayIntegrityToken(hash: String): Task<StandardIntegrityManager.StandardIntegrityToken> {
        if (!initialized) {
            throw Exception("Play Integrity not initialized")
        }

        return integrityTokenProvider.request(
            StandardIntegrityManager.StandardIntegrityTokenRequest.builder().setRequestHash(hash)
                .build()
        )
    }
}