package id.laskarmedia.borneo.security

import android.app.Service
import android.content.Context
import android.content.pm.PackageManager
import android.location.LocationManager
import android.os.Build
import android.provider.Settings


class BorneoMockAppLocation(val context: Context) {
    fun hasMockAppLocation(): Boolean {
        return mockAppLocationList().isNotEmpty()
    }

    fun mockAppLocationList(): List<HashMap<String, Any?>> {
        val pm = context.packageManager
        val installedApps = pm.getInstalledApplications(0)
        return installedApps.filter { app ->
            pm.getPackageInfo(app.packageName, PackageManager.GET_PERMISSIONS)?.let { packageInfo ->
                packageInfo.requestedPermissions?.forEach { permission ->
                    if (permission == "android.permission.ACCESS_MOCK_LOCATION") {
                        return@filter true
                    }
                }
            }
            return@filter false
        }.map {
            HashMap<String, Any?>().apply {
                put("packageName", it.packageName)
                pm.getPackageInfo(it.packageName, PackageManager.GET_PERMISSIONS)
                    ?.let { packageInfo ->
                        put("permissions", packageInfo.requestedPermissions)
                    }

            }
        }
    }

    fun isMockEnabled(): Boolean {
        val lm = context.getSystemService(Service.LOCATION_SERVICE) as LocationManager
        try {
            if (lm.getLastKnownLocation(LocationManager.GPS_PROVIDER) != null) {
                return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                    lm.getLastKnownLocation(LocationManager.GPS_PROVIDER)!!.isMock
                } else {
                    lm.getLastKnownLocation(LocationManager.GPS_PROVIDER)!!.isFromMockProvider
                }
            }
        } catch (e: Settings.SettingNotFoundException) {
            return false
        }


        return false;
    }
}
