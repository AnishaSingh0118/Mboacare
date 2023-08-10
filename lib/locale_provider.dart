import 'package:flutter/material.dart';

class LocaleProvider with ChangeNotifier {
  Locale _locale = Locale('en', 'US'); // Default locale is English

  Locale get locale => _locale;

  set locale(Locale locale) {
    _locale = locale;
    notifyListeners();
  }
}
