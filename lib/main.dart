import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

const homeUrl = 'https://yusufahmed34.blogspot.com/';
const seeUrl = 'https://yusufahmed34.blogspot.com/p/khalliha-alina.html';
const navy = Color(0xFF071A2D);
const gold = Color(0xFFD4A915);

void main() => runApp(const NasaqApp());

class NasaqApp extends StatelessWidget {
  const NasaqApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'نَسَق | NASAQ',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(useMaterial3: true, colorScheme: ColorScheme.fromSeed(seedColor: gold), scaffoldBackgroundColor: const Color(0xFFF5F7FA), appBarTheme: const AppBarTheme(backgroundColor: navy, foregroundColor: Colors.white)),
    builder: (context, child) => Directionality(textDirection: TextDirection.rtl, child: child!),
    home: const Shell(),
  );
}

class Shell extends StatefulWidget {
  const Shell({super.key});
  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  int selected = 0;
  final tabs = const ['الرئيسية', 'التصاميم', 'سوق نَسَق', 'شوف لي', 'حسابي'];
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text('نَسَق | NASAQ  •  ${tabs[selected]}', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold))),
    body: IndexedStack(index: selected, children: [
      Landing(onSelect: (i) => setState(() => selected = i)),
      const ServiceScreen(title: 'التصاميم', subtitle: 'استيكر بنكك وأوكاش وبقية خدمات التصميم', icon: Icons.palette_rounded, url: homeUrl, note: 'هذه النسخة التجريبية تفتح منصة التصميم الحالية داخل التطبيق. دعم حفظ الصور يحتاج اختبارًا على جهاز أندرويد.'),
      const ServiceScreen(title: 'سوق نَسَق', subtitle: 'تصفح المنتجات والإعلانات على المنصة', icon: Icons.storefront_rounded, url: homeUrl, note: 'الواجهة الأصلية للسوق ستُربط لاحقًا ببيانات Firebase؛ حاليًا يتم فتح الموقع.'),
      const ServiceScreen(title: 'شوف لي', subtitle: 'أنشئ طلب تحقق وتابع تنفيذه', icon: Icons.visibility_rounded, url: seeUrl, note: 'خدمة «جيب لي» غير موجودة في التطبيق.'),
      const ServiceScreen(title: 'حسابي', subtitle: 'حسابك ونقاطك وVIP والإحالات', icon: Icons.person_rounded, url: homeUrl, note: 'تسجيل الدخول يعمل عبر صفحة الموقع الحالية داخل WebView؛ لم يُنفّذ تسجيل دخول Firebase أصلي بعد.'),
    ]),
    bottomNavigationBar: NavigationBar(selectedIndex: selected, onDestinationSelected: (i) => setState(() => selected = i), destinations: const [
      NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'الرئيسية'),
      NavigationDestination(icon: Icon(Icons.palette_outlined), selectedIcon: Icon(Icons.palette), label: 'التصاميم'),
      NavigationDestination(icon: Icon(Icons.storefront_outlined), selectedIcon: Icon(Icons.storefront), label: 'السوق'),
      NavigationDestination(icon: Icon(Icons.visibility_outlined), selectedIcon: Icon(Icons.visibility), label: 'شوف لي'),
      NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'حسابي'),
    ]),
  );
}

class Landing extends StatelessWidget {
  final ValueChanged<int> onSelect;
  const Landing({super.key, required this.onSelect});
  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(18), children: [
    Container(padding: const EdgeInsets.all(26), decoration: BoxDecoration(gradient: const LinearGradient(colors: [navy, Color(0xFF16466D)]), borderRadius: BorderRadius.circular(24)), child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Icon(Icons.auto_awesome, color: gold, size: 34), SizedBox(height: 12),
      Text('مرحبًا بك في نَسَق', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900)),
      SizedBox(height: 8), Text('خدماتك في مكان واحد', style: TextStyle(color: Color(0xFFFFDE7A), fontSize: 17)),
      SizedBox(height: 8), Text('تصاميم، سوق، وخدمة شوف لي — بسهولة من هاتفك.', style: TextStyle(color: Colors.white70)),
    ])),
    const SizedBox(height: 24), const Text('استكشف الخدمات', style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)), const SizedBox(height: 12),
    _tile('التصاميم', 'استيكر بنكك وأوكاش', Icons.palette_rounded, 1),
    _tile('سوق نَسَق', 'المنتجات والإعلانات', Icons.storefront_rounded, 2),
    _tile('شوف لي', 'تحقق من شيء عبر منفذ', Icons.visibility_rounded, 3),
    _tile('حسابي', 'النقاط وVIP والإحالات', Icons.person_rounded, 4),
    const SizedBox(height: 16), const Text('نسخة تجريبية: الخدمات تفتح الموقع الحالي مؤقتًا، والربط الأصلي قيد التطوير.', style: TextStyle(color: Colors.black54, fontSize: 12)),
  ]);
  Widget _tile(String title, String subtitle, IconData icon, int index) => Card(margin: const EdgeInsets.only(bottom: 12), elevation: 0, child: ListTile(onTap: () => onSelect(index), contentPadding: const EdgeInsets.all(13), leading: CircleAvatar(backgroundColor: const Color(0xFFFFF5D3), child: Icon(icon, color: navy)), title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)), subtitle: Text(subtitle), trailing: const Icon(Icons.arrow_back_ios_new_rounded, size: 16)));
}

class ServiceScreen extends StatelessWidget {
  final String title, subtitle, url, note;
  final IconData icon;
  const ServiceScreen({super.key, required this.title, required this.subtitle, required this.icon, required this.url, required this.note});
  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(22), children: [
    const SizedBox(height: 18), Icon(icon, color: navy, size: 64), const SizedBox(height: 14),
    Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
    const SizedBox(height: 8), Text(subtitle, textAlign: TextAlign.center), const SizedBox(height: 30),
    FilledButton.icon(style: FilledButton.styleFrom(backgroundColor: navy, padding: const EdgeInsets.all(16)), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SitePage(title: title, url: url))), icon: const Icon(Icons.open_in_new), label: const Text('فتح الخدمة')),
    const SizedBox(height: 12), OutlinedButton.icon(onPressed: () => launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication), icon: const Icon(Icons.language), label: const Text('فتح في المتصفح')),
    const SizedBox(height: 24), Text(note, textAlign: TextAlign.center, style: const TextStyle(color: Colors.black54, fontSize: 12)),
  ]);
}

class SitePage extends StatefulWidget {
  final String title, url;
  const SitePage({super.key, required this.title, required this.url});
  @override
  State<SitePage> createState() => _SitePageState();
}

class _SitePageState extends State<SitePage> {
  late final WebViewController controller;
  bool loading = true;
  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(onPageStarted: (_) { if (mounted) setState(() => loading = true); }, onPageFinished: (_) { if (mounted) setState(() => loading = false); }))
      ..loadRequest(Uri.parse(widget.url));
  }
  @override
  Widget build(BuildContext context) => PopScope(canPop: false, onPopInvokedWithResult: (didPop, result) async {
    if (didPop) return;
    if (await controller.canGoBack()) { await controller.goBack(); } else if (context.mounted) { Navigator.of(context).pop(); }
  }, child: Scaffold(appBar: AppBar(title: Text(widget.title), actions: [IconButton(onPressed: () => launchUrl(Uri.parse(widget.url), mode: LaunchMode.externalApplication), icon: const Icon(Icons.open_in_browser))]), body: Stack(children: [WebViewWidget(controller: controller), if (loading) const LinearProgressIndicator()])));
}
