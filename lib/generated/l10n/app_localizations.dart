import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_it.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('it')
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'ClassTab Catalog'**
  String get appTitle;

  /// Home tab label
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// Search tab label
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// Composers tab label
  ///
  /// In en, this message translates to:
  /// **'Composers'**
  String get composers;

  /// Favorites tab label
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// Tooltip for sync button
  ///
  /// In en, this message translates to:
  /// **'Sync with ClassTab.org'**
  String get syncWithClassTab;

  /// Synchronization dialog title
  ///
  /// In en, this message translates to:
  /// **'Synchronization'**
  String get synchronization;

  /// Content of synchronization dialog
  ///
  /// In en, this message translates to:
  /// **'Do you want to sync tablatures with ClassTab.org? This will download all the latest data (about 13MB).'**
  String get syncDialogContent;

  /// Cancel button text
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Sync button text
  ///
  /// In en, this message translates to:
  /// **'Sync'**
  String get sync;

  /// Loading message for tablatures
  ///
  /// In en, this message translates to:
  /// **'Loading tablatures...'**
  String get loadingTablatures;

  /// Retry button text
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Message when no tablatures are found
  ///
  /// In en, this message translates to:
  /// **'No tablatures found'**
  String get noTablaturesFound;

  /// Message to encourage syncing
  ///
  /// In en, this message translates to:
  /// **'Sync with ClassTab.org to download tablatures'**
  String get syncToDownloadTablatures;

  /// Sync now button text
  ///
  /// In en, this message translates to:
  /// **'Sync now'**
  String get syncNow;

  /// Recent tablatures section title
  ///
  /// In en, this message translates to:
  /// **'Recent Tablatures'**
  String get recentTablatures;

  /// Button to view all tablatures
  ///
  /// In en, this message translates to:
  /// **'View all {count} tablatures'**
  String viewAllTablatures(int count);

  /// Default title for YouTube video
  ///
  /// In en, this message translates to:
  /// **'YouTube Video'**
  String get youTubeVideo;

  /// Settings tab title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Search hint text
  ///
  /// In en, this message translates to:
  /// **'Search tablatures...'**
  String get searchTablatures;

  /// Composer label
  ///
  /// In en, this message translates to:
  /// **'Composer'**
  String get composer;

  /// Title label
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// Difficulty label
  ///
  /// In en, this message translates to:
  /// **'Difficulty'**
  String get difficulty;

  /// All filter option
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// Easy difficulty
  ///
  /// In en, this message translates to:
  /// **'Easy'**
  String get easy;

  /// Medium difficulty
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get medium;

  /// Hard difficulty
  ///
  /// In en, this message translates to:
  /// **'Hard'**
  String get hard;

  /// Expert difficulty
  ///
  /// In en, this message translates to:
  /// **'Expert'**
  String get expert;

  /// Clear filters button
  ///
  /// In en, this message translates to:
  /// **'Clear filters'**
  String get clearFilters;

  /// No search results message
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResults;

  /// Suggestion when no results found
  ///
  /// In en, this message translates to:
  /// **'Try a different search term or clear the filters'**
  String get tryDifferentSearch;

  /// Total tablatures statistic
  ///
  /// In en, this message translates to:
  /// **'Total tablatures'**
  String get totalTablatures;

  /// Total composers statistic
  ///
  /// In en, this message translates to:
  /// **'Total composers'**
  String get totalComposers;

  /// Favorite tablatures statistic
  ///
  /// In en, this message translates to:
  /// **'Favorite tablatures'**
  String get favoriteTablatures;

  /// Last sync statistic
  ///
  /// In en, this message translates to:
  /// **'Last sync'**
  String get lastSync;

  /// Never synced
  ///
  /// In en, this message translates to:
  /// **'Never'**
  String get never;

  /// Add to favorites tooltip
  ///
  /// In en, this message translates to:
  /// **'Add to favorites'**
  String get addToFavorites;

  /// Remove from favorites tooltip
  ///
  /// In en, this message translates to:
  /// **'Remove from favorites'**
  String get removeFromFavorites;

  /// View tablature button
  ///
  /// In en, this message translates to:
  /// **'View tablature'**
  String get viewTablature;

  /// Play MIDI button
  ///
  /// In en, this message translates to:
  /// **'Play MIDI'**
  String get playMidi;

  /// Watch on YouTube button
  ///
  /// In en, this message translates to:
  /// **'Watch on YouTube'**
  String get watchOnYouTube;

  /// No favorites message
  ///
  /// In en, this message translates to:
  /// **'No favorites yet'**
  String get noFavorites;

  /// Message to encourage adding favorites
  ///
  /// In en, this message translates to:
  /// **'Add some tablatures to your favorites to see them here'**
  String get addFavoritesMessage;

  /// Browse tablatures button
  ///
  /// In en, this message translates to:
  /// **'Browse tablatures'**
  String get browseTablatures;

  /// Tablatures by composer title
  ///
  /// In en, this message translates to:
  /// **'Tablatures by {composer}'**
  String tablaturesByComposer(String composer);

  /// No tablatures for composer message
  ///
  /// In en, this message translates to:
  /// **'No tablatures found for this composer'**
  String get noTablaturesForComposer;

  /// MIDI settings section
  ///
  /// In en, this message translates to:
  /// **'MIDI Settings'**
  String get midiSettings;

  /// Enable MIDI setting
  ///
  /// In en, this message translates to:
  /// **'Enable MIDI playback'**
  String get enableMidi;

  /// MIDI volume setting
  ///
  /// In en, this message translates to:
  /// **'MIDI volume'**
  String get midiVolume;

  /// General settings section
  ///
  /// In en, this message translates to:
  /// **'General Settings'**
  String get generalSettings;

  /// Language settings section title
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Theme setting
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// Light theme
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// Dark theme
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// System theme
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// About section
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// Version label
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// About app button
  ///
  /// In en, this message translates to:
  /// **'About the app'**
  String get aboutApp;

  /// Application description
  ///
  /// In en, this message translates to:
  /// **'A Flutter application for cataloging and viewing classical guitar tablatures from ClassTab.org'**
  String get appDescription;

  /// Generic loading message
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// Generic error message
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// OK button
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// Close button
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// Save button
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Delete button
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Confirm button
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// Yes button
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No button
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// Filters tooltip
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filters;

  /// Message when no search has been performed
  ///
  /// In en, this message translates to:
  /// **'Start searching for tablatures'**
  String get startSearching;

  /// Suggestion when no results found
  ///
  /// In en, this message translates to:
  /// **'Try different search terms'**
  String get tryDifferentTerms;

  /// Number of search results
  ///
  /// In en, this message translates to:
  /// **'{count} results'**
  String resultsCount(int count);

  /// Clear all filters button
  ///
  /// In en, this message translates to:
  /// **'Clear filters'**
  String get clearAllFilters;

  /// All composers dropdown option
  ///
  /// In en, this message translates to:
  /// **'All composers'**
  String get allComposers;

  /// Quick filters section title
  ///
  /// In en, this message translates to:
  /// **'Quick filters'**
  String get quickFilters;

  /// Filter for tablatures with MIDI
  ///
  /// In en, this message translates to:
  /// **'With MIDI'**
  String get withMidi;

  /// Filter for tablatures with LHF
  ///
  /// In en, this message translates to:
  /// **'With LHF'**
  String get withLhf;

  /// Filter for tablatures with video
  ///
  /// In en, this message translates to:
  /// **'With Video'**
  String get withVideo;

  /// Filter for easy tablatures
  ///
  /// In en, this message translates to:
  /// **'Easy'**
  String get easyTablatures;

  /// Message when filter is applied
  ///
  /// In en, this message translates to:
  /// **'Filter \"{filter}\" applied'**
  String filterApplied(String filter);

  /// Message to go to favorites tab
  ///
  /// In en, this message translates to:
  /// **'Go to Favorites tab to see your favorites'**
  String get goToFavoritesTab;

  /// Error message when loading favorites fails
  ///
  /// In en, this message translates to:
  /// **'Error loading favorites: {error}'**
  String errorLoadingFavorites(String error);

  /// Number of favorites
  ///
  /// In en, this message translates to:
  /// **'{count} Favorites'**
  String favoritesCount(int count);

  /// Clear all button
  ///
  /// In en, this message translates to:
  /// **'Clear all'**
  String get clearAll;

  /// Remove all favorites dialog title
  ///
  /// In en, this message translates to:
  /// **'Remove all favorites'**
  String get removeAllFavorites;

  /// Confirmation message for removing all favorites
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove all tablatures from favorites? This action cannot be undone.'**
  String get removeAllFavoritesConfirm;

  /// Remove all button
  ///
  /// In en, this message translates to:
  /// **'Remove all'**
  String get removeAll;

  /// Message when all favorites are removed
  ///
  /// In en, this message translates to:
  /// **'All favorites have been removed'**
  String get allFavoritesRemoved;

  /// Error message when removing favorites fails
  ///
  /// In en, this message translates to:
  /// **'Error removing favorites: {error}'**
  String errorRemovingFavorites(String error);

  /// App information section title
  ///
  /// In en, this message translates to:
  /// **'App Information'**
  String get appInfo;

  /// App name label
  ///
  /// In en, this message translates to:
  /// **'App Name'**
  String get appName;

  /// Developer label
  ///
  /// In en, this message translates to:
  /// **'Developer'**
  String get developer;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'it'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'it':
      return AppLocalizationsIt();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
