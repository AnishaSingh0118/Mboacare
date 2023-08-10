import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  get dashboardPageHome => null;

  get dashboardPageHospitalDashboard => null;

  get dashboardPageSettings => null;

  get dashboardPageProfile => null;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  // Define your translations here
  String get settingsPageTitle {
    return Intl.message('Settings Page', name: 'settingsPageTitle');
  }

  // Translations for Hindi
  String get settingsPageTitle_hi {
    return Intl.message('सेटिंग्स पेज', name: 'settingsPageTitle_hi');
  }

  // Translations for Spanish
  String get settingsPageTitle_es {
    return Intl.message('Página de configuración',
        name: 'settingsPageTitle_es');
  }

  // Translations for French
  String get settingsPageTitle_fr {
    return Intl.message('Page de paramètres', name: 'settingsPageTitle_fr');
  }

  profilePageGreeting(String userName) {
    return Intl.message('Page de paramètres', name: 'settingsPageTitle_fr');
  }
}

String get dashboardPageHome {
  return Intl.message('Home', name: 'dashboardPageHome');
}

String get dashboardPageHospitalDashboard {
  return Intl.message('Hospital Dashboard',
      name: 'dashboardPageHospitalDashboard');
}

String get dashboardPageSettings {
  return Intl.message('Settings', name: 'dashboardPageSettings');
}

String get dashboardPageProfile {
  return Intl.message('Profile', name: 'dashboardPageProfile');
}

String profilePageGreeting(String userName) {
  return Intl.message('Hello, $userName!',
      name: 'profilePageGreeting', args: [userName]);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    // Add the supported language codes here
    return ['en', 'hi', 'es', 'fr'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return Future.value(AppLocalizations(locale));
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) {
    return false;
  }
}
