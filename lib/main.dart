import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:classtab_catalog/providers/tablature_provider.dart';
import 'package:classtab_catalog/providers/midi_provider.dart';
import 'package:classtab_catalog/providers/youtube_provider.dart';
import 'package:classtab_catalog/providers/language_provider.dart';
import 'package:classtab_catalog/screens/home_screen.dart';
import 'package:classtab_catalog/services/database_service.dart';
import 'package:classtab_catalog/generated/l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the database
  await DatabaseService.instance.database;

  runApp(const ClassTabApp());
}

class ClassTabApp extends StatelessWidget {
  const ClassTabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => TablatureProvider()),
        ChangeNotifierProvider(create: (_) => MidiProvider()),
        ChangeNotifierProvider(create: (_) => YouTubeProvider()),
      ],
      child: Consumer<LanguageProvider>(
        builder: (context, languageProvider, child) {
          return MaterialApp(
            title: 'ClassTab Catalog',
            locale: languageProvider.currentLocale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: languageProvider.supportedLocales,
            theme: ThemeData(
              primarySwatch: Colors.brown,
              primaryColor: const Color(0xFF8D6E63),
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF8D6E63),
                brightness: Brightness.light,
              ),
              appBarTheme: const AppBarTheme(
                backgroundColor: Color(0xFF8D6E63),
                foregroundColor: Colors.white,
                elevation: 2,
              ),
              cardTheme: CardThemeData(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide:
                      const BorderSide(color: Color(0xFF8D6E63), width: 2),
                ),
              ),
            ),
            home: const HomeScreen(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
