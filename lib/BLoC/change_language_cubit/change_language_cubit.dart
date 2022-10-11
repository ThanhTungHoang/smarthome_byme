import 'dart:developer';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'change_language_state.dart';

class ChangeLanguageCubit extends Cubit<Locale> {
  ChangeLanguageCubit() : super(const Locale("en", "US"));
  Future<void> getLanguage() async {
    final String defaultLocale = Platform.localeName;
    log("locale: $defaultLocale");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? langCode = prefs.getString('languageCode');
    String? coutryCode = prefs.getString('countryCode');
    print(langCode);
    if (langCode == null && coutryCode == null) {
      if (defaultLocale == "vi_VN") {
        // print("vietnam null");
        emit(const Locale("vi", "VN"));
      }
    } else {
      if (langCode == "vi_VN") {
        // print("vietnam");
        emit(const Locale("vi", "VN"));
      } else {
        // print("english");
        emit(const Locale("en", "US"));
      }
    }
  }

  Future<void> changeLanguage(
      {required String languageCode, required String countryCode}) async {
  
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', languageCode);
    await prefs.setString('countryCode', countryCode);
   emit(Locale(languageCode, countryCode));
  }
}
