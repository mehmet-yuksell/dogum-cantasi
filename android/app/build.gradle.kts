plugins {
 id("com.android.application")
 id("kotlin-android")
 id("dev.flutter.flutter-gradle-plugin")
}

android {
 namespace = "com.mombykind.dogum_cantasi"
 compileSdk = 36
 ndkVersion = "28.2.13676358"

 compileOptions {
 sourceCompatibility = JavaVersion.VERSION_21
 targetCompatibility = JavaVersion.VERSION_21
 isCoreLibraryDesugaringEnabled = true
 }

 defaultConfig {
 applicationId = "com.mombykind.dogum_cantasi" 
 minSdk = flutter.minSdkVersion
 targetSdk = 36
 versionCode = 1
 versionName = "1.0.0"
 }

 buildTypes {
 release {
 signingConfig = signingConfigs.getByName("debug")
 }
 }
}

dependencies {
 coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
}

flutter {
 source = "../.."
}
