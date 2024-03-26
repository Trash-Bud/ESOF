import 'package:flutter/cupertino.dart';

class LanguageChangeProvider extends ChangeNotifier{

  Locale _currentLocale = const Locale('pt');
  void changeLocale(){
    if( _currentLocale == Locale('pt')){
      _currentLocale = Locale('en');
    }else{
      _currentLocale = Locale('pt');
    }
    notifyListeners();
  }
  Locale getCurrentLocale(){
    return _currentLocale;
  }

}