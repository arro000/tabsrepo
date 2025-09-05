import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:classtab_catalog/providers/language_provider.dart';
import 'package:classtab_catalog/generated/l10n/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Language Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.language,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        l10n.language,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Consumer<LanguageProvider>(
                    builder: (context, languageProvider, child) {
                      return Column(
                        children:
                            languageProvider.supportedLocales.map((locale) {
                          final isSelected =
                              languageProvider.currentLocale == locale;
                          return ListTile(
                            title:
                                Text(languageProvider.getLanguageName(locale)),
                            trailing: isSelected
                                ? Icon(
                                    Icons.check,
                                    color: Theme.of(context).primaryColor,
                                  )
                                : null,
                            onTap: () {
                              languageProvider.setLanguage(locale);
                            },
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // App Info Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        l10n.appInfo,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    title: Text(l10n.appName),
                    subtitle: const Text('ClassTab Catalog'),
                  ),
                  ListTile(
                    title: Text(l10n.version),
                    subtitle: const Text('1.0.0'),
                  ),
                  ListTile(
                    title: Text(l10n.developer),
                    subtitle: const Text('ClassTab Team'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
