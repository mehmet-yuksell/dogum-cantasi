// NOT (entegrasyon ekibi için): Bu ayarlar, aşı ajandası (Mombykind)
// modülünde flutter_local_notifications kurulumu sırasında yaşanan
// "Unresolved reference" ve JVM target uyuşmazlığı hatalarının aynısını
// bu projede baştan önlemek için buraya bilerek eklendi:
//  - coreLibraryDesugaring: flutter_local_notifications'ın kullandığı
//    java.time API'lerini eski Android sürümlerinde çalıştırmak için ZORUNLU.
//  - JVM target: kotlinOptions bloğu YERİNE compileOptions içinde
//    JavaVersion.VERSION_21 kullanılıyor; kotlinOptions bloğu bazı
//    Gradle/Kotlin sürüm kombinasyonlarında "Unresolved reference" hatası
//    veriyordu (aşı projesinde yaşandı, burada tekrarlanmasın diye atlandı).

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.mombykind.dogumcantasi"
    compileSdk = 34
    ndkVersion = "25.1.8937393"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_21
        targetCompatibility = JavaVersion.VERSION_21
        isCoreLibraryDesugaringEnabled = true
    }

    defaultConfig {
        applicationId = "com.mombykind.dogumcantasi"
        minSdk = 23
        targetSdk = 34
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
