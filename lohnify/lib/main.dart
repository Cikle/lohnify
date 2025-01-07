import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/home_screen.dart';
import 'services/language_service.dart';
import 'services/theme_service.dart';
import 'package:provider/provider.dart';
import 'services/view_type_provider.dart'; // Add this line to import ViewTypeProvider

void main() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      debugPrint('Flutter Error: ${details.exception}');
      debugPrint('Stack trace: ${details.stack}');
    };

    ErrorWidget.builder = (FlutterErrorDetails details) {
      return Material(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 60),
              const SizedBox(height: 16),
              Text('An error occurred: ${details.exception}'),
              TextButton(
                onPressed: () => Navigator.of(details.context!).pop(),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      );
    };
    
    SharedPreferences prefs;
    try {
      prefs = await SharedPreferences.getInstance();
    } catch (e) {
      debugPrint('Failed to initialize SharedPreferences: $e');
      prefs = await SharedPreferences.getInstance();
    }
    
    runApp(LohnifyApp(prefs: prefs));
  }, (error, stack) {
    debugPrint('Uncaught error: $error');
    debugPrint('Stack trace: $stack');
  });
}

class LohnifyApp extends StatefulWidget {
  final SharedPreferences prefs;

  const LohnifyApp({super.key, required this.prefs});

  @override
  State<LohnifyApp> createState() => LohnifyAppState();
}

class LohnifyAppState extends State<LohnifyApp> {
  late final LanguageService languageService;
  late final ThemeService themeService;

  @override
  void initState() {
    super.initState();
    languageService = LanguageService(widget.prefs);
    themeService = ThemeService(widget.prefs);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: languageService),
        ChangeNotifierProvider.value(value: themeService),
        ChangeNotifierProvider(
          create: (_) => ViewTypeProvider(widget.prefs),
        ),
      ],
      child: Consumer<ThemeService>(
        builder: (context, themeService, _) => MaterialApp(
          locale: languageService.currentLocale,
          title: 'Lohnify',
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('de', 'CH'),
            Locale('en', ''),
          ],
          theme: themeService.currentTheme,
          home: const HomeScreen(),
        ),
      ),
    );
  }
}
