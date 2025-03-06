import android.app.Application
import com.zoho.apptics.analytics.AppticsAnalytics
import com.zoho.apptics.analytics.AppticsEventsIdMapping
import com.zoho.apptics.crash.AppticsCrashTracker

class MainApplication: Application() {
    override fun onCreate() {
        super.onCreate()

       AppticsAnalytics.init(this)
       AppticsCrashTracker.init(this)
       AppticsEventsIdMapping().init()
        
    }
}
