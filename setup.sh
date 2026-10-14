#!/usr/bin/env bash
set -e

echo "جاري إنشاء ملفات مشروع كيبورد تمام المطابق تماماً للأصلي..."

mkdir -p app/src/main/java/com/ziipin/softkeyboard
mkdir -p app/src/main/res/layout
mkdir -p app/src/main/res/xml
mkdir -p app/src/main/res/drawable
mkdir -p app/src/main/res/values

# 1. settings.gradle
cat << 'EOF' > settings.gradle
pluginManagement {
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}
dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
    repositories {
        google()
        mavenCentral()
    }
}
rootProject.name = "TamamKeyboardPro"
include ':app'
EOF

# 2. build.gradle (Root)
cat << 'EOF' > build.gradle
plugins {
    id 'com.android.application' version '8.2.2' apply false
}
EOF

# 3. gradle.properties (مضبوط لعدم استهلاك الذاكرة)
cat << 'EOF' > gradle.properties
org.gradle.jvmargs=-Xmx2048m -Dfile.encoding=UTF-8
android.useAndroidX=true
EOF

# 4. app/build.gradle
cat << 'EOF' > app/build.gradle
plugins {
    id 'com.android.application'
}

android {
    namespace 'com.ziipin.softkeyboard.sa'
    compileSdk 33

    defaultConfig {
        applicationId "com.ziipin.softkeyboard.sa"
        minSdk 21
        targetSdk 33
        versionCode 523
        versionName "1.18.92"
    }

    buildTypes {
        debug {
            minifyEnabled false
        }
        release {
            minifyEnabled true
            shrinkResources true
        }
    }

    compileOptions {
        sourceCompatibility JavaVersion.VERSION_17
        targetCompatibility JavaVersion.VERSION_17
    }
}

dependencies {
}
EOF

# 5. AndroidManifest.xml (النسخة الأصلية المنظفة بالكامل من الإعلانات والتتبع)
cat << 'EOF' > app/src/main/AndroidManifest.xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.ziipin.softkeyboard.sa">

    <uses-permission android:name="android.permission.RECORD_AUDIO" />
    <uses-permission android:name="android.permission.SYSTEM_ALERT_WINDOW" />
    <uses-permission android:name="android.permission.VIBRATE" />
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
    <uses-permission android:name="android.permission.POST_NOTIFICATIONS" />

    <application
        android:allowBackup="true"
        android:largeHeap="false"
        android:supportsRtl="false"
        android:label="تمام لوحة المفاتيح العربية"
        android:theme="@android:style/Theme.DeviceDefault.NoActionBar">

        <activity
            android:name="com.ziipin.MainActivity"
            android:exported="true"
            android:excludeFromRecents="true"
            android:launchMode="singleTask"
            android:screenOrientation="portrait">
            <intent-filter>
                <action android:name="android.intent.action.VIEW" />
                <category android:name="android.intent.category.DEFAULT" />
                <category android:name="android.intent.category.BROWSABLE" />
            </intent-filter>
        </activity>

        <service
            android:name="com.ziipin.ime.SoftKeyboard"
            android:permission="android.permission.BIND_INPUT_METHOD"
            android:exported="true">
            <intent-filter>
                <action android:name="android.view.InputMethod" />
            </intent-filter>
            <meta-data
                android:name="android.view.im"
                android:resource="@xml/method" />
        </service>

    </application>
</manifest>
EOF

# 6. method.xml
cat << 'EOF' > app/src/main/res/xml/method.xml
<?xml version="1.0" encoding="utf-8"?>
<input-method xmlns:android="http://schemas.android.com/apk/res/android">
    <subtype
        android:label="العربية"
        android:imeSubtypeLocale="ar"
        android:imeSubtypeMode="keyboard" />
    <subtype
        android:label="English"
        android:imeSubtypeLocale="en_US"
        android:imeSubtypeMode="keyboard" />
</input-method>
EOF

# 7. MainActivity.java (شاشة تفعيل الكيبورد)
cat << 'EOF' > app/src/main/java/com/ziipin/MainActivity.java
package com.ziipin;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import android.provider.Settings;
import android.view.Gravity;
import android.view.View;
import android.view.inputmethod.InputMethodManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.TextView;

public class MainActivity extends Activity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        LinearLayout layout = new LinearLayout(this);
        layout.setOrientation(LinearLayout.VERTICAL);
        layout.setGravity(Gravity.CENTER);
        layout.setBackgroundColor(Color.parseColor("#121316"));
        layout.setPadding(40, 40, 40, 40);

        TextView title = new TextView(this);
        title.setText("تمام لوحة المفاتيح العربية (نسخة نظيفة بدون إعلانات)");
        title.setTextColor(Color.WHITE);
        title.setTextSize(18);
        title.setGravity(Gravity.CENTER);
        layout.addView(title);

        Button btnEnable = new Button(this);
        btnEnable.setText("1. تفعيل الكيبورد من الإعدادات");
        btnEnable.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                startActivity(new Intent(Settings.ACTION_INPUT_METHOD_SETTINGS));
            }
        });
        layout.addView(btnEnable);

        Button btnSelect = new Button(this);
        btnSelect.setText("2. اختيار الكيبورد كافتراضي");
        btnSelect.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                InputMethodManager imm = (InputMethodManager) getSystemService(INPUT_METHOD_SERVICE);
                if (imm != null) imm.showInputMethodPicker();
            }
        });
        layout.addView(btnSelect);

        EditText testInput = new EditText(this);
        testInput.setHint("جرب الكتابة هنا...");
        testInput.setHintTextColor(Color.GRAY);
        testInput.setTextColor(Color.WHITE);
        layout.addView(testInput);

        setContentView(layout);
    }
}
EOF

echo "تم إعداد ملفات مشروع الكيبورد الأصلي بنجاح!"
