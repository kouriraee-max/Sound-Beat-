# Sound Beat – Android

نسخه‌ی اندروید Sound Beat (Capacitor). ظاهر شبیه iOS/Apple Music:

- **Home** : پلی‌لیست‌ها + Liked Songs، «Recently played» (سری پیش گوش دادی) و «Your songs»
- **Library** : کارت آمار گوش‌دادن + همه‌ی پوشه‌های موزیک گوشی (هر پوشه = یک آیتم)
- **Search** : جستجو توی آهنگ / خواننده / آلبوم / پوشه
- پلیر کامل با پس‌زمینه‌ی بلور از کاور، متن آهنگ سینک‌شده (LRCLIB + Genius، پشتیبانی RTL فارسی)،
  Sleep timer، Lyrics offset، Queue، Shuffle/Repeat
- **Explore حذف شده**، Spotify هم (وابسته به Electron بود)

## ساخت APK (بدون کامپیوتر، فقط با گیت‌هاب)
1. یه ریپوی جدید توی GitHub بساز و محتوای این پوشه رو آپلود کن.
2. برو تب **Actions → Build APK → Run workflow**.
3. بعد از ~۵ دقیقه، از قسمت Artifacts فایل `SoundBeat-debug-apk` رو دانلود کن، unzip کن و `app-debug.apk` رو نصب کن.

## ساخت روی کامپیوتر
نیاز: Node 18+, JDK 17, Android SDK
```
bash setup-android.sh
cd android && ./gradlew assembleDebug
# خروجی: android/app/build/outputs/apk/debug/app-debug.apk
```
یا بعد از `bash setup-android.sh` پوشه‌ی `android` رو با Android Studio باز کن.

## ساختار
- `www/index.html` : کل رابط و منطق پخش
- `android-overlay/java/MusicLibraryPlugin.java` : اسکن MediaStore (پوشه‌ها، تگ‌ها) + استخراج کاور
- `setup-android.sh` : پروژه‌ی اندروید رو می‌سازه، پلاگین/پرمیشن/آیکن رو اضافه می‌کنه
