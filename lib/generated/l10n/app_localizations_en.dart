// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'ClassTab Catalog';

  @override
  String get home => 'Home';

  @override
  String get search => 'Search';

  @override
  String get composers => 'Composers';

  @override
  String get favorites => 'Favorites';

  @override
  String get syncWithClassTab => 'Sync with ClassTab.org';

  @override
  String get synchronization => 'Synchronization';

  @override
  String get syncDialogContent =>
      'Do you want to sync tablatures with ClassTab.org? This will download all the latest data (about 13MB).';

  @override
  String get cancel => 'Cancel';

  @override
  String get sync => 'Sync';

  @override
  String get loadingTablatures => 'Loading tablatures...';

  @override
  String get retry => 'Retry';

  @override
  String get noTablaturesFound => 'No tablatures found';

  @override
  String get syncToDownloadTablatures =>
      'Sync with ClassTab.org to download tablatures';

  @override
  String get syncNow => 'Sync now';

  @override
  String get recentTablatures => 'Recent Tablatures';

  @override
  String viewAllTablatures(int count) {
    return 'View all $count tablatures';
  }

  @override
  String get youTubeVideo => 'YouTube Video';

  @override
  String get settings => 'Settings';

  @override
  String get searchTablatures => 'Search tablatures...';

  @override
  String get composer => 'Composer';

  @override
  String get title => 'Title';

  @override
  String get difficulty => 'Difficulty';

  @override
  String get all => 'All';

  @override
  String get easy => 'Easy';

  @override
  String get medium => 'Medium';

  @override
  String get hard => 'Hard';

  @override
  String get expert => 'Expert';

  @override
  String get clearFilters => 'Clear filters';

  @override
  String get noResults => 'No results found';

  @override
  String get tryDifferentSearch =>
      'Try a different search term or clear the filters';

  @override
  String get totalTablatures => 'Total tablatures';

  @override
  String get totalComposers => 'Total composers';

  @override
  String get favoriteTablatures => 'Favorite tablatures';

  @override
  String get lastSync => 'Last sync';

  @override
  String get never => 'Never';

  @override
  String get addToFavorites => 'Add to favorites';

  @override
  String get removeFromFavorites => 'Remove from favorites';

  @override
  String get viewTablature => 'View tablature';

  @override
  String get playMidi => 'Play MIDI';

  @override
  String get watchOnYouTube => 'Watch on YouTube';

  @override
  String get noFavorites => 'No favorites yet';

  @override
  String get addFavoritesMessage =>
      'Add some tablatures to your favorites to see them here';

  @override
  String get browseTablatures => 'Browse tablatures';

  @override
  String tablaturesByComposer(String composer) {
    return 'Tablatures by $composer';
  }

  @override
  String get noTablaturesForComposer => 'No tablatures found for this composer';

  @override
  String get midiSettings => 'MIDI Settings';

  @override
  String get enableMidi => 'Enable MIDI playback';

  @override
  String get midiVolume => 'MIDI volume';

  @override
  String get generalSettings => 'General Settings';

  @override
  String get language => 'Language';

  @override
  String get theme => 'Theme';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get system => 'System';

  @override
  String get about => 'About';

  @override
  String get version => 'Version';

  @override
  String get aboutApp => 'About the app';

  @override
  String get appDescription =>
      'A Flutter application for cataloging and viewing classical guitar tablatures from ClassTab.org';

  @override
  String get loading => 'Loading...';

  @override
  String get error => 'Error';

  @override
  String get ok => 'OK';

  @override
  String get close => 'Close';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get confirm => 'Confirm';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get filters => 'Filters';

  @override
  String get startSearching => 'Start searching for tablatures';

  @override
  String get tryDifferentTerms => 'Try different search terms';

  @override
  String resultsCount(int count) {
    return '$count results';
  }

  @override
  String get clearAllFilters => 'Clear filters';

  @override
  String get allComposers => 'All composers';

  @override
  String get quickFilters => 'Quick filters';

  @override
  String get withMidi => 'With MIDI';

  @override
  String get withLhf => 'With LHF';

  @override
  String get withVideo => 'With Video';

  @override
  String get easyTablatures => 'Easy';

  @override
  String filterApplied(String filter) {
    return 'Filter \"$filter\" applied';
  }

  @override
  String get goToFavoritesTab => 'Go to Favorites tab to see your favorites';

  @override
  String errorLoadingFavorites(String error) {
    return 'Error loading favorites: $error';
  }

  @override
  String favoritesCount(int count) {
    return '$count Favorites';
  }

  @override
  String get clearAll => 'Clear all';

  @override
  String get removeAllFavorites => 'Remove all favorites';

  @override
  String get removeAllFavoritesConfirm =>
      'Are you sure you want to remove all tablatures from favorites? This action cannot be undone.';

  @override
  String get removeAll => 'Remove all';

  @override
  String get allFavoritesRemoved => 'All favorites have been removed';

  @override
  String errorRemovingFavorites(String error) {
    return 'Error removing favorites: $error';
  }

  @override
  String get appInfo => 'App Information';

  @override
  String get appName => 'App Name';

  @override
  String get developer => 'Developer';
}
