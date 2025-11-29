import java.io.FileInputStream
import java.util.Properties

// --- Configuración de Firma CI/CD ---

// 1. Define las variables y la ubicación del archivo de propiedades
val signingProperties = Properties()
// Busca el archivo key.properties en el directorio 'android/'
val signingPropertyFile = rootProject.file("key.properties") 

// 2. Carga las propiedades si el archivo existe
if (signingPropertyFile.exists()) {
    signingProperties.load(FileInputStream(signingPropertyFile))
}

// ------------------------------------

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.frontend_water_quality"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.frontend_water_quality"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // 3. Define el bloque de configuraciones de firma
    signingConfigs {
        // Define la configuración de 'release' para leer las credenciales del key.properties
        create("release") {
            if (signingPropertyFile.exists()) {
                storeFile = file(signingProperties.getProperty("storeFile"))
                storePassword = signingProperties.getProperty("storePassword")
                keyAlias = signingProperties.getProperty("keyAlias")
                keyPassword = signingProperties.getProperty("keyPassword")
            }
        }
    }

    buildTypes {
        release {
            // 4. Aplica la configuración de firma
            // Si key.properties existe (CI/CD), usa la clave de release
            if (signingPropertyFile.exists()) {
                signingConfig = signingConfigs.getByName("release")
            } else {
                // Si no existe (Desarrollo Local), usa la clave de debug (como antes)
                signingConfig = signingConfigs.getByName("debug")
            }
        }
    }
}

flutter {
    source = "../.."
}