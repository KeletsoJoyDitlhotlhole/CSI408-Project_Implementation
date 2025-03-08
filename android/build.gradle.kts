plugins {
    id 'com.android.library'
    id 'kotlin-android'
}

android {
    compileSdkVersion 33

    // Add the namespace here (use the plugin's package or app-specific one)
    namespace = "com.dexterous.flutterlocalnotifications"  // Add namespace for the plugin module

    defaultConfig {
        minSdkVersion 21
        targetSdkVersion 33
        versionCode 1
        versionName "1.0"
    }

    buildTypes {
        release {
            isMinifyEnabled = false
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
    }
}

dependencies {
    implementation "org.jetbrains.kotlin:kotlin-stdlib:1.8.22"
}
