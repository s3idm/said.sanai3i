import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sanai3i/files/result_map.dart';
import 'package:sanai3i/files/settings.dart';
import 'package:simple_animations/simple_animations.dart';
import 'database.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:supercharged/supercharged.dart';


bool loading = false ;
double iconScale = 4;
Color kActiveBtnColor = Color(0xff27496D);

containerDecoration (Color containerColor) {
  return BoxDecoration(
    color: containerColor,
    boxShadow: [
      BoxShadow(color: Colors.black.withOpacity(.1), spreadRadius: .25, blurRadius: 2, offset: Offset(.5, .5),),
      BoxShadow(color: Colors.black.withOpacity(.05), spreadRadius: .25, blurRadius: 2, offset: Offset(-.5, -.5),),
    ],
    borderRadius: BorderRadius.all(Radius.circular(8)),
  );
}
roundedContainerDecoration (Color containerColor) {
  return BoxDecoration(
    color: containerColor,
    boxShadow: [
      BoxShadow(color: Colors.black.withOpacity(.1), spreadRadius: .25, blurRadius: 2, offset: Offset(0, 1),),
    ],
    borderRadius: BorderRadius.all(Radius.circular(50)),
  );
}

btnDecoration (Color containerColor,double radius) {
  return BoxDecoration(
    color: containerColor,
    boxShadow: [
      BoxShadow(color: Colors.black.withOpacity(.2), spreadRadius: .5, blurRadius: 2, offset: Offset(0, 1),),
      BoxShadow(color: Colors.black.withOpacity(.05), spreadRadius: .5, blurRadius: 2, offset: Offset(0, -1),),
    ],
    borderRadius: BorderRadius.all(Radius.circular(radius)),
  );
}

containerDecorationWithBorders (containerColor) {
  return BoxDecoration(
    color: containerColor,
    boxShadow: [BoxShadow(color: Colors.black.withOpacity(.1), spreadRadius: .5, blurRadius: 2, offset: Offset(0, 3),),],
    borderRadius: BorderRadius.all(Radius.circular(30)),
    border: Border.all(color: kActiveBtnColor,width: 1.5)
  );
}

dropDownDecoration (){
  return
    BoxDecoration(
      color: Colors.white,
      boxShadow: [
      BoxShadow(color: Colors.black.withOpacity(.1), spreadRadius: 1.0, blurRadius: 5, offset: Offset(3, 3),),
      BoxShadow(color: Colors.black.withOpacity(.1), spreadRadius: 1.0, blurRadius: 5, offset: Offset(-3, 3),),
      ],
      borderRadius: BorderRadius.all(Radius.circular(10)),
  );
}

enum _AniProps { opacity , translateX }

class JopShopTile { String nameAr ,nameEn; Image icon; JopShopTile({this.nameAr,this.icon,this.nameEn}); }

class FadeY extends StatelessWidget {
  final double delay;
  final Widget child;
  final Duration duration;
  final bool reversed ;
  FadeY({@required this.delay,@required  this.child, @required this.duration, this.reversed});

  @override
  Widget build(BuildContext context) {
    bool direction = reversed ?? false ;
    final tween = MultiTween<_AniProps>()..add(_AniProps.opacity, 0.4.tweenTo(1.0))..add(_AniProps.translateX, 20.0.tweenTo(0.0));

    return PlayAnimation<MultiTweenValues<_AniProps>>(
      delay: (150 * delay).round().milliseconds,
      duration: duration,
      tween: tween.curved(Curves.decelerate),
      child: child,
      builder: (context, child, value) => Opacity(
        opacity: value.get(_AniProps.opacity),
        child: Transform.translate(
          offset: Offset( 0 , direction ? value.get(_AniProps.translateX) : -value.get(_AniProps.translateX) ),
          child: child,
        ),
      ),
    );
  }
}

class FadeX extends StatelessWidget {
  final double delay;
  final Widget child;
  final Duration duration;
  final bool reversed ;

  FadeX({@required this.delay,@required  this.child, @required this.duration, this.reversed});

  @override
  Widget build(BuildContext context) {
    bool direction = reversed ?? false ;

    final tween = MultiTween<_AniProps>()..add(_AniProps.opacity, 0.4.tweenTo(1.0))..add(_AniProps.translateX, 20.0.tweenTo(0.0));

    return PlayAnimation<MultiTweenValues<_AniProps>>(
      delay: (180 * delay).round().milliseconds,
      duration: duration,
      tween: tween.curved(Curves.decelerate),
      child: child,
      builder: (context, child, value) => Opacity(
        opacity: value.get(_AniProps.opacity),
        child: Transform.translate(
          offset: Offset( direction ?value.get(_AniProps.translateX) : -value.get(_AniProps.translateX),0.0 ),
          child: child,
        ),
      ),
    );
  }
}

class DropDownMenuItem extends StatelessWidget {
  final Function onTap;
  final String title ;
  final IconData icon ;
  DropDownMenuItem({this.onTap,this.title, this.icon});
  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: onTap,
      elevation: 5,
      child: Container(
        padding: EdgeInsets.fromLTRB(5, 0, 8, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Text(title,style: TextStyle(fontSize: 12),textAlign: TextAlign.right,),
            SizedBox(width: 15,),
            Icon(icon,size: 18,),
          ],
        ),
      ),
    );
  }
}

class SettingsMenuItem extends StatelessWidget {
  final Function onTap;
  final String title ;
  SettingsMenuItem({this.onTap,this.title});
  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: onTap,
      elevation: 5,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Align(
          alignment: Alignment.centerRight,
          child: Text(title,style: TextStyle(fontSize: 12),textAlign: TextAlign.right,),
        ),
      ),
    );
  }
}

showPhoneDialog(String phone1,phone2,cCode,BuildContext context){
  showModal(
      configuration: FadeScaleTransitionConfiguration(),
      context: context,builder:(context)=>
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            RaisedButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              color: kActiveBtnColor,
              onPressed: (){
                launch('tel:$phone1');
                Navigator.pop(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    height: 38,
                    child: IconButton(
                      icon: Image.asset('images/wa.png',),
                      onPressed: (){
                        launch('https://api.whatsapp.com/send?phone=$cCode$phone1');
                      },
                    ),
                  ),
                  Text(phone1,style: TextStyle(color: Colors.white),textAlign: TextAlign.right,),
                  Icon(Icons.phone,color: Colors.white,)
                ],
              ),
            ),
            phone2 != null ?
            RaisedButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              color: kActiveBtnColor,
              onPressed: (){
                launch('tel:$phone2');
                Navigator.pop(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    height: 38,
                    child: IconButton(
                      icon: Image.asset('images/wa.png',),
                      onPressed: (){
                        launch('https://api.whatsapp.com/send?phone=$cCode$phone2');
                      },
                    ),
                  ),
                  Text(phone2,style: TextStyle(color: Colors.white),),
                  Icon(Icons.phone,color: Colors.white,)
                ],
              ),
            ):
            SizedBox(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 60),
              child: RaisedButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                color: kActiveBtnColor,
                child: Text(lang(context, 'cancel'),style: TextStyle(color: Colors.white),),
                onPressed: (){
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      )
  );
}

showRateDialog(String uid,BuildContext context){
  showModal(
    configuration: FadeScaleTransitionConfiguration(),
    context: context,
    builder: (context) {
      String _newRate ;
      String _comment = ''  ;
      String _name = '' ;
      bool _star1 =false,_star2 =false,_star3 =false, _star4 =false, _star5 =false , notSelected = false ;
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState){

            _selectedStar(int num ,BuildContext context) {
                if (num == 1) {
                  setState(() {
                    _star1 = true;
                    _star2 = false;
                    _star3 = false;
                    _star4 = false;
                    _star5 = false;
                  });
                } else if (num == 2) {
                  setState(() {
                    _star1 = true;
                    _star2 = true;
                    _star3 = false;
                    _star4 = false;
                    _star5 = false;
                  });
                } else if (num == 3) {
                  setState(() {
                    _star1 = true;
                    _star2 = true;
                    _star3 = true;
                    _star4 = false;
                    _star5 = false;
                  });
                } else if (num == 4) {
                  setState(() {
                    _star1 = true;
                    _star2 = true;
                    _star3 = true;
                    _star4 = true;
                    _star5 = false;
                  });
                } else {
                  setState(() {
                    _star1 = true;
                    _star2 = true;
                    _star3 = true;
                    _star4 = true;
                    _star5 = true;
                  });
                }
              }
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          _selectedStar(1,context);
                          _newRate = 1.toString();
                        },
                        child: _star1 ?  Icon(Icons.star,size: 28,color: Colors.yellow,) : Icon(Icons.star_border,size: 28),
                      ),
                      InkWell(
                        onTap: () {
                          _selectedStar(2,context);
                          _newRate = 2.toString();
                        },
                        child: _star2 ?  Icon(Icons.star,size: 28,color: Colors.yellow,) : Icon(Icons.star_border,size: 28),
                      ),
                      InkWell(
                        onTap: () {
                          _selectedStar(3,context);
                          _newRate = 3.toString();
                        },
                        child: _star3 ?  Icon(Icons.star,size: 28,color: Colors.yellow,) : Icon(Icons.star_border,size: 28),
                      ),
                      InkWell(
                        onTap: () {
                          _selectedStar(4,context);
                          _newRate = 4.toString();
                        },
                        child: _star4 ?  Icon(Icons.star,size: 28,color: Colors.yellow,) : Icon(Icons.star_border,size: 28),
                      ),
                      InkWell(
                        onTap: () {
                          _selectedStar(5,context);
                          _newRate = 5.toString();
                        },
                        child: _star5 ?  Icon(Icons.star,size: 28,color: Colors.yellow,) : Icon(Icons.star_border,size: 28),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: notSelected ? Text(lang(context, 'selectRate')) : SizedBox(),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    height: 35,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      border: Border.all(color: kActiveBtnColor,width: 1),
                    )  ,
                    child: TextField(
                      textAlign: TextAlign.right,
                      onChanged: (name){
                        _name = name ;
                      },
                      decoration: InputDecoration(
                        enabledBorder: InputBorder.none,
                        border: InputBorder.none,
                        hintText:  lang(context, 'name'),
                        hintStyle: TextStyle(color: Colors.black,fontSize: 15),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      border: Border.all(color: kActiveBtnColor,width: 1),
                    )  ,
                    child: TextField(
                      textAlign: TextAlign.right,
                      onChanged: (comment){
                        _comment = comment ;
                      },
                      decoration: InputDecoration(
                        enabledBorder: InputBorder.none,
                        border: InputBorder.none,
                        hintText:  lang(context, 'writeReview'),
                        hintStyle: TextStyle(color: Colors.black,fontSize: 15),
                        ),
                      ),
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      RaisedButton(
                        child: Text(lang(context, 'cancel'),style: TextStyle(color: Colors.white),),
                        color: kActiveBtnColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        onPressed: (){
                          Navigator.pop(context);
                        },
                      ),
                      RaisedButton(
                        child: Text(lang(context, 'review'),style: TextStyle(color: Colors.white),),
                        color: kActiveBtnColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        onPressed: (){
                          if(_newRate != null ){
                            DatabaseService(uid: uid).updateUserRate(name: _name , comment: _comment , rate: _newRate );
                            Navigator.pop(context);
                            Fluttertoast.showToast(
                              msg: ' $_newRate  👌 ',
                              gravity: ToastGravity.BOTTOM,
                            );
                          }else{
                            setState(() {
                              notSelected = true ;
                            });
                          }
                        },
                      ),
                    ],
                  )
                ],
              );
            },
          ),
      );
    }
  );
}

showCommentDialog({List comments ,BuildContext context}){
  showModal(
      configuration: FadeScaleTransitionConfiguration(),
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          actions: <Widget>[
            RawMaterialButton(
              fillColor: kActiveBtnColor,
              shape: StadiumBorder(),
              onPressed: () { Navigator.pop(context); },
              child: Text(lang(context, 'cancel'),style: TextStyle(color: Colors.white),),
            )
          ],
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState){
              if(comments.length == 0 ){
                return Text(lang(context, 'noReviews'),style: TextStyle(fontSize: 16,color: Colors.black),textDirection: TextDirection.rtl,);
              }else
                return Container(
                  width: 300,
                  height: 500,
                  child: ListView.builder(
                    itemCount: comments.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            int.parse(comments[index]['stars']) == 1 ? Icon(Icons.star,size: 18,color: Colors.yellow,) :
                            int.parse(comments[index]['stars']) == 2 ? Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Icon(Icons.star,size: 18,color: Colors.yellow,),
                                Icon(Icons.star,size: 18,color: Colors.yellow,),
                              ],
                            ) :
                            int.parse(comments[index]['stars']) == 3 ? Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Icon(Icons.star,size: 18,color: Colors.yellow,),
                                Icon(Icons.star,size: 18,color: Colors.yellow,),
                                Icon(Icons.star,size: 18,color: Colors.yellow,),
                              ],
                            ) :
                            int.parse(comments[index]['stars']) == 4 ? Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Icon(Icons.star,size: 18,color: Colors.yellow,),
                                Icon(Icons.star,size: 18,color: Colors.yellow,),
                                Icon(Icons.star,size: 18,color: Colors.yellow,),
                                Icon(Icons.star,size: 18,color: Colors.yellow,),
                              ],
                            ):
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Icon(Icons.star,size: 18,color: Colors.yellow,),
                                Icon(Icons.star,size: 18,color: Colors.yellow,),
                                Icon(Icons.star,size: 18,color: Colors.yellow,),
                                Icon(Icons.star,size: 18,color: Colors.yellow,),
                                Icon(Icons.star,size: 18,color: Colors.yellow,),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Text("${comments[index]['name']}",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),textDirection: TextDirection.rtl,),
                                Text(lang(context, 'rateBy'),style: TextStyle(fontSize: 16),textDirection: TextDirection.rtl,),
                              ],
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text("${comments[index]['comment']} ",style: TextStyle(fontSize: 14),textDirection: TextDirection.rtl,),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
            },
          ),
        );
      }
  );
}




class PositionedBtn extends StatelessWidget {
  final Function onPressed;
  final IconData icon;
  PositionedBtn({this.onPressed,this.icon});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      child: RaisedButton(
        shape: RoundedRectangleBorder(borderRadius:  BorderRadius.all(Radius.circular(40))),
        onPressed: onPressed,
        child: Center(child: Icon(icon,color: Colors.white,size: 20,)),
        color: kActiveBtnColor,
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final Icon   suffixIcon;
  final String initialValue;
  final bool   editEnabled;
  final Function onChange;
  final bool validator;
  final style ;
  final containerWidth;
  final TextInputType keyboardType ;
  CustomTextField({this.initialValue,this.editEnabled,this.suffixIcon,this.onChange,this.validator,this.style,@required this.containerWidth,this.keyboardType});
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      decoration: editEnabled ? containerDecorationWithBorders(Colors.white) :  containerDecoration(Colors.white),
      width: containerWidth,
      height: 37,
      curve: Curves.easeOut,
      duration: Duration(milliseconds: 250),
      child: TextFormField(
        onChanged: onChange,
        enabled: editEnabled,
        textAlign: TextAlign.center,
        keyboardType: keyboardType,
        style: style,
        decoration: InputDecoration(
          hintText:  initialValue,
          hintStyle: TextStyle(color: Colors.black,fontSize: 15),
          border: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1,color: Colors.purpleAccent),
            borderRadius: BorderRadius.all(Radius.circular(15))
          ),
          suffixIcon: suffixIcon,
          prefix: validator ? Text(lang(context,'required'),style: TextStyle(color: Colors.red,fontSize: 10),):SizedBox(width: 25,)
        ),
      ),
    );
  }
}

class TextFieldReusable extends StatelessWidget{
  TextFieldReusable({this.hintOfTextFiled,this.onSaved,this.keyboardType,this.length,this.validator,this.controller,this.onChanged});
  final String hintOfTextFiled;
  final Function onSaved;
  final TextInputType keyboardType;
  final int length ;
  final validator;
  final controller ;
  final onChanged;
  @override
  Widget build(BuildContext context) {
    var screenData = MediaQuery.of(context);
    return AnimatedContainer(
      height: 35,
      width: screenData.size.width*.6,
      duration: Duration(milliseconds: 100),
      margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
      padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
      decoration: roundedContainerDecoration(kActiveBtnColor) ,
      child: TextFormField(
        validator: validator,
        controller: controller,
        keyboardType: keyboardType,
        autofocus: false,
        maxLength: length,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          fillColor: kActiveBtnColor,
          counter: SizedBox.shrink(),
          hintText:'$hintOfTextFiled',
          hintStyle: TextStyle(color: Colors.grey,),
          border: OutlineInputBorder(borderSide: BorderSide.none),
        ),
        style: TextStyle(color: Colors.white, fontSize: 16,),
        textAlign: TextAlign.center,
        onSaved: onSaved,
        onChanged: onChanged,
      ),
    );
  }
}

class CustomGridView extends StatelessWidget {

  final gridViewType;
  CustomGridView({@required this.gridViewType});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 1, childAspectRatio: 1.25, mainAxisSpacing: 1),
      itemCount: gridViewType.length,
      padding: EdgeInsets.all(5),
      itemBuilder: (context ,index){
        return OpenContainer(
          closedElevation: 0,
          closedColor: Colors.transparent,
          openElevation: 0,
          openColor: Colors.transparent,
          closedBuilder: (context,action){
            return FadeY(
              duration: Duration(milliseconds: 300),
              delay: index/10*.5,
              child: Container(
                margin: EdgeInsets.all(3),
                decoration: containerDecoration(Colors.grey[50]),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    gridViewType[index].icon,
                    Text(lang(context, '${gridViewType[index].nameAr}'), style: TextStyle(fontSize: 12),textAlign: TextAlign.center,),
                  ],
                ),
              ),
            );
          },
          openBuilder: (context,action){
            return ResultsInMaps(jopOrShop: gridViewType[index].nameAr,);
          },
        );
      },
    );
  }
}

class MyCustomTile extends StatefulWidget {

  final Model modelDetails;
  MyCustomTile({@required this.modelDetails});

  @override
  _MyCustomTileState createState() => _MyCustomTileState();
}
class _MyCustomTileState extends State<MyCustomTile> {

  bool _isBookmarked = false ;
  String _rate = '' ;

  ifUserIsBookmarked(String uid)async{
    final user =  FirebaseAuth.instance.currentUser;
    List bookmarks = await FirebaseFirestore.instance.collection('Users').doc(user.uid).get().then((DocumentSnapshot documentSnapshot) {
      return documentSnapshot.data()['Bookmark'];
    } );
    if (bookmarks.contains(uid) ){
      setState(() {
        _isBookmarked = true;
      });
    }else{
      _isBookmarked = false ;
    }
  }

  addUserToBookmark()async{
    final user = FirebaseAuth.instance.currentUser;
    List bookmarks = await FirebaseFirestore.instance.collection('Users').doc(user.uid).get().then((DocumentSnapshot documentSnapshot) {
      return documentSnapshot.data()['Bookmark'];
    });
    if(!bookmarks.contains(widget.modelDetails.myUID)){
      setState(() {
        DatabaseService(uid: user.uid).updateUsersBookmarks(widget.modelDetails.myUID);
        _isBookmarked = true ;
      });
    }else{
      setState(() {
        DatabaseService(uid: user.uid).deleteUsersBookmarks(widget.modelDetails.myUID);
        _isBookmarked = false ;
      });
    }
  }

  @override
  void initState() {
    ifUserIsBookmarked(widget.modelDetails.myUID);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    if (widget.modelDetails.ratedMe.length == 0 ){
      _rate = 0.0.toString();
    } else {
      _rate = (double.parse(widget.modelDetails.rate)/widget.modelDetails.ratedMe.length).toString();
    }

    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
      tween: Tween(begin: 0.8,end: 1.0),
      builder: (context ,value , child){
        return Transform.scale(
          scale: value,
          child: Padding(
            padding: EdgeInsets.all(3),
            child: Stack(
              children: <Widget>[
                Container(
                  height:80,
                  width: size.width-20,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(.1), spreadRadius: .5, blurRadius: 2, offset: Offset(0, 3),),],
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                Positioned(
                  child: IconButton(
                    icon: Icon(Icons.phone, size: 20,),
                    onPressed: () {
                      showPhoneDialog(widget.modelDetails.phone,widget.modelDetails.phone2,widget.modelDetails.cCode,context);
                    },
                  ),
                ),
                Positioned(
                  bottom: 1,
                  child: _isBookmarked != null ? IconButton(
                    icon: _isBookmarked ? Icon(Icons.favorite,color: Colors.red,size: 20,): Icon(Icons.bookmark, size: 20,),
                    onPressed: (){
                      addUserToBookmark();
                    },
                  ):
                  CircularProgressIndicator(),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      color: Color(0xdd27496D),
                      borderRadius: BorderRadius.only(topRight: Radius.circular(8),bottomRight: Radius.circular(8)),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: widget.modelDetails.picURL == null ?  AssetImage('images/profilePic.png') : CachedNetworkImageProvider( widget.modelDetails.picURL ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 15,
                  bottom: 5,
                  child: Container(
                    width: 50,
                    height: 18,
                    decoration: containerDecoration(kActiveBtnColor),
                    padding: EdgeInsets.fromLTRB(6, 0, 6, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Icon(Icons.star, color: Colors.yellow, size: 15,),
                        Padding(
                          padding:  EdgeInsets.fromLTRB(0, 3, 0, 0),
                          child: Text(_rate, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.white,),),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 15,
                  right: 100,
                  child: Text(widget.modelDetails.name, style: TextStyle(fontSize: 15,),),
                ),
                Positioned(
                  bottom: 10,
                  right: 100,
                  child: widget.modelDetails.isAvailable
                    ? Text(lang(context, 'free'), style: TextStyle(fontSize: 14),)
                    : Text(lang(context, 'notFree'), style: TextStyle(fontSize: 14),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 50,
                  child: Text('${lang(context, 'reviews')}  ${widget.modelDetails.ratedMe.length}', style: TextStyle(fontSize: 12),)
                ),
                Positioned(
                  top: 40,
                  child: Container(
                    width: 40,
                    height: .5,
                    child: Divider(thickness: .5, color: Colors.grey[500],),
                  ),
                ),
                Positioned(
                  left: 40,
                  child: Container(
                    height: 80,
                    width: .5,
                    child: VerticalDivider(thickness: .5, color: Colors.grey[500],),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}
divider(){
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 5),
    child: Divider(
      height: 1,
      color: Colors.black26,
      thickness: .5,
    ),
  );
}

List<JopShopTile> jopList =[
  JopShopTile(nameAr: 'ميكانيكي'       ,nameEn: "mechanistic", icon: Image.asset('images/mec.png',scale: 2.5,) ),
  JopShopTile(nameAr: 'كهربائي'      ,nameEn: "Electrician", icon: Image.asset('images/kah.png',scale: 2.5) ),
  JopShopTile(nameAr: 'سباك'       ,nameEn: 'Plumber', icon: Image.asset('images/seb.png',scale: 2.5) ),
  JopShopTile(nameAr: 'نقاش'       ,nameEn: "engraver", icon: Image.asset('images/nak.png',scale: 2.5) ),
  JopShopTile(nameAr: 'عامل بناء'     ,nameEn: "builder", icon: Image.asset('images/aml.png',scale: 2.5) ),
  JopShopTile(nameAr: 'نجار'        ,nameEn: "Carpenter", icon: Image.asset('images/nag.png',scale: 2.5) ),
  JopShopTile(nameAr: 'سيراميك'      ,nameEn: "Ceramic", icon: Image.asset('images/aml.png',scale: 2.5) ),
  JopShopTile(nameAr: 'استرجي'       ,nameEn: "Furniture paint", icon: Image.asset('images/nak.png',scale: 2.5) ),
  JopShopTile(nameAr: 'حداد'        ,nameEn: "Smith", icon: Image.asset('images/had.png',scale: 2.5) ),
  JopShopTile(nameAr: 'فني الوميتال'    ,nameEn: "Alumital technician", icon: Image.asset('images/aml.png',scale: 2.5) ),
  JopShopTile(nameAr: 'صيانة دش'     ,nameEn: "TV maintenance", icon: Image.asset('images/sey.png',scale: 2.5) ),
  JopShopTile(nameAr: 'تنجيد و ستائر'   ,nameEn: "upholstery", icon: Image.asset('images/aml.png',scale: 2.5) ),
  JopShopTile(nameAr: 'فني تكييفات'    , nameEn: "Air conditioning technician",icon: Image.asset('images/tec.png',scale: 2.5) ),
  JopShopTile(nameAr: 'صيانة اجهزة منزلية' ,nameEn: "Appliances Maintenance" ,icon: Image.asset('images/sey.png',scale: 2.5) ),
  JopShopTile(nameAr: 'فلاتر مياه'     ,nameEn: "Water filters", icon: Image.asset('images/fil.png',scale: 2.5) ),
  JopShopTile(nameAr: 'محارة'        ,nameEn: "plasterer", icon: Image.asset('images/nak.png',scale: 2.5) ),
  JopShopTile(nameAr: 'حمامات سباحة'   ,nameEn: "swimming pool", icon: Image.asset('images/sba.png',scale: 2.5) ),
  JopShopTile(nameAr: 'تدفئة مركزية'    ,nameEn: "Central heating", icon: Image.asset('images/tec.png',scale: 2.5) ),
  JopShopTile(nameAr: 'طباخ'        ,nameEn: "Chef", icon: Image.asset('images/tap.png',scale: 2.5) ),
];

List<JopShopTile> shopsList =[
  JopShopTile(nameAr: 'زجاج'          ,nameEn: 'Glass', icon: Image.asset('images/zogag.png',scale: iconScale) ),
  JopShopTile(nameAr: 'مطابخ'          ,nameEn: "Kitchens", icon: Image.asset('images/matb5.png',scale: iconScale) ),
  JopShopTile(nameAr: 'معرض سيراميك'     ,nameEn: "Ceramics Showroom", icon: Image.asset('images/blat.png',scale: iconScale) ),
  JopShopTile(nameAr: 'تكييفات'        , nameEn: 'Air conditioning',icon: Image.asset('images/takyyf.png',scale: 2) ),
  JopShopTile(nameAr: 'دهانات و ديكورات'  ,nameEn: "Paints and Decorations", icon: Image.asset('images/dhanat.png',scale: iconScale) ),
  JopShopTile(nameAr: 'ادوات صحية'      ,nameEn: "Plumbing equipment", icon: Image.asset('images/sepaka.png',scale: iconScale) ),
  JopShopTile(nameAr: 'كهرباء و اضاءة'    ,nameEn: "Electricity equipment", icon: Image.asset('images/khrba.png',scale: iconScale) ),
  JopShopTile(nameAr: 'اثاث منزلي'      ,nameEn: "Home furniture", icon: Image.asset('images/asas.png',scale: iconScale) ),
  JopShopTile(nameAr: 'رخام و جيرانيت'   ,nameEn: "Marble and granite", icon: Image.asset('images/ro5am.png',scale: iconScale) ),
  JopShopTile(nameAr: 'عدد و ادوات'    ,nameEn: "tools & equipment ", icon: Image.asset('images/adwat.png',scale: iconScale) ),
  JopShopTile(nameAr: 'خامات خشب'    ,nameEn: 'Wood materials', icon: Image.asset('images/5a4b.png',scale: iconScale) ),
  JopShopTile(nameAr: 'مكافحة حشرات'    ,nameEn: 'Anti Bugs', icon: Image.asset('images/7shrat.png',scale: 2) ),
  JopShopTile(nameAr: 'كاميرات مراقبة'   ,nameEn: "security cameras",  icon: Image.asset('images/camera.png',scale: iconScale) ),
  JopShopTile(nameAr: 'مراتب و ستائر'   ,nameEn: 'Mattresses and curtains',  icon: Image.asset('images/mratb.png',scale: iconScale) ),
  JopShopTile(nameAr: 'اجهزة منزلية'     ,nameEn: "Home appliances",  icon: Image.asset('images/agheza.png',scale: iconScale) ),
  JopShopTile(nameAr: 'مشتل'        ,nameEn: 'nursery',  icon: Image.asset('images/mshtl.png',scale: iconScale) ),
  JopShopTile(nameAr: 'سجاد و موكيت'   ,nameEn: "carpeting",  icon: Image.asset('images/segad.png',scale: 2.5) ),
  JopShopTile(nameAr: 'خدمات نقل'     ,nameEn: "Transfer services",  icon: Image.asset('images/nakl.png',scale: iconScale) ),
  JopShopTile(nameAr: 'مواتير مياه'      ,nameEn: 'Water motors', icon: Image.asset('images/motor.png',scale: iconScale) ),
  JopShopTile(nameAr: 'مصاعد'        ,nameEn: 'Elevators',  icon: Image.asset('images/mes3d.png',scale: iconScale) ),
];



