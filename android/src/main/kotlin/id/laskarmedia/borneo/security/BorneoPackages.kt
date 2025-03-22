package id.laskarmedia.borneo.security

import android.content.Context
import android.content.pm.ApplicationInfo
import android.content.pm.PackageManager
import android.content.pm.PackageManager.NameNotFoundException
import android.graphics.Bitmap
import android.graphics.drawable.Drawable
import android.os.Build
import androidx.core.graphics.drawable.toBitmap
import java.io.ByteArrayInputStream
import java.io.ByteArrayOutputStream
import java.security.MessageDigest
import java.security.cert.CertificateFactory
import java.security.cert.X509Certificate


class BorneoPackages(val context: Context) {
    val pm = context.packageManager

    fun installedApps(fetchIcons: Boolean): List<HashMap<String, Any?>> {
        val installedApps = pm.getInstalledApplications(0)
        return installedApps.map {
            fetchPackageInfo(it, fetchIcons)
        }
    }   //computed the sha1 hash of the signature

    fun getPackageInfo(packageName: String): HashMap<String, Any?>? {
        try {
            return fetchPackageInfo(
                pm.getApplicationInfo(packageName, PackageManager.GET_META_DATA),
                true
            )
        } catch (e: NameNotFoundException) {
            return null
        }
    }

    fun getIcon(packageName: String): ByteArray? {
        return try {
            drawableToByteArray(pm.getApplicationIcon(packageName))
        } catch (e: Exception) {
            null
        }
    }

    private fun fetchPackageInfo(app: ApplicationInfo, fetchIcon: Boolean): HashMap<String, Any?> {
        return HashMap<String, Any?>().apply {
            put("uid", app.uid)
            put("name", pm.getApplicationLabel(app))
            if (fetchIcon) {
                put("icon", drawableToByteArray(pm.getApplicationIcon(app)))
            } else {
                put("icon", null)
            }
            put("sourceDir", app.sourceDir)
            put("dataDir", app.dataDir)
            put("publicSourceDir", app.publicSourceDir)
            put("processName", app.processName)
            put("packageName", app.packageName)
            put("installer", pm.getInstallerPackageName(app.packageName))
            put(
                "versionCode", if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                    pm.getPackageInfo(
                        app.packageName,
                        PackageManager.GET_ACTIVITIES
                    ).longVersionCode
                } else {
                    pm.getPackageInfo(app.packageName, PackageManager.GET_ACTIVITIES).versionCode
                }
            )
            put(
                "versionName",
                pm.getPackageInfo(app.packageName, PackageManager.GET_ACTIVITIES).versionName
            )
            put(
                "firstInstallTime",
                pm.getPackageInfo(
                    app.packageName,
                    PackageManager.GET_ACTIVITIES
                ).firstInstallTime
            )
            put(
                "lastUpdateTime",
                pm.getPackageInfo(app.packageName, PackageManager.GET_ACTIVITIES).lastUpdateTime
            )

            put(
                "signing_certificates",
                pm.getPackageInfo(
                    app.packageName,
                    PackageManager.GET_SIGNATURES
                )?.signatures?.map {
                    if (it != null) {
                        HashMap<String, Any?>().apply {
                            put("hash", getSHA1(it.toByteArray()))
                            put("signature", it.toCharsString())
                            try {
                                val certFactory = CertificateFactory.getInstance("X509")
                                val x509Cert: X509Certificate =
                                    certFactory.generateCertificate(ByteArrayInputStream(it.toByteArray())) as X509Certificate
                                put("subjectDN", x509Cert.subjectDN.name)
                                put("issuerDN", x509Cert.issuerDN.name)
                                put("serialNumber", x509Cert.serialNumber)
                                put("notBefore", x509Cert.notBefore.time)
                                put("notAfter", x509Cert.notAfter.time)
                                put("publicKeyAlgorithm", x509Cert.publicKey.algorithm)
                                put("publicKeyFormat", x509Cert.publicKey.format)
                                put("publicKeyEncoded", x509Cert.publicKey.encoded)
                                put("publicKey", x509Cert.publicKey.toString())
                                put("publicKeyHash", getSHA1(x509Cert.publicKey.encoded))
                            } catch (_: Exception) {
                            }
                        }
                    } else {
                        null
                    }
                }?.toList() ?: emptyList<String>()
            )
            put(
                "permissions",
                pm.getPackageInfo(
                    app.packageName,
                    PackageManager.GET_PERMISSIONS
                )?.requestedPermissions?.toList() ?: emptyList<String>()
            )
        }
    }

    private fun getSHA1(sig: ByteArray?): String {
        if (sig == null) return "unassigned"
        val digest = MessageDigest.getInstance("SHA1")
        digest.update(sig)
        val hashText = digest.digest()
        return bytesToHex(hashText)
    }

    //util method to convert byte array to hex string
    private fun bytesToHex(bytes: ByteArray): String {
        val hexArray = charArrayOf(
            '0', '1', '2', '3', '4', '5', '6', '7', '8',
            '9', 'A', 'B', 'C', 'D', 'E', 'F'
        )
        val hexChars = CharArray(bytes.size * 2)
        var v: Int
        for (j in bytes.indices) {
            v = bytes[j].toInt() and 0xFF
            hexChars[j * 2] = hexArray[v ushr 4]
            hexChars[j * 2 + 1] = hexArray[v and 0x0F]
        }
        return String(hexChars)
    }


    private fun drawableToByteArray(drawable: Drawable): ByteArray? {
        try {
            val bitmap = drawable.toBitmap(256, 256)
            ByteArrayOutputStream().use { stream ->
                bitmap.compress(Bitmap.CompressFormat.PNG, 100, stream)
                return stream.toByteArray()
            }
        } catch (e: Exception) {
            return null
        }
    }

}