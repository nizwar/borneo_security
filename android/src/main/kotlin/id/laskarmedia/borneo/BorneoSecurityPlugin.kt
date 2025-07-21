package id.laskarmedia.borneo

import android.content.Context
import android.provider.Settings.Secure.ANDROID_ID
import android.provider.Settings.Secure.getString
import android.telephony.TelephonyManager
import androidx.core.content.ContextCompat.getSystemService
import id.laskarmedia.borneo.security.BorneoMockAppLocation
import id.laskarmedia.borneo.security.BorneoPackages
import id.laskarmedia.borneo.security.BorneoPlayIntegrity
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodChannel


/** BorneoSecurityPlugin */
class BorneoSecurityPlugin : FlutterPlugin {
    companion object {
        const val CHANNEL = "id.laskarmedia.borneo/security"
    }

    private lateinit var mockAppLocationMethod: MethodChannel
    private lateinit var mockAppLocator: BorneoMockAppLocation

    private lateinit var packagesMethod: MethodChannel
    private lateinit var packages: BorneoPackages

    private lateinit var playIntegrityMethod: MethodChannel
    private lateinit var playIntegrity: BorneoPlayIntegrity


    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        playIntegrityMethod =
            MethodChannel(flutterPluginBinding.binaryMessenger, "$CHANNEL/playIntegrity")
        mockAppLocationMethod =
            MethodChannel(flutterPluginBinding.binaryMessenger, "$CHANNEL/mockAppLocation")
        packagesMethod = MethodChannel(flutterPluginBinding.binaryMessenger, "$CHANNEL/packages")

        mockAppLocator = BorneoMockAppLocation(flutterPluginBinding.applicationContext)
        playIntegrity = BorneoPlayIntegrity(flutterPluginBinding.applicationContext)
        packages = BorneoPackages(flutterPluginBinding.applicationContext)

        mockAppLocationMethod.setMethodCallHandler { call, result ->
            try {
                when (call.method) {
                    String(BuildConfig.HAS_MOCK_LOCATION) -> {
                        result.success(mockAppLocator.hasMockAppLocation())
                    }

                    String(BuildConfig.MOCK_APP_LOCATION_LIST) -> {
                        result.success(mockAppLocator.mockAppLocationList())
                    }

                    String(BuildConfig.IS_MOCK_ENABLED) -> {
                        try {
                            result.success(mockAppLocator.isMockEnabled())
                        } catch (e: Exception) {
                            result.error("mock_app_location", e.message, null)
                        }
                    }

                    else -> {
                        result.notImplemented()
                    }
                }
            } catch (e: Exception) {
                result.error("mock_app_location", e.message, null)
            }
        }
        packagesMethod.setMethodCallHandler { call, result ->
            try {
                when (call.method) {
                    String(BuildConfig.INSTALLED_APP_LIST) -> {
                        val arguments = call.arguments as Map<*, *>
                        result.success(packages.installedApps(arguments["fetch_icons"] as Boolean))
                    }

                    String(BuildConfig.GET_ICON) -> {
                        val arguments = call.arguments as Map<*, *>
                        val output = packages.getIcon(arguments["package_name"] as String)
                        if (output != null) {
                            result.success(output)
                        } else {
                            result.error("packages", "Package not found", null)
                        }
                    }

                    String(BuildConfig.GET_PACKAGE_INFO) -> {
                        val arguments = call.arguments as Map<*, *>
                        val output = packages.getPackageInfo(arguments["package_name"] as String)
                        if (output != null) {
                            result.success(packages.getPackageInfo(arguments["package_name"] as String))
                        } else {
                            result.error("packages", "Package not found", null)
                        }
                    }

                    else -> {
                        result.notImplemented()
                    }
                }
            } catch (e: Exception) {
                result.error("packages", e.message, null)
            }
        }

        playIntegrityMethod.setMethodCallHandler { call, result ->
            try {
                when (call.method) {
                    String(BuildConfig.INITIALIZE_PLAY_INTEGRITY) -> {
                        val arguments = call.arguments as Map<*, *>
                        try {
                            playIntegrity.initialize((arguments["cloud_project_number"] as Double).toLong())
                                .addOnSuccessListener {
                                    result.success(true)
                                }
                        } catch (e: Exception) {
                            result.error("play_integrity", e.message, null)
                        }
                    }

                    String(BuildConfig.GET_PLAY_INTEGRITY_TOKEN) -> {
                        try {
                            val arguments = call.arguments as Map<*, *>
                            playIntegrity.getPlayIntegrityToken(arguments["hash"] as String)
                                .addOnSuccessListener { response ->
                                    result.success(response.token())
                                }
                        } catch (e: Exception) {
                            result.error("play_integrity", e.message, null)
                        }
                    }

                    String(BuildConfig.GET_DEVICE_ID) -> {
                        try {
                            val deviceId = getString(flutterPluginBinding.applicationContext.contentResolver, ANDROID_ID)
                            result.success(deviceId)
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
