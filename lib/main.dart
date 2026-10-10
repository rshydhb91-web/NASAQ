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
    title: 'نَسَق | NASAQ', debugShowCheckedModeBanner: false,
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
  final tabs = const ['الرئيسية', 'التصاميم', 'السوق', 'شوف لي', 'حسابي'];
  // The website currently supplies only two verified URLs. The other tabs
  // load the existing website directly until dedicated URLs are provided.
  final urls = const [homeUrl, homeUrl, homeUrl, seeUrl, homeUrl];
  late final List<WebViewController> controllers;
  final loading = List<bool>.filled(5, true);
  final errors = List<bool>.filled(5, false);

  @override
  void initState() {
    super.initState();
    controllers = List.generate(5, (i) {
      final controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(const Color(0xFFF5F7FA))
        ..setNavigationDelegate(NavigationDelegate(
          onPageStarted: (_) { if (mounted) setState(() { loading[i] = true; errors[i] = false; }); },
          onPageFinished: (_) { if (mounted) setState(() => loading[i] = false); },
          onWebResourceError: (error) { if (error.isForMainFrame == true && mounted) setState(() { loading[i] = false; errors[i] = true; }); },
          onNavigationRequest: (request) {
            final uri = Uri.tryParse(request.url);
            if (uri != null && (uri.scheme == 'http' || uri.scheme == 'https' || uri.scheme == 'about')) return NavigationDecision.navigate;
            if (uri != null) launchUrl(uri, mode: LaunchMode.externalApplication);
            return NavigationDecision.prevent;
          },
        ));
      controller.loadRequest(Uri.parse(urls[i]));
      return controller;
    });
  }

  Future<void> handleBack() async {
    if (await controllers[selected].canGoBack()) {
      await controllers[selected].goBack();
    } else if (selected != 0) {
      setState(() => selected = 0);
    }
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: false,
    onPopInvokedWithResult: (didPop, result) { if (!didPop) handleBack(); },
    child: Scaffold(
      appBar: AppBar(title: Text('نَسَق | NASAQ  •  ${tabs[selected]}', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)), actions: [
        IconButton(tooltip: 'تحديث', onPressed: () => controllers[selected].reload(), icon: const Icon(Icons.refresh)),
        IconButton(tooltip: 'فتح في المتصفح', onPressed: () => launchUrl(Uri.parse(urls[selected]), mode: LaunchMode.externalApplication), icon: const Icon(Icons.open_in_browser)),
      ]),
      body: IndexedStack(index: selected, children: List.generate(5, (i) => Stack(children: [
        WebViewWidget(controller: controllers[i]),
        if (loading[i]) const Align(alignment: Alignment.topCenter, child: LinearProgressIndicator(minHeight: 3)),
        if (errors[i]) Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text('تعذر تحميل الصفحة. تحقق من اتصال الإنترنت.'),
          const SizedBox(height: 12), FilledButton(onPressed: () => controllers[i].reload(), child: const Text('إعادة المحاولة')),
        ])),
      ]))),
      bottomNavigationBar: NavigationBar(selectedIndex: selected, onDestinationSelected: (i) => setState(() => selected = i), destinations: const [
        NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'الرئيسية'),
        NavigationDestination(icon: Icon(Icons.palette_outlined), selectedIcon: Icon(Icons.palette), label: 'التصاميم'),
        NavigationDestination(icon: Icon(Icons.storefront_outlined), selectedIcon: Icon(Icons.storefront), label: 'السوق'),
        NavigationDestination(icon: Icon(Icons.visibility_outlined), selectedIcon: Icon(Icons.visibility), label: 'شوف لي'),
        NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'حسابي'),
      ]),
    ),
  );
}
