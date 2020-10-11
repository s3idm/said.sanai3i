import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:sanai3i/appLocales.dart';
import 'package:sanai3i/files/database.dart';
import 'package:sanai3i/files/reusable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'files/mainNavigation.dart';
import 'package:sanai3i/files/landing.dart';

String selectedCode ;


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Sanai3i());
}

class Sanai3i extends StatefulWidget {


  @override
  _Sanai3iState createState() => _Sanai3iState();
}


class _Sanai3iState extends State<Sanai3i> {



  @override
  void initState() {
    loadLang().then((value) {
      if(value != null )
        setState(() {
          selectedCode = value ;
        });
    });
    super.initState();
  }

  Future<String> loadLang() async {
    SharedPreferences getLangCode = await SharedPreferences.getInstance() ;
    return getLangCode.getString('langCode') ;
  }
  Future<bool> saveLang(String code) async {
    SharedPreferences saveLangCode = await SharedPreferences.getInstance() ;
    return await saveLangCode.setString('langCode', code);
  }

  @override
  Widget build(BuildContext context) {

    return selectedCode != null
        ?  GestureDetector(
      onTap: (){
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasFocus) {
          currentFocus.unfocus();
        }
      },
      child: StreamProvider<User>.value(
        value: DatabaseService().userState,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'صنايعي',
          theme: ThemeData(fontFamily: 'TajawalRegular'),
          home: selectedCode != null ? Wrapper() : Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FadeY(
                    delay: 0.0,
                    duration: Duration(milliseconds: 350),
                    child: AnimatedContainer(
                      curve: Curves.easeOutBack,
                      height: 150,
                      duration: Duration(milliseconds: 400),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('images/sanai3i.png', ),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  FadeX(
                    delay: 0.1,
                    duration: Duration(milliseconds: 300),
                    child: Container(
                      width: 200,
                      child: RaisedButton(
                        color: kActiveBtnColor,
                        shape: StadiumBorder(),
                        child: Text('العربية',style: TextStyle(color: Colors.white),),
                        onPressed:(){
                          setState(() {
                            saveLang('ar');
                            selectedCode = 'ar';
                          });
                        },
                      ),
                    ),
                  ),
                  FadeX(
                    delay: 0.2,
                    duration: Duration(milliseconds: 300),
                    child: Container(
                      width: 200,
                      child: RaisedButton(
                        color: kActiveBtnColor,
                        shape: StadiumBorder(),
                        child: Text('English',style: TextStyle(color: Colors.white),),
                        onPressed:(){
                          setState(() {
                            saveLang('en');
                            selectedCode = 'en';
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          supportedLocales: [Locale('ar' , ''), Locale('en' , ''),],
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            AppLocale.delegate
          ],
          localeResolutionCallback: (currentLocale , supportedLocales){
            if(selectedCode != null ){
              return  Locale(selectedCode ,'');
            }else{
              print('else');
              if(currentLocale != null ){
                for(Locale locale in supportedLocales ){
                  if(locale.languageCode == currentLocale.languageCode)
                    return currentLocale ;
                }
              }
              if(supportedLocales.contains(currentLocale )){
                return currentLocale ;
              }
              else return  supportedLocales.first;
            }
          },
        ),
      ),
    ): MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'TajawalRegular'),
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FadeY(
                delay: 0.0,
                duration: Duration(milliseconds: 350),
                child: AnimatedContainer(
                  curve: Curves.easeOutBack,
                  height: 150,
                  duration: Duration(milliseconds: 400),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('images/sanai3i.png', ),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              FadeX(
                delay: 0.1,
                duration: Duration(milliseconds: 300),
                child: Container(
                  width: 200,
                  child: RaisedButton(
                    color: kActiveBtnColor,
                    shape: StadiumBorder(),
                    child: Text('العربية',style: TextStyle(color: Colors.white),),
                    onPressed:(){
                      setState(() {
                        saveLang('ar');
                        selectedCode = 'ar';
                      });
                    },
                  ),
                ),
              ),
              FadeX(
                delay: 0.2,
                duration: Duration(milliseconds: 300),
                child: Container(
                  width: 200,
                  child: RaisedButton(
                    color: kActiveBtnColor,
                    shape: StadiumBorder(),
                    child: Text('English',style: TextStyle(color: Colors.white),),
                    onPressed:(){
                      setState(() {
                        saveLang('en');
                        selectedCode = 'en';
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    final userState = Provider.of<User>(context);
    if (userState == null) {  return LoginScreen();    }
    if (userState != null) {  return MainNavigation(); }

    return Material(
      child: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Image.asset('images/logo.png'),),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Center(
                child: CircularProgressIndicator(),),
            ),
            Center(
              child: Text('تأكد من اتصالك'),),
          ],
        ),
      ),
    );
  }
}
