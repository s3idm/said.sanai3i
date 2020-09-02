import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sanai3i/files/reusable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'database.dart';
import 'settings.dart';


class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}
class _LoginState extends State<Login> {

  String _phone,_token;
  String errorDetails ='';
  bool nameValidationError=false;
  bool phoneValidationError=false;
  bool mo7afzaValidationError=false;
  bool firebaseNetError=false;
  bool firebasePhoneFormatError=false;
  bool jopValidationError=false;
  bool shopValidationError=false;
  bool invalidToken=false;
  bool isRegistered = false ;
  bool dbError = false;
  int bottomIndex = 1;
  int selectedAccountTypeIndex = 0;
  FirebaseUser user;
  String cCode  ;
  var _formKey = GlobalKey<FormState>();

Future loginWithPhone (String phone ) async{
  FirebaseAuth _auth = FirebaseAuth.instance;
  _auth.verifyPhoneNumber(
    phoneNumber: '$cCode$_phone',
    timeout: Duration(seconds: 120),

    verificationCompleted: (AuthCredential authCred ) async {
      await _auth.signInWithCredential(authCred);

      Navigator.pop(context);
      },

    verificationFailed: (AuthException authException ){
      if (authException.message == 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.'){
        setState(() {
          firebaseNetError = true;
          loading=false;
        } );
      }
      if (authException.code == 'invalidCredential'){
        setState( ()  {
          phoneValidationError = true;
          errorDetails = lang(context , 'phoneNotCorrect');
          loading =false;
        });
      }
    },
    codeSent: (String verificationId ,[int forceResendToken] ){
      setState(()=>loading=false);
      showModal(
        context: context,
        builder: (context){
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Center(child: Text(lang(context,'validation'))),
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState){
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextFieldReusable(
                      hintOfTextFiled: lang(context,'validationKey'),
                      onChanged: (token)  => _token = token,
                      keyboardType: TextInputType.phone,
                      length: 6,
                    ),
                    invalidToken == true ?
                    Text(lang(context,'ensureKey')):
                    SizedBox(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        RaisedButton(
                          onPressed: (){
                            Navigator.pop(context);
                          },
                          color: kActiveBtnColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                          child: Text(lang(context,'cancel'), style: TextStyle(fontSize: 14, color: Colors.white),),
                        ),
                        RaisedButton(
                          color: kActiveBtnColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                          child: Text(lang(context,'checkKey'), style: TextStyle(fontSize: 14, color: Colors.white),),
                          onPressed: () async {
                            setState(()  {
                              loading = true;
                              Future.delayed(Duration(seconds: 3 )).then((value) => loading = false );
                            });
                            try{
                              AuthCredential credential = PhoneAuthProvider.getCredential(verificationId:verificationId , smsCode: _token);
                              AuthResult result = await _auth.signInWithCredential(credential);
                              if (result.user != null){
                                Navigator.pop(context);
                              }
                            }
                            catch (e){
                              setState((){
                                invalidToken = true;
                                loading =false;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                    loading == true ?
                    CircularProgressIndicator():
                    SizedBox(),
                  ],
                );
              },
            ),
          );
        }
      );
    },
    codeAutoRetrievalTimeout: null,
  );
}

  @override
  Widget build(BuildContext context) {
    var screenData = MediaQuery.of(context);
    return Expanded(
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 60),
              FadeY(
                duration: Duration(milliseconds: 200),
                delay: 0.2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 35,
                      width: 55,
                      decoration: roundedContainerDecoration(kActiveBtnColor),
                      child: CountryCodePicker(
                        onChanged: (code){
                          cCode = code.dialCode ;
                          print(cCode);
                        },
                        showFlag: false,
                        hideSearch: true,
                        textStyle: TextStyle(color: Colors.white),
                        initialSelection: 'SA',
                        favorite: ['SA', 'EG' , 'AE','SY','OM'],
                        //countryFilter: ['SA', 'EG' , 'AE','SY','OM','MC','KW','JO','IR','IQ','PS','QA','BH','YE','TN','DZ','LB','LY'],
                        showFlagDialog: true,
                        comparator: (a, b) => b.name.compareTo(a.name),
                        onInit: (code) {
                          cCode = code.dialCode ;
                        },
                      ),
                    ),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 250),
                      width: screenData.size.width*.7,
                      child: TextFieldReusable(
                        hintOfTextFiled: lang(context,'phone'),
                        onSaved: (_phoneSignup)  {
                          _phone = "$_phoneSignup";
                          print(_phone);
                          },
                        keyboardType: TextInputType.phone,
                        length: 50,
                        validator: (String value) {  setState(() {
                          value.isEmpty ? phoneValidationError = true :phoneValidationError = false;
                        });},
                      ),
                    ),
                  ],
                ),
              ),
              phoneValidationError == false ? SizedBox():Text(errorDetails,style: TextStyle(color: Colors.red),),
              firebasePhoneFormatError == false ? SizedBox():Text(lang(context,'phoneNotCorrect'),style: TextStyle(color: Colors.red),),
              FadeY(
                duration: Duration(milliseconds: 200),
                delay: 0.4,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 250),
                  width: 120,
                  height: 35,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                    color: kActiveBtnColor,
                    onPressed: () async {
                      _formKey.currentState.validate();
                      if ( phoneValidationError == false) {
                        _formKey.currentState.save();
                        loading = true;
                        Future.delayed(Duration(seconds: 3)).then((value) {setState(() {loading = false ;});});
                        try{
                          await DatabaseService().ifAPhoneNumberRegistered(_phone).then( (QuerySnapshot doc) {
                            if (doc.documents.isEmpty) {
                              setState(() {
                                phoneValidationError = true ;
                                errorDetails = lang(context, 'notRegistered');
                                loading = false ;
                              });
                            }
                            else if (doc.documents.isNotEmpty){
                              loginWithPhone(_phone);
                            }
                            else if (doc == null ){
                              loading = false ;
                              print('doc is null *******');
                            }
                          });
                        }catch(e){
                          setState(() {
                            loading = false ;
                            firebaseNetError = true ;
                            errorDetails = lang(context, 'checkConnection');
                          });
                          print('******** $e');
                        }
                      }
                    },
                    child: Center(
                      child:loading == false ?
                      Text(lang(context, 'login'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),) :
                      AnimatedContainer(
                        duration: Duration(milliseconds: 250),
                        padding: EdgeInsets.all(5),
                        child: CircularProgressIndicator()
                      ),
                    ),
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


class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  String _phone,_name,_token,_jop,_shop;
  String _accountTypeSelected;
  String _selectedJop;
  String _selectedShop;
  String errorDetails ='';
  bool nameValidationError=false;
  bool phoneValidationError=false;
  bool phoneIsRegistered=false;
  bool firebaseNetError=false;
  bool firebasePhoneFormatError=false;
  bool jopValidationError=false;
  bool shopValidationError=false;
  bool invalidToken=false;
  bool isRegistered = false ;
  bool dbError = false;
  int bottomIndex = 1;
  int selectedAccountTypeIndex = 0;
  AnimationController animationController;
  Animation animation ;
  FirebaseUser user;
  String cCode  ;
  var _formKey = GlobalKey<FormState>();

Future signupWithPhone (String phone) async {
  setState(() {
    firebaseNetError=false;
    firebasePhoneFormatError=false;
  });
  FirebaseAuth _auth = FirebaseAuth.instance;
  _auth.verifyPhoneNumber(
    phoneNumber: "$cCode$_phone",
    timeout: Duration(seconds: 120),

      verificationCompleted: null ,
      //     (AuthCredential authCreds)async {
      //
      // final result = await _auth.signInWithCredential(authCreds);
      // user = result.user ;
      // if (user!= null) DatabaseService().addRegisteredPhoneNumber(_phone);
      // if (_accountTypeSelected=='عميل')
      //   await DatabaseService(uid: user.uid).createNewUser(_name,null,_phone,null,null,true,[],user.uid,null,null,[],cCode);
      // if (_accountTypeSelected=='صنايعي')
      //   await DatabaseService(uid: user.uid).createNewUser(_name,_jop,_phone,0.toString(),null,true,[],user.uid,null,[],[],cCode);
      // if (_accountTypeSelected=='محلات')
      //   await DatabaseService(uid: user.uid).createNewUser(_name,_shop,_phone,0.toString(),null,true,[],user.uid,null,[],[],cCode);
      // if (user != null )
      //
      // },
      verificationFailed: (AuthException authException ){
        if (authException.message == 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.'){
          setState(() {
            firebaseNetError = true;
            loading=false;
          } );
        }
        if (authException.code == 'invalidCredential'){
          setState( ()  {
            firebasePhoneFormatError = true;
            loading =false;
          });
        }
      },
      codeSent: (String verificationId ,[int forceResendToken] ){
        setState(()=>loading=false);
        showModal(
          context: context,
          builder: (context){
            return AlertDialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                title: Center(child: Text(lang(context, 'validation'))),
                content: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState){
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TextFieldReusable(
                          hintOfTextFiled:lang(context, 'validationKey'),
                          onChanged: (token)  => _token = token,
                          keyboardType: TextInputType.phone,
                          length: 6,
                        ),
                        invalidToken == true ? Text(lang(context, 'ensureKey')) : SizedBox(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            RaisedButton(
                              onPressed: (){
                                invalidToken = false ;
                                Navigator.pop(context);
                              },
                              color: kActiveBtnColor,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                              child: Text(lang(context, 'cancel'), style: TextStyle(fontSize: 14, color: Colors.white),),
                            ),
                            RaisedButton(
                              color: kActiveBtnColor,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                              child: Text(lang(context, 'checkKey'), style: TextStyle(fontSize: 14, color: Colors.white),),
                              onPressed: () async {
                                setState(()  {
                                  loading =true;
                                  Future.delayed(Duration(seconds: 3 )).then((value) => loading = false );
                                });
                                try{
                                  AuthCredential credential = PhoneAuthProvider.getCredential(verificationId:verificationId , smsCode: _token);
                                  AuthResult result = await _auth.signInWithCredential(credential);
                                  user = result.user ;
                                  if (user!=null) DatabaseService().addRegisteredPhoneNumber(_phone);
                                  if (_accountTypeSelected==lang(context, 'client'))
                                    await DatabaseService(uid: user.uid).createNewUser(_name,null,_phone,null,null,true,[],user.uid,null,null,[],cCode);
                                  if (_accountTypeSelected==lang(context, 'worker'))
                                    await DatabaseService(uid: user.uid).createNewUser(_name,_jop,_phone,'0',null,true,[],user.uid,null,[],[],cCode);
                                  if (_accountTypeSelected==lang(context, 'shop'))
                                    await DatabaseService(uid: user.uid).createNewUser(_name,_shop,_phone,'0',null,true,[],user.uid,null,[],[],cCode);
                                  if (user != null){
                                    Navigator.pop(context);
                                  }
                                }
                                catch (e){
                                  setState((){
                                    invalidToken = true;
                                    loading =false;
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                        loading == true ? CircularProgressIndicator() :SizedBox(),
                      ],
                    );
                  },
                )
            );
          }
        );
      },
      codeAutoRetrievalTimeout: null
  );
}

  @override
  Widget build(BuildContext context) {
    var screenData = MediaQuery.of(context);

    Widget _buildExtra (BuildContext context) {
      switch (selectedAccountTypeIndex){
        case 0:
          return SizedBox(height: 0);
        case 1:
          return FadeY(
            delay: 0.0,
            duration: Duration(milliseconds: 200),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 250),
              width: 120,
              margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
              height: 35,
              child: RaisedButton(
                onPressed: () async {
                  _formKey.currentState.validate();
                  if (nameValidationError == false && phoneValidationError == false)  {
                    _formKey.currentState.save();
                    loading = true;

                    Future.delayed(Duration(seconds: 3)).then((value) {setState(() {loading = false ;});});
                    try{
                      await DatabaseService().ifAPhoneNumberRegistered(_phone).then( (QuerySnapshot doc) {
                        if (doc.documents.isEmpty) {
                          setState(() {
                            // phoneValidationError = true ;
                            // errorDetails = 'رقم الهاتف غير مسجل';
                            signupWithPhone(_phone);
                            loading = false ;
                          });
                        }
                        else if (doc.documents.isNotEmpty){
                          phoneValidationError = true ;
                          firebasePhoneFormatError = false ;
                          errorDetails = lang(context, 'isRegistered');
                        }
                        else if (doc == null ){
                          loading = false ;
                          print('doc is null *******');
                        }
                      });
                    }catch(e){
                      setState(() {
                        loading = false ;
                        firebaseNetError = true ;
                        errorDetails = lang(context, 'checkConnection');
                      });
                      print('******** $e');
                    }
                    //signupWithPhone(_phone );
                  }
                },
                color: kActiveBtnColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                child: loading == false
                    ? Text(lang(context, 'signup'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),)
                    : Container(
                  padding: EdgeInsets.all(5),
                  child: CircularProgressIndicator(),),
              ),
            ),
          );
        case 2:
          return FadeY(
            delay: 0.0,
            duration: Duration(milliseconds: 200),
            child: Column(
              children: <Widget>[
                AnimatedContainer(
                  height: 35,
                  width: screenData.size.width*.7-(20),
                  decoration:roundedContainerDecoration(kActiveBtnColor),
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  duration: Duration(milliseconds: 250),
                  child: Center(
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        items: jopList.map((JopShopTile jop) {
                          return DropdownMenuItem<String>(
                            value: jop.nameAr,
                            child: Center(child: Text(lang(context, '${jop.nameAr}'), style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 13),),),
                          );
                        }).toList(),
                        onChanged: (String jop) {
                          setState(() {
                            _selectedJop = jop;
                            _jop = jop;
                          });
                        },
                        icon: Icon(Icons.arrow_drop_down, color: Colors.white,),
                        hint: Center(child: _jop == null ? Text(
                            lang(context, 'jop'), style: TextStyle(color: Colors.grey)) : Text(
                            '$_jop', style: TextStyle(color: Colors.white))),
                        isExpanded: true,
                      ),
                    ),
                  ),
                ),
                jopValidationError == false ? SizedBox() : Text(
                  lang(context, 'selectJop'), style: TextStyle(color: Colors.red),),
                AnimatedContainer(
                  width: 120,
                  height: 35,
                  duration: Duration(milliseconds: 250),
                  child: RaisedButton(
                    onPressed: () async {
                      setState(() {
                        if (_selectedJop == null) {
                          jopValidationError = true;
                        }
                        if (_selectedJop != null) {
                          jopValidationError = false;
                        }
                      });
                      _formKey.currentState.validate();
                      if (nameValidationError == false && phoneValidationError == false && _jop != null) {
                        _formKey.currentState.save();
                        loading = true;
                        Future.delayed(Duration(seconds: 2)).then((value) {setState(() {loading = false ;});});
                        try{
                          await DatabaseService().ifAPhoneNumberRegistered(_phone).then( (QuerySnapshot doc) {
                            if (doc.documents.isEmpty) {
                              setState(() {
                                // phoneValidationError = true ;
                                // errorDetails = 'رقم الهاتف غير مسجل';
                                signupWithPhone(_phone);
                                loading = false ;
                              });
                            }
                            else if (doc.documents.isNotEmpty){
                              phoneValidationError = true ;
                              errorDetails = lang(context, 'isRegistered');
                              firebasePhoneFormatError = false ;
                            }
                            else if (doc == null ){
                              loading = false ;
                              print('doc is null *******');
                            }
                          });
                        }catch(e){
                          setState(() {
                            loading = false ;
                            firebaseNetError = true ;
                            errorDetails = lang(context, 'checkConnection');
                          });
                          print('******** $e');
                        }
                        //signupWithPhone(_phone);
                      }
                    },
                    color: kActiveBtnColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    child: loading == false
                        ? Text(lang(context, 'signup'), style: TextStyle(fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),)
                        : Container(
                      padding: EdgeInsets.all(5),
                      child: CircularProgressIndicator(),),
                  ),
                ),
              ],
            ),
          );
        case 3:
          return FadeY(
            duration: Duration(milliseconds: 200),
            delay: 0.0,
            child: Column(
              children: <Widget>[
                AnimatedContainer(
                  height: 35,
                  width: screenData.size.width*.7-(20),
                  decoration:roundedContainerDecoration(kActiveBtnColor),
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  duration: Duration(milliseconds: 250),
                  child: Center(
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        items: shopsList.map((JopShopTile shop) {
                          return DropdownMenuItem<String>(
                            value: shop.nameAr,
                            child: Center(child: Text(lang(context, '${shop.nameAr}'), style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 13),),),
                          );
                        }).toList(),
                        onChanged: (String shop) {
                          setState(() {
                            _selectedShop=shop;
                            _shop = shop;
                          });
                        },
                        icon: Icon(Icons.arrow_drop_down, color: Colors.white,),
                        hint: Center(child: _selectedShop == null
                            ?Text(lang(context, 'myShop'),style: TextStyle(color: Colors.grey))
                            :Text('$_selectedShop',style: TextStyle(color: Colors.white))),
                        isExpanded: true,
                      ),
                    ),
                  ),
                ),
                shopValidationError == false ? SizedBox():Text(lang(context, 'selectShop'),style: TextStyle(color: Colors.red),),
                AnimatedContainer(
                  duration: Duration(milliseconds: 250),
                  width: 120,
                  height: 35,
                  child: RaisedButton(
                    onPressed: () async {
                      setState(() {
                        if (_selectedShop == null){
                          shopValidationError = true;
                        }
                        if (_selectedShop != null){
                          shopValidationError = false;
                        }
                      });
                      _formKey.currentState.validate();
                      if (nameValidationError == false && phoneValidationError == false  && _shop!=null) {
                        _formKey.currentState.save();
                        loading = true;
                        Future.delayed(Duration(seconds: 3)).then((value) {setState(() {loading = false ;});});
                        try{
                          await DatabaseService().ifAPhoneNumberRegistered(_phone).then( (QuerySnapshot doc) {
                            if (doc.documents.isEmpty) {
                              setState(() {
                                signupWithPhone(_phone);
                                loading = false ;
                              });
                            }
                            else if (doc.documents.isNotEmpty){
                              phoneValidationError = true ;
                              firebasePhoneFormatError = false ;
                              errorDetails = lang(context, 'isRegistered');
                            }
                            else if (doc == null ){
                              loading = false ;
                              print('doc is null *******');
                            }
                          });
                        }catch(e){
                          setState(() {
                            loading = false ;
                            firebaseNetError = true ;
                            errorDetails = lang(context, 'checkConnection');
                          });
                          print('******** $e');
                        }
                        //signupWithPhone(_phone );
                      }
                    },
                    color: kActiveBtnColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                    child: loading == false
                        ? Text(lang(context, 'signup'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),)
                        : AnimatedContainer(
                      padding: EdgeInsets.all(5),
                      duration: Duration(milliseconds: 250),
                      child: CircularProgressIndicator(),),
                  ),
                ),
              ],
            ),
          );
        default :
          return Text('Error 404');
      }
    }

    return Expanded(  
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              firebaseNetError == false ?SizedBox(height: 10) :Text(lang(context, 'checkConnection'),style: TextStyle(color: Colors.red),),
              FadeY(
                duration: Duration(milliseconds: 200),
                delay: 0.0,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 250),
                  width: screenData.size.width*.7,
                  child: TextFieldReusable(
                    hintOfTextFiled: lang(context, 'name'),
                    onSaved: (_nameSignup) => _name  = _nameSignup,
                    keyboardType: TextInputType.text ,
                    length: 40,
                    validator: (String value) { setState(() {
                      value.isEmpty ? nameValidationError=true :nameValidationError=false;
                    });},
                  ),
                ),
              ),
              nameValidationError == false ? SizedBox():Text(lang(context, 'enterName'),style: TextStyle(color: Colors.red),),
              FadeY(
                duration: Duration(milliseconds: 200),
                delay: 0.2,
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 35,
                        width: 55,
                        decoration: roundedContainerDecoration(kActiveBtnColor),
                        child: CountryCodePicker(
                          onChanged: (code){
                            cCode = code.dialCode ;
                            print(cCode);
                          },
                          showFlag: false,
                          hideSearch: true,
                          textStyle: TextStyle(color: Colors.white),
                          initialSelection: 'SA',
                          favorite: ['SA', 'EG' , 'AE','SY','OM'],
                          //countryFilter: ['SA', 'EG' , 'AE','SY','OM','MC','KW','JO','IR','IQ','PS','QA','BH','YE','TN','DZ','LB','LY'],
                          showFlagDialog: true,
                          comparator: (a, b) => b.name.compareTo(a.name),
                          onInit: (code) {
                            cCode = code.dialCode ;
                          },
                        ),
                      ),
                      AnimatedContainer(
                        duration: Duration(milliseconds: 250),
                        width: screenData.size.width*.52,
                        child: TextFieldReusable(
                          hintOfTextFiled: lang(context, 'phone'),
                          onSaved: (_phoneSignup)  {
                            _phone = "$_phoneSignup";
                            print(_phone);
                          } ,
                          keyboardType: TextInputType.phone,
                          length: 50,
                          validator: (String value) {  setState(() {
                            value.isEmpty ? phoneValidationError = true : phoneValidationError = false;
                          });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              phoneValidationError == false ? SizedBox():Text(errorDetails,style: TextStyle(color: Colors.red),),
              firebasePhoneFormatError == false ?SizedBox() :Text(lang(context, 'phoneNotCorrect'),style: TextStyle(color: Colors.red),),
              FadeY(
                duration: Duration(milliseconds: 200),
                delay: 0.4,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 250),
                  height: 35,
                  width: screenData.size.width*.7-(20),
                  decoration:roundedContainerDecoration(kActiveBtnColor),
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  child: Center(
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        items: <String>[lang(context, 'client'), lang(context, 'worker'), lang(context, 'shop'),].map((String accountType) {
                          return DropdownMenuItem<String>(
                            value: accountType,
                            child: Center(child: Text(accountType, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 14),),),
                          );
                        }).toList(),
                        onChanged: (String accountType) {
                          setState(() {
                            _accountTypeSelected = accountType;
                            if      (_accountTypeSelected == lang(context, 'client'))
                              selectedAccountTypeIndex = 1;
                            else if (_accountTypeSelected == lang(context, 'worker'))
                              selectedAccountTypeIndex = 2;
                            else if (_accountTypeSelected == lang(context, 'shop'))
                              selectedAccountTypeIndex = 3;
                          });
                        },
                        icon: Icon(Icons.arrow_drop_down, color: Colors.grey,),
                        hint: Center(child: _accountTypeSelected == null
                            ?Text(lang(context, 'accType'),style: TextStyle(color: Colors.grey))
                            :Text('$_accountTypeSelected',style: TextStyle(color: Colors.white))),
                        isExpanded: true,
                        autofocus: false,
                      ),
                    ),
                  ),
                ),
              ),
              Container(child: _buildExtra(context),),
            ],
          ),
        ),
      ),
    );
  }
}
