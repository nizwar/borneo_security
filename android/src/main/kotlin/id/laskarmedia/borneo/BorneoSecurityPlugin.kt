package id.laskarmedia.borneo

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

import android.content.pm.PackageManager
import android.util.Log
import id.laskarmedia.borneo.security.BorneoMockAppLocation
import id.laskarmedia.borneo.security.BorneoPlayIntegrity
import io.flutter.plugin.common.MethodChannel.MethodCallHandler

/** BorneoSecurityPlugin */
class BorneoSecurityPlugin : FlutterPlugin {
    companion object {
        const val CHANNEL = "id.laskarmedia.borneo/security"
    }

    lateinit var mockAppLocationMethod: MethodChannel
    lateinit var mockAppLocator: BorneoMockAppLocation

    lateinit var playIntegrityMethod: MethodChannel
    lateinit var playIntegrity: BorneoPlayIntegrity

    private var initialized: Boolean = false

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        playIntegrityMethod =
            MethodChannel(flutterPluginBinding.binaryMessenger, "$CHANNEL/playIntegrity")
        mockAppLocationMethod =
            MethodChannel(flutterPluginBinding.binaryMessenger, "$CHANNEL/mockAppLocation")

        mockAppLocator = BorneoMockAppLocation(flutterPluginBinding.applicationContext)
        playIntegrity = BorneoPlayIntegrity(flutterPluginBinding.applicationContext)

        mockAppLocationMethod.setMethodCallHandler { call, result ->
            try {
                when (call.method) {
                    "hasMockAppLocation" -> {
                        result.success(mockAppLocator.hasMockAppLocation())
                    }

                    "mockAppLocationList" -> {
                        result.success(mockAppLocator.mockAppLocationList())
                    }

                    "isMockEnabled" -> {
                        result.success(mockAppLocator.isMockEnabled())
                    }

                    else -> {
                        result.notImplemented()
                    }
                }
            } catch (e: Exception) {
                result.error("mock_app_location", e.message, null)
            }
        }
        playIntegrityMethod.setMethodCallHandler { call, result ->
            try {
                when (call.method) {
                    "initialize" -> {
                        val arguments = call.arguments as Map<*, *>;
                        playIntegrity.initialize(
                            (arguments["project_id"] as Double).toLong(),
                            arguments["nonce"] as String
                        )
                        result.success(null)
                    }

                    "getPlayIntegrityToken" -> {
                        try {
                            playIntegrity.getPlayIntegrityToken().addOnSuccessListener { response ->
                                result.success(response.token())
                            }.addOnFailureListener { e ->
                                result.error("play_integrity", e.message, null)
                            }
                        } catch (e: Exception) {
                            result.error("play_integrity", e.message, null)
                        }
                    }

                    else -> {
                        result.notImplemented()
                    }
                }
            } catch (e: Exception) {
                result.error("play_integrity", e.message, null)
            }
        }
    }


    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        mockAppLocationMethod.setMethodCallHandler(null)
        playIntegrityMethod.setMethodCallHandler(null)
    }

}
