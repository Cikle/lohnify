import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/home_screen.dart';
import 'services/language_service.dart';

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

  @override
  void initState() {
    super.initState();
    languageService = LanguageService(widget.prefs);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
          locale: languageService.currentLocale,
          builder: (context, child) {
            return child!;
          },
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
          theme: ThemeData.dark().copyWith(
            primaryColor: Colors.blueGrey,
            scaffoldBackgroundColor: const Color(0xFF121212),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF1E1E1E),
              elevation: 0,
            ),
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: Colors.grey[900],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
            cardTheme: CardTheme(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          home: const HomeScreen(),
        ),
      ),
    );
  }
}
