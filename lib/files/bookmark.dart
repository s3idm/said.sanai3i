import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:sanai3i/files/database.dart';
import 'package:sanai3i/files/profile_browser.dart';
import 'package:sanai3i/files/reusable.dart';
import 'package:sanai3i/files/settings.dart';


class BookmarkPage extends StatefulWidget {
  @override
  _BookmarkPageState createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {

  @override
  initState() {
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final userUid = Provider.of<FirebaseUser>(context, listen: false);
    final Size size = MediaQuery.of(context).size;

    return StreamBuilder<List>(
      stream: DatabaseService(uid: userUid.uid).userBookmarks,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length == 0) {
            return Center(child: Text(lang(context, 'noBookmarks')));
          } else {
            return ListView.builder (
              itemCount: snapshot.data.length ?? [],
              itemBuilder: (context, index) {
                final reversedBookmarks = snapshot.data.reversed.toList();
                return StreamBuilder<Model>(
                  stream: DatabaseService(uid: reversedBookmarks[index]).getUserByUID,
                  builder: (context, aBookmarkedUser) {
                  if(aBookmarkedUser.hasData){
                    return OpenContainer(
                      closedElevation: 0,
                      closedColor: Colors.transparent,
                      openElevation: 0,
                      openColor: Colors.transparent,
                      closedBuilder: (context,action){
                        return FadeX(
                          delay: index/6.0,
                          duration: Duration(milliseconds: 250),
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(8, 3, 8, 3),
                            child: Stack(
                              children: <Widget>[
                                Container(
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: Colors.white ,
                                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(.2), spreadRadius: .25, blurRadius: 2, offset: Offset(.5, .5),),],
                                    borderRadius: BorderRadius.all(Radius.circular(5)),
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  left: 0,
                                  child: IconButton(
                                    icon: Icon(Icons.phone,size: 18,),
                                    onPressed: () {
                                      showPhoneDialog(aBookmarkedUser.data.phone,aBookmarkedUser.data.phone2,aBookmarkedUser.data.cCode ,context);
                                    },
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  child: IconButton(
                                    onPressed: () {
                                      DatabaseService(uid: userUid.uid).deleteUsersBookmarks(aBookmarkedUser.data.myUID);
                                      Fluttertoast.showToast(
                                        msg: lang(context, 'deleted'),
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                      );
                                    },
                                    icon: Icon(Icons.delete,size: 18,),
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  child: Container(
                                    height: 80,
                                    width: 80,
                                    decoration: BoxDecoration(
                                      color: Color(0xdd27496D),
                                      borderRadius: BorderRadius.only(topRight: Radius.circular(5),bottomRight: Radius.circular(5),),
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: aBookmarkedUser.data.picURL == null ?
                                        AssetImage('images/profilePic.png') :
                                        CachedNetworkImageProvider(aBookmarkedUser.data.picURL,),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 13,
                                  bottom: 0,
                                  child: Container(
                                    width: 54,
                                    height: 18,
                                    decoration: containerDecoration(kActiveBtnColor),
                                    padding: EdgeInsets.fromLTRB(6, 0, 6, 0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Icon(Icons.star, color: Colors.yellow, size: 15,),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: <Widget>[
                                            Text( aBookmarkedUser.data.ratedMe.length == 0 ?
                                            '0.0' :
                                            '${(double.parse(aBookmarkedUser.data.rate)/aBookmarkedUser.data.ratedMe.length).toStringAsFixed(2)}',
                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.white,),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 10,
                                  right: 100,
                                  child: Container(
                                    width: size.width * .52,
                                    child: Align(
                                      alignment: Alignment.topRight,
                                      child: Text(aBookmarkedUser.data.name ?? '',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 5,
                                  left: 60,
                                  child: aBookmarkedUser.data.isAvailable ?
                                  Text(lang(context, 'free'), style: TextStyle(fontSize: 14),) :
                                  Text(lang(context, 'notFree'), style: TextStyle(fontSize: 14,color: Colors.deepOrangeAccent),
                                  ),
                                ),
                                Positioned(
                                  bottom: 5,
                                  right: 105,
                                  child: Text(lang(context, '${aBookmarkedUser.data.type}') ?? '',style: TextStyle(fontSize: 14)),
                                ),
                                Positioned(
                                  top: 40,
                                  child: Container(
                                    width: 45,
                                    height: .5,
                                    child: Divider(
                                      thickness: .5, color: Colors.black38,),
                                  ),
                                ),
                                Positioned(
                                  left: 45,
                                  child: Container(
                                    height: 80,
                                    width: .5,
                                    child: VerticalDivider(
                                      thickness: .5, color: Colors.black38,),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      openBuilder: (context,action){
                        return ProfileBrowser(userUID: aBookmarkedUser.data.myUID,);
                        },
                    );
                  } else {
                    return SizedBox(height: 0,);
                  }
                  },
                );
              },
            );
          }
        } else {
          return Center(child: CircularProgressIndicator()
          );
        }
      }
    );
  }
}