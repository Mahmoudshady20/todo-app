import 'package:flutter/material.dart';
import 'package:todo/shared_prefrences/shared_prrefrences.dart';

class SettingsProvider extends ChangeNotifier{
  ThemeMode themeMode = ThemeMode.system;
  Locale myLocal = Locale('ar');

  void init(){
    if(SharedPrefs.getTheme()=='dark'){
      themeMode = ThemeMode.dark;
    }else {
      themeMode = ThemeMode.light;
    }
    if(SharedPrefs.getlan()=='ar'){
      myLocal = Locale('ar');
    }else {
      myLocal = Locale('en');
    }
  }

  void enableLightMode(){
    themeMode = ThemeMode.light;
    SharedPrefs.setTheme("light");
    notifyListeners();
  }
  void enableDarkMode(){
    themeMode = ThemeMode.dark;
    SharedPrefs.setTheme("dark");
    notifyListeners();
  }

  void enableArabic(){
    myLocal = Locale('ar');
    SharedPrefs.setlan('ar');
    notifyListeners();
  }
  void enableEnglish(){
    myLocal = Locale('en');
    SharedPrefs.setlan('en');
    notifyListeners();
  }

}
