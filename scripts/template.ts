export const BUILD_GRADLE = `

plugins {
    id "com.android.application"
    id "kotlin-android"
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id "dev.flutter.flutter-gradle-plugin"
}

def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}


def localProperties = new Properties()
def localPropertiesFile = rootProject.file("local.properties")
if (localPropertiesFile.exists()) {
    localPropertiesFile.withReader("UTF-8") { reader ->
        localProperties.load(reader)
    }
}

def flutterVersionCode = localProperties.getProperty("flutter.versionCode")
if (flutterVersionCode == null) {
    flutterVersionCode = "1"
}

def flutterVersionName = localProperties.getProperty("flutter.versionName")
if (flutterVersionName == null) {
    flutterVersionName = "1.0"
}

android {
    namespace = "com.example.fakecall"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.fakecall"
        // You can update the following values to match your application needs.
        // For more information, see: https://docs.flutter.dev/deployment/android#reviewing-the-gradle-build-configuration.
        minSdk = 21
        minSdkVersion 21
        targetSdk = flutter.targetSdkVersion
        versionCode = flutterVersionCode.toInteger()
        versionName = flutterVersionName
    }

    signingConfigs {
        release {
            keyAlias = keystoreProperties['keyAlias']
            keyPassword = keystoreProperties['keyPassword']
            storeFile = keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword = keystoreProperties['storePassword']
        }
    }
    buildTypes {
        release {

            signingConfig = signingConfigs.debug
            signingConfig = signingConfigs.release
        }
    }
}

flutter {
    source = "../.."
}
`;
export const ANDROID_MANIFEST = ({
    applicationName = "${applicationName}",
    admobAppId = "ca-app-pub-3940256099942544~3347511713",
    unityGameId = "5712423",
    applovinSDKKey = "lv0C9ThoCyfGpyWxTbIaL9CW2ZnBnE7ShD_Ae4y8XEq41bsvIgfIMnmqfKC8PTTaz_BbB_betbZ654QrCA9PKI",
  }:{applicationName?:string,
      admobAppId?: string,
      unityGameId?: string,
      applovinSDKKey?: string,
    }) => `
  <manifest xmlns:android="http://schemas.android.com/apk/res/android">
      <uses-permission android:name="android.permission.INTERNET"/>
      <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
      <uses-permission android:name="android.permission.SYSTEM_ALERT_WINDOW" />
      <uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
  
      <!-- foregroundServiceType: dataSync -->
      <uses-permission android:name="android.permission.FOREGROUND_SERVICE_DATA_SYNC" />
  
      <!-- foregroundServiceType: remoteMessaging -->
      <uses-permission android:name="android.permission.FOREGROUND_SERVICE_REMOTE_MESSAGING" />
      
      <!-- Single application block for AdMob, Facebook Audience Network, and Unity Ads -->
      <application
          android:networkSecurityConfig="@xml/network_security_config" 
          android:usesCleartextTraffic="true"
          android:label="\${applicationName}"   
          android:name="\${applicationName}"
          android:icon="@mipmap/ic_launcher">
  
          <meta-data
              android:name="com.google.android.gms.ads.APPLICATION_ID"
              android:value="${admobAppId}"/>
              <!-- admob -->
          <meta-data
              android:name="com.unity3d.ads.gameId"
              android:value="${unityGameId}" />
              <!-- unity  -->
          <meta-data 
              android:name="unityads.sdk.debug_mode" 
              android:value="true" />
              
          <meta-data
              android:name="com.unity3d.ads.testMode"
              android:value="false" /> <!-- Set to false in production -->
          <!-- AppLovin SDK metadata -->
         <meta-data android:name="applovin.sdk.key" android:value="${applovinSDKKey}"/>
         <!-- applovin -->
          <activity
              android:name=".MainActivity"
              android:exported="true"
              android:launchMode="singleTop"
              android:taskAffinity=""
              android:theme="@style/LaunchTheme"
              android:configChanges="orientation|keyboardHidden|keyboard|screenSize|smallestScreenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
              android:hardwareAccelerated="true"
              android:windowSoftInputMode="adjustResize">
              <meta-data
                android:name="io.flutter.embedding.android.NormalTheme"
                android:resource="@style/NormalTheme"
                />
              <intent-filter>
                  <action android:name="android.intent.action.MAIN"/>
                  <category android:name="android.intent.category.LAUNCHER"/>
              </intent-filter>
          </activity>
  
          <meta-data
              android:name="flutterEmbedding"
              android:value="2" />
  
          <!-- Foreground Service -->
          <service 
              android:name="com.pravera.flutter_foreground_task.service.ForegroundService"
              android:foregroundServiceType="dataSync|remoteMessaging"
              android:exported="false" />
      </application>
  
      <queries>
          <intent>
              <action android:name="android.intent.action.PROCESS_TEXT"/>
              <data android:mimeType="text/plain"/>
          </intent>
      </queries>
  </manifest>
  `;
  
  export const STRINGS_XML = ({facebookAppId="2563788477377677"}:{facebookAppId?: string,}) => `
  <resources>
      <string name="facebook_app_id">${facebookAppId}</string>
  </resources>
  `;