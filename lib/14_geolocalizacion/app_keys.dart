// https://medium.com/comunidad-flutter/google-maps-en-flutter-98bedecb528b
// https://www.mindbowser.com/flutter-google-maps/

// https://codelabs.developers.google.com/codelabs/google-maps-in-flutter?hl=es-419#3
// ios/Runner/AppDelegate.swift

// $ flutter create google_maps_in_flutter
// $ flutter pub add google_maps_flutter_web

// Cómo configurar platform de iOS
// ios/Podfile
/*
# Set platform to 11.0 to enable latest Google Maps SDK
platform :ios, '11.0' # Uncomment and set to 11.

# CocoaPods analytics sends network stats synchronously affecting flutter build latency.
ENV['COCOAPODS_DISABLE_STATS'] = 'true'

https://developers.google.com/maps/flutter-package/config?hl=es-419#kotlin_1
*/

//----------------------------------------------------------------------------
// ignore: non_constant_identifier_names
const String GOOGLE_KEY = String.fromEnvironment('GOOGLE_KEY');
const String GOOGLE_MAPS_KEY = String.fromEnvironment('GOOGLE_MAPS_KEY');
//

//----------------------------------------------------------------------------
//----------------------------------------------------------------------------
// Cómo configurar minSDK de Android
// android/app/build.gradle

//----------------------------------------------------------------------------
//----------------------------------------------------------------------------
// Cómo agregar una clave de API a una app para Android
/*
android/app/src/main/AndroidManifest.xml

<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.example.google_maps_in_flutter">
    <application
        android:label="google_maps_in_flutter"
        android:icon="@mipmap/ic_launcher">

        <!-- TODO: Add your Google Maps API key here -->
        <meta-data android:name="com.google.android.geo.API_KEY"
               android:value="YOUR-KEY-HERE"/>

        <activity
            android:name=".MainActivity"
            android:launchMode="singleTop"
            android:theme="@style/LaunchTheme"
            android:configChanges="orientation|keyboardHidden|keyboard|screenSize|smallestScreenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
            android:hardwareAccelerated="true"
            android:windowSoftInputMode="adjustResize">
            <meta-data
              android:name="io.flutter.embedding.android.NormalTheme"
              android:resource="@style/NormalTheme"
              />
            <meta-data
              android:name="io.flutter.embedding.android.SplashScreenDrawable"
              android:resource="@drawable/launch_background"
              />
            <intent-filter>
                <action android:name="android.intent.action.MAIN"/>
                <category android:name="android.intent.category.LAUNCHER"/>
            </intent-filter>
        </activity>
        <meta-data
            android:name="flutterEmbedding"
            android:value="2" />
    </application>
</manifest>
*/

// Cómo agregar una clave de API a una app para iOS
// Cómo agregar una clave de API a una app web
/*
web/index.html

<head>
  <base href="/">

  <meta charset="UTF-8">
  <meta content="IE=Edge" http-equiv="X-UA-Compatible">
  <meta name="description" content="A new Flutter project.">

  <!-- iOS meta tags & Symbols -->
  <meta name="apple-mobile-web-app-capable" content="yes">
  <meta name="apple-mobile-web-app-status-bar-style" content="black">
  <meta name="apple-mobile-web-app-title" content="google_maps_in_flutter">
  <link rel="apple-touch-icon" href="Symbols/Icon-192.png">

  <!-- TODO: Add your Google Maps API key here -->
  <script src="https://maps.googleapis.com/maps/api/js?key=YOUR-KEY-HERE"></script>

  <title>google_maps_in_flutter</title>
  <link rel="manifest" href="manifest.json">
</head>
*/
//-----------------------------------------------------------------------------
// Cómo mostrar un mapa en la pantalla
