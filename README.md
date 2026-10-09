# نَسَق | NASAQ — تطبيق أندرويد تجريبي V1

مشروع Flutter بواجهة عربية جديدة للهاتف (الرئيسية، التصاميم، السوق، شوف لي، حسابي).

## الوضع الحالي
- واجهة Flutter أصلية مع شريط تنقل سفلي.
- الخدمات تفتح موقع Blogger داخل WebView مؤقتًا؛ لم يتم ربط Firebase مباشرة بعد.
- لا يوجد قسم «جيب لي».
- لم يتم تنفيذ إشعارات أصلية أو دعم كامل لتنزيل/رفع الملفات داخل WebView؛ يلزم اختبارها وتطويرها.
- **هذا مشروع مصدر، وليس APK جاهزًا أو تطبيقًا مكتملًا للنشر على Google Play.**

## بناء APK من الهاتف باستخدام GitHub Actions
1. أنشئ مستودع GitHub خاصًا جديدًا باسم `nasaq-app`.
2. فك ضغط ZIP وارفع محتويات مجلد `nasaq_flutter` إلى جذر المستودع، بما فيها `.github/workflows`.
3. افتح تبويب Actions ثم `Build Android test APK` ثم `Run workflow`.
4. بعد نجاح التشغيل نزّل ملف `NASAQ-test-APK` من Artifacts، ثم ثبّت APK على هاتفك للاختبار.
5. يحتاج النشر على Google Play لاحقًا ملف AAB موقّعًا، إعدادات هوية التطبيق، سياسة خصوصية، وفحص سياسات المتجر.

قد تتطلب بعض خدمات GitHub التحقق أو حدود الاستخدام حسب الحساب. لا ترفع مفاتيح Firebase الخاصة أو مفاتيح توقيع التطبيق إلى المستودع.

## بناء محلي (اختياري)
```bash
flutter create --platforms android --project-name nasaq_app .
flutter pub get
flutter build apk --debug
```
تأكد من وجود إذن `android.permission.INTERNET` في AndroidManifest عند البناء محليًا.
