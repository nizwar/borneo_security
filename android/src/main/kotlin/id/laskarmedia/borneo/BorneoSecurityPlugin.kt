package id.laskarmedia.borneo

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

import android.content.pm.PackageManager
import android.util.Log
import id.laskarmedia.borneo.security.BorneoMockAppLocation
import id.laskarmedia.borneo.security.BorneoPackages
import id.laskarmedia.borneo.security.BorneoPlayIntegrity
import io.flutter.plugin.common.MethodChannel.MethodCallHandler

/** BorneoSecurityPlugin */
class BorneoSecurityPlugin : FlutterPlugin {
    companion object {
        const val CHANNEL = "id.laskarmedia.borneo/security"
    }

    lateinit var mockAppLocationMethod: MethodChannel
    lateinit var mockAppLocator: BorneoMockAppLocation

    lateinit var packagesMethod: MethodChannel
    lateinit var packages: BorneoPackages

    lateinit var playIntegrityMethod: MethodChannel
    lateinit var playIntegrity: BorneoPlayIntegrity

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
                    "hasMockAppLocation" -> {
                        result.success(mockAppLocator.hasMockAppLocation())
                    }

                    "mockAppLocationList" -> {
                        result.success(mockAppLocator.mockAppLocationList())
                    }

                    "isMockEnabled" -> {
                        try{
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
                    "installedApps" -> {
                        val arguments = call.arguments as Map<*, *>
                        result.success(packages.installedApps(arguments["fetch_icons"] as Boolean))
                    }

                    "getIcon" -> {
                        val arguments = call.arguments as Map<*, *>
                        val output = packages.getIcon(arguments["package_name"] as String);
                        if (output != null) {
                            result.success(output)
                        } else {
                            result.error("packages", "Package not found", null)
                        }
                    }

                    "getPackageInfo" -> {
                        val arguments = call.arguments as Map<*, *>
                        val output = packages.getPackageInfo(arguments["package_name"] as String);
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
                    "initialize" -> {
                        val arguments = call.arguments as Map<*, *>
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
