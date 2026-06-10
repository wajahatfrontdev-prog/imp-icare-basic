-keep class com.stripe.** { *; }
-keep class com.reactnativestripesdk.** { *; }

-keep class com.google.android.gms.** { *; }
-dontwarn com.google.android.gms.**


-keep class kotlin.Metadata { *; }

-keep class com.stripe.android.pushProvisioning.** { *; }
-dontwarn com.stripe.android.pushProvisioning.**

-keepclassmembers enum * { *; }
-keepattributes *Annotation*
