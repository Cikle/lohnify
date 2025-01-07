import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/home_screen.dart';
import 'services/language_service.dart';
import 'services/theme_service.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(LohnifyApp(prefs: prefs));
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
