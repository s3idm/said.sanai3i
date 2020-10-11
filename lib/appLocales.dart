import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocale{
  Locale locale ;
  AppLocale({this.locale}) ;

  Map<String , String > _translation ;

 static AppLocale of (BuildContext context ){
   return Localizations.of(context, AppLocale) ;
 }

 Future loadTranslation() async {
  String langFile = await rootBundle.loadString('langs/${locale.languageCode}.json') ;
  Map<String,dynamic > loadedValues  = await jsonDecode(langFile) ;
  _translation =  loadedValues.map((key, value) => MapEntry(key, value.toString()));
 }

  String getTranslation(String key){
    return _translation[key] ;
  }

 static const LocalizationsDelegate<AppLocale> delegate = _AppLocaleDelegate();

}


class _AppLocaleDelegate extends LocalizationsDelegate<AppLocale> {
  const _AppLocaleDelegate() ;

  @override
  bool isSupported(Locale locale) {
    return ['en' , 'ar'].contains(locale.languageCode) ;
  }

  @override
  Future<AppLocale> load(Locale locale) async  {
    AppLocale appLocale = AppLocale(locale: locale);
    await appLocale.loadTranslation();
    return appLocale ;

  }

  @override
  bool shouldReload(LocalizationsDelegate old) => false ;

}