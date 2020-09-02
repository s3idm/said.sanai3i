import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sanai3i/files/photoViwer.dart';
import 'package:sanai3i/files/reusable.dart';
import 'package:sanai3i/files/settings.dart';
import 'package:url_launcher/url_launcher.dart';
import 'database.dart';


class ProfileBrowser extends StatefulWidget {
  final String userUID ;
  ProfileBrowser({@required this.userUID});
  @override
  _ProfileBrowserState createState() => _ProfileBrowserState();
}

class _ProfileBrowserState extends State<ProfileBrowser>with SingleTickerProviderStateMixin {

  @override
  initState() {
    super.initState();
    loading = false;
  }
  @override
  void dispose() {
    super.dispose();
  }
  var _rate ;

  @override
  Widget build(BuildContext context) {
    var screenData = MediaQuery.of(context);

    if(widget.userUID != null ){
      return Scaffold(
        backgroundColor: Color(0xffefefef),
        body: SafeArea(
          child: StreamBuilder<Model>(
            stream: DatabaseService(uid: widget.userUID).getUserByUID,
            builder: (context, snapshot) {
            if(snapshot.hasData){
              if(snapshot.data.ratedMe.length == 0 ){_rate = '0.0';}else {_rate = '${(double.parse(snapshot.data.rate)/snapshot.data.ratedMe.length)}';}
              return ListView.builder(
                padding: EdgeInsets.all(5),
                itemCount: snapshot.data.workImages.length +1 ?? 1,
                itemBuilder: (context , index){
                  final List workImagesReversed = snapshot.data.workImages.reversed.toList();
                  if(index == 0 ) {
                    return Column(
                      children: <Widget>[
                        Stack(
                          overflow: Overflow.visible,
                          alignment: AlignmentDirectional.center,
                          children: <Widget>[
                            Positioned(
                              child: Container(
                                height: 125,
                                decoration: containerDecoration(Colors.white),
                              ),
                            ),
                            Positioned(
                              right: 15,
                              child: Container(
                                height: 85,
                                width: 85,
                                child: snapshot.data.picURL == null ?
                                Image.asset('images/profilePic.png'):
                                Image.network(snapshot.data.picURL,loadingBuilder: (context,child,progress){
                                  return progress == null ? SizedBox() : CircularProgressIndicator(backgroundColor: Colors.white70,);
                                  },
                                ),
                                decoration: BoxDecoration(
                                  color: Color(0xdd27496D),
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: snapshot.data.picURL == null ?  AssetImage('images/profilePic.png') : NetworkImage( snapshot.data.picURL ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 15,
                              right: 27.5,
                              child: Container(
                                width: 60,
                                height: 20,
                                decoration: containerDecoration(kActiveBtnColor),
                                padding: EdgeInsets.fromLTRB(6, 0, 6, 0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Icon(Icons.star, color: Colors.yellowAccent, size: 16,),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(0, 3, 0, 0),
                                      child: Text(double.parse(_rate).toStringAsFixed(2), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white,),),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              top: 20,
                              right: 115,
                              child: Container(
                                width: screenData.size.width*.6,
                                child: Text(snapshot.data.name , style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),textAlign: TextAlign.right,),
                              ),
                            ),
                            Positioned(
                              top: 55,
                              right: 115,
                              child: snapshot.data.isAvailable ?
                              Text(lang(context, 'free'), style: TextStyle(fontSize: 14),) :
                              Text(lang(context, 'notFree'), style: TextStyle(fontSize: 14,color: Colors.deepOrangeAccent),
                              ),
                            ),
                            Positioned(
                              bottom: 5,
                              right: 105,
                              child: Container(
                                height: 32,
                                child: RawMaterialButton(
                                  elevation: 4,
                                  shape: StadiumBorder(),
                                  fillColor: kActiveBtnColor,
                                  padding: EdgeInsets.symmetric(vertical: 5,horizontal: 8),
                                  onPressed: () {
                                    showCommentDialog(comments: snapshot.data.ratedMe ,context: context );
                                  },
                                  child: Text(lang(context, 'reviews') , style: TextStyle(fontSize: 14,color: Colors.white),textDirection: TextDirection.rtl,),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 5,
                              left: 10,
                              child: Container(
                                height: 32,
                                child: RawMaterialButton(
                                  elevation: 4,
                                  shape: StadiumBorder(),
                                  fillColor: kActiveBtnColor,
                                  padding: EdgeInsets.symmetric(vertical: 5,horizontal: 8),
                                  onPressed: () {
                                    showRateDialog(snapshot.data.myUID, context);
                                  },
                                  child: Row(
                                    children: <Widget>[
                                      Icon(Icons.add,color: Colors.white,size: 20,),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: Text(lang(context, 'review') , style: TextStyle(fontSize: 14,color: Colors.white),textDirection: TextDirection.rtl,),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            snapshot.data.phone2 != null ?
                            Expanded(
                              child: GestureDetector(
                              onTap: (){
                                launch('tel:${snapshot.data.phone2}');
                              },
                              child: Container(
                                decoration: containerDecoration(Colors.white),
                                height: 35,
                                margin: EdgeInsets.fromLTRB(0, 2, 0, 0),
                                padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                      height: 38,
                                      child: IconButton(
                                        icon: Image.asset('images/wa.png',),
                                        onPressed: (){
                                          launch('https://api.whatsapp.com/send?phone=${snapshot.data.cCode}${snapshot.data.phone2}');
                                        },
                                      ),
                                    ),
                                    Text(snapshot.data.phone2??''),
                                    Icon(Icons.phone,size: 20,),
                                  ],
                                ),
                              ),
                            ),
                            ):
                            SizedBox(),
                            SizedBox(width: 2,),
                            Expanded(
                              child: GestureDetector(
                                onTap: (){
                                  launch('tel:${snapshot.data.phone}');
                                },
                                child: Container(
                                  decoration: containerDecoration(Colors.white),
                                  height: 35,
                                  margin: EdgeInsets.fromLTRB(0, 2, 0, 0),
                                  padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                        height: 38,
                                        child: IconButton(
                                          icon: Image.asset('images/wa.png',),
                                          onPressed: (){
                                            launch('https://api.whatsapp.com/send?phone=${snapshot.data.cCode}${snapshot.data.phone}');
                                          },
                                        ),
                                      ),
                                      Text(snapshot.data.phone ?? ''),
                                      Icon(Icons.phone,size: 20,),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          decoration: containerDecoration(Colors.white),
                          padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
                          height: 35,
                          margin: EdgeInsets.fromLTRB(0, 2, 0, 1),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              SizedBox(width: 10,),
                              Text(lang(context, '${snapshot.data.type}') ?? ''),
                              Icon(Icons.work,size: 20,),
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                  int nextIndex = index - 1 ;
                  return InkWell(
                    onTap: (){
                      Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context,pA,sA){
                        return FadeScaleTransition(
                          animation: pA.drive(CurveTween(curve: Curves.easeOutCubic)),
                          child: PhotoViewer(imageUrl: workImagesReversed[nextIndex]),
                          );
                        }),
                      );
                    },
                    child: Container(
                      decoration: containerDecoration(Colors.white),
                      padding: EdgeInsets.all(8),
                      margin: EdgeInsets.fromLTRB(1, 1, 1, 1),
                      width: screenData.size.width,
                      height: screenData.size.width,
                      child: CachedNetworkImage(
                        imageUrl: workImagesReversed[nextIndex],
                        progressIndicatorBuilder: (context, url, downloadProgress) =>
                            Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
                        errorWidget: (context, url, error) =>
                            Icon(Icons.error),
                      ),
                    ),
                  );
                },
              );
            } else return CircularProgressIndicator(backgroundColor: Colors.black,);
          },
          ),
        ),
        floatingActionButton:  FloatingActionButton(
          child: Icon(Icons.arrow_forward,size: 20,),
          backgroundColor: kActiveBtnColor,
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      );
    } else return Center(child: CircularProgressIndicator());
  }
}
