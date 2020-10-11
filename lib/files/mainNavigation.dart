import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sanai3i/files/bookmark.dart';
import 'package:sanai3i/files/database.dart';
import 'package:sanai3i/files/home.dart';
import 'package:sanai3i/files/profile.dart';
import 'package:sanai3i/files/reusable.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:sanai3i/files/settings.dart';


int mainNavigationIndex = 1;
const String testDevise = 'testD' ;



class MainNavigation extends StatefulWidget {

  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> with SingleTickerProviderStateMixin{

  bool _dropdownMenuOpened = false , settings = false;
  String _scannedUId;

  @override
  initState() {
    super.initState();
    loading = false;
    DatabaseService().updateMyLocation();
  }


  @override
  void dispose() {
    super.dispose();
  }

  Future<String> scanQRCode()async {
    final scannedUID = await scanner.scan();
    setState(() {
      _scannedUId = scannedUID;
    });
    return _scannedUId;
  }

  onHomeBtnPressed(int index){
    setState(() {
      mainNavigationIndex = index ;
    });
  }


  @override
  Widget build(BuildContext context) {

    Widget _buildContent (BuildContext context) {
      switch (mainNavigationIndex){
        case 0:
          return BookmarkPage();
        case 1:
          return HomePage(onHomeBtnPressed: onHomeBtnPressed);
        case 2:
          return ProfilePage();
        case 3 :
          return CustomGridView(gridViewType: jopList);
        case 4 :
          return CustomGridView(gridViewType: shopsList);
        default :
          return Text('Error 404');
      }
    }

    return GestureDetector(
      onTap: (){
        setState(() {
          _dropdownMenuOpened = false;
          settings = false ;
        });
      },
      child: WillPopScope(
        onWillPop: () async {
          if(mainNavigationIndex == 3 || mainNavigationIndex == 4 ){
            setState(() {
              mainNavigationIndex = 1 ;
            });
            return false ;
          }
          else return true ;
        },
        child:
        Scaffold(
          backgroundColor:Color(0xffefefef),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(45.0),
            child: AppBar(
              backgroundColor: kActiveBtnColor,
              elevation: 5,
              centerTitle: true,
              title:mainNavigationIndex == 0 ? Text(lang(context, 'bookmark'),style: TextStyle(fontSize: 16),)
                : mainNavigationIndex == 1 ? Text(lang(context, 'home'),style: TextStyle(fontSize: 16),)
                : mainNavigationIndex == 2 ?Text(lang(context, 'profile'),style: TextStyle(fontSize: 16))
                : mainNavigationIndex == 3 ? Text(lang(context, 'worker'),style: TextStyle(fontSize: 16))
                : Text(lang(context, 'shop'),style: TextStyle(fontSize: 16)),
              actions: <Widget>[
                IconButton(
                  onPressed: () {
                    setState(()  {
                      _dropdownMenuOpened = !_dropdownMenuOpened;
                      settings = false ;
                    });
                  },
                  icon: Icon(Icons.more_vert,size: 16,),
                ),
              ],
            ),
          ),
          body: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Expanded(child: Center(child: _buildContent(context))),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      boxShadow:[BoxShadow(color: Colors.black.withOpacity(.1), spreadRadius: 1, blurRadius: 2, offset: Offset(-1, -1),),],
                    ),
                    padding: EdgeInsets.fromLTRB(5, 6, 5, 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: InkWell(
                            onTap: () { setState(() {mainNavigationIndex = 0;}); },
                            child: AnimatedContainer(
                              height: 35,
                              duration: Duration(milliseconds: 450),
                              curve: Curves.easeOutBack,
                              decoration: btnDecoration(mainNavigationIndex == 0 ? kActiveBtnColor : Colors.white,30),
                              child: mainNavigationIndex == 0 ? Image.asset('images/bookmark.png', scale: 4.0,) : Image.asset('images/bookmarkd.png', scale: 4.0,),
                            ),
                          ),
                        ),
                        SizedBox(width: 25,),
                        Expanded(
                          child: InkWell(
                           onTap:() {setState(() {mainNavigationIndex = 1;});},
                            child: AnimatedContainer(
                              height: 35,
                              duration: Duration(milliseconds: 450),
                              curve: Curves.easeOutBack,
                              decoration: btnDecoration(mainNavigationIndex == 1 ? kActiveBtnColor : Colors.white,30),
                              child: mainNavigationIndex == 1 ? Image.asset('images/home.png', scale: 4.0,) : Image.asset('images/homed.png', scale: 4.0,),
                            ),
                          ),
                        ),
                        SizedBox(width: 25,),
                        Expanded(
                          child: InkWell(
                            onTap: () {setState(() {mainNavigationIndex = 2;});},
                            child: AnimatedContainer(
                              height: 35,
                              duration: Duration(milliseconds: 450),
                              curve: Curves.easeOutBack,
                              decoration: btnDecoration(mainNavigationIndex == 2 ? kActiveBtnColor : Colors.white,30),
                              child: mainNavigationIndex == 2 ? Image.asset('images/profile.png', scale: 4.0,) : Image.asset('images/profiled.png', scale: 4.0,),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              settings ?
              Positioned(
                top: 100,
                right: 150,
                child: FadeX(
                  reversed: true,
                  delay: 0.0,
                  child: Container(
                    width: 140,
                    decoration: dropDownDecoration(),
                    child: Column(
                      children: <Widget>[
                        SettingsMenuItem(
                          title: lang(context, 'termsOfUse'),
                          onTap: (){
                            setState(() {
                              settings = false ;
                              _dropdownMenuOpened = false;
                              termsOfUseDialog(context);
                            });
                          },
                        ),
                        SettingsMenuItem(
                          title: lang(context, 'policy'),
                          onTap: (){
                            setState(() {
                              settings = false ;
                              _dropdownMenuOpened = false;
                              policyDialog(context);
                            });
                          },
                        ),
                        SettingsMenuItem(
                          title: lang(context, 'contact'),
                          onTap: (){
                            setState(() {
                              settings = false ;
                              _dropdownMenuOpened = false;
                              contactDialog(context);
                            });
                          },
                        ),
                        SettingsMenuItem(
                          title: lang(context, 'about'),
                          onTap: (){
                            setState(() {
                              settings = false ;
                              _dropdownMenuOpened = false;
                              aboutDialog(context);
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  duration: Duration(milliseconds: 350),
                ),
              ): SizedBox(),
              _dropdownMenuOpened ?
              Positioned(
                top: 3,
                right: 5 ,
                child: FadeY(
                  delay: 0.0,
                  duration: Duration(milliseconds: 200),
                  child: Container(
                    decoration: dropDownDecoration(),
                    width: 140,
                    padding: EdgeInsets.symmetric(vertical: 3.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        DropDownMenuItem(
                          title: lang(context, 'rate'),
                          icon: Icons.rate_review,
                          onTap: () async {
                            setState(() {
                              _dropdownMenuOpened = false;
                            });
                            await scanQRCode();
                            if(_scannedUId != null ){
                              try{
                                showRateDialog(_scannedUId,context);
                              }catch (e){
                                Fluttertoast.showToast(
                                  msg: 'فشل 😞',
                                  gravity: ToastGravity.BOTTOM,
                                );
                              }
                            } else if (_scannedUId == null){
                              Fluttertoast.showToast(
                                msg: 'فشل 😞',
                                gravity: ToastGravity.BOTTOM,
                              );
                            }
                          },
                        ),
                        divider(),
                        DropDownMenuItem(
                          title: lang(context, 'settings'),
                          icon: Icons.settings,
                          onTap: (){
                            setState(() {
                              settings = !settings ;
                            });
                          },
                        ),
                        divider(),
                        DropDownMenuItem(
                          title: lang(context, 'signOut'),
                          icon: Icons.exit_to_app,
                          onTap: (){
                            DatabaseService().signOut();
                            _dropdownMenuOpened = false;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ):
              SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}









