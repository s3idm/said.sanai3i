import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:location/location.dart';

class Model {
  String name  ,phone ,type,rate,phone2,myUID,picURL,cCode;
  bool isAvailable;
  List bookmarks,workImages,ratedMe;
  Model({this.name,this.phone,this.type,this.rate,this.isAvailable,this.bookmarks,this.phone2,this.myUID,this.picURL,this.workImages,this.ratedMe,this.cCode});
}

class DatabaseService{

  DatabaseService({this.uid});
  final uid ;
  final CollectionReference users = FirebaseFirestore.instance.collection('Users');
  final CollectionReference registeredPhones = FirebaseFirestore.instance.collection('Phones');

  FirebaseAuth _auth = FirebaseAuth.instance;

Future createNewUser(String name , String type,String phone,String rate,String phone2, bool isAvailable,
    List bookmark ,String myUID,String picURL , List workImages,List ratedMeList,String cCode) async {

  return await users.doc(uid).set({
    'Name'     : name ,
    'Type'     : type,//For Account Type either {Jop} for workers {Shop} for ShowRooms and {NUll} for Clint
    'Phone'    : phone,
    'Phone2'   : phone2,
    'Rate'     : rate,
    'Available': isAvailable,//For the User State Working or free
    'UID'      : myUID,
    'Bookmark' : bookmark,
    'WorkImagesURL' : workImages,
    'PicURL'   :picURL,
    'RatedMeList' : ratedMeList,
    'CCode'       : cCode,
  });
}
  Future addRegisteredPhoneNumber (String phone) async {
    return await registeredPhones.doc(phone).set({
      'phone' : phone,
    });
  }

  Future<QuerySnapshot> ifAPhoneNumberRegistered(phone) async {
    return await registeredPhones.where('phone' ,isEqualTo: phone ).get();
}

  Future updateUsersInfo(String name , String phone2 , bool isAvailable) async {
    return await users.doc(uid).update({
      'Name'     : name ,
      'Phone2'    : phone2,
      'Available': isAvailable,
    });
}

  Future updateUsersBookmarks(String favUid) async {
    return await users.doc(uid).update({
      'Bookmark'     : FieldValue.arrayUnion([favUid])  ,
    });
}

  Future deleteUsersBookmarks(String deleteUid) async {
    return await users.doc(uid).update({
      'Bookmark'     : FieldValue.arrayRemove([deleteUid])  ,
    });
}

  Future updateUsersProfilePic(String picURL) async {
    return await users.doc(uid).update({
      'PicURL'     : picURL ,
    });
}

  Future updateUsersWorkImages(String picURL) async {
    return await users.doc(uid).update({
      'WorkImagesURL'     : FieldValue.arrayUnion([picURL]) ,
    });
}

  Future deleteUsersWorkImages(String picURL) async {
    return await users.doc(uid).update({
      'WorkImagesURL'     : FieldValue.arrayRemove([picURL]),
    });
}

  Future updateMyLocation() async {
    final user =  FirebaseAuth.instance.currentUser;
    final pos = await Location().getLocation();
    GeoFirePoint point = GeoFirePoint(pos.latitude,pos.longitude);
    return await users.doc(user.uid ).update({
      'MyLocation' : point.data ,
    });
  }

  Future updateUserRate ({String rate , String comment , String name  })async{
  double rateToDouble;
  final currentUser =  _auth.currentUser;
  if(currentUser.uid == uid  ){
    return null ;
  }else{
    final currentRate = await users.doc(uid).get().then((snapshot){
      return snapshot.data()['Rate'];
    });
    final newRate = (double.parse(currentRate)+double.parse(rate));
    rateToDouble = newRate ;
    return await users.doc(uid).update({
      'Rate' : rateToDouble.toString(),
      'RatedMeList' : FieldValue.arrayUnion([{'comment': comment , 'name': name , 'stars': rate , 'raterUid': currentUser.uid }]),
    });
  }
}

  Stream<User> get userState {
    return _auth.authStateChanges();
}

  signOut() async {
    await _auth.signOut();
}

  Stream<List> get userBookmarks {
    return users.doc(uid).snapshots().map((snapshot){
      return snapshot.get('Bookmark');
    });
}




Stream<Model> get  getUserByUID {
  return users.doc(uid).snapshots().map((snapshot){
    return Model(
      name:        snapshot.data()['Name']          ?? '',
      phone:       snapshot.data()['Phone']         ?? '',
      phone2:      snapshot.data()['Phone2']        ?? null,
      type:        snapshot.data()['Type']          ?? null,
      rate:        snapshot.data()['Rate']          ?? 0,
      isAvailable: snapshot.data()['Available']     ?? true,
      myUID:       snapshot.data()['UID']           ?? '',
      picURL:      snapshot.data()['PicURL']        ?? null,
      workImages:  snapshot.data()['WorkImagesURL'] ?? [],
      ratedMe:     snapshot.data()['RatedMeList']   ?? [],
      cCode:       snapshot.data()['CCode']         ?? ''
    );
  });
}

  Future<Model> infoTileDetails() async{
  final modelDetails =  await users.doc(uid).get().then((snapshot) =>
      Model(
    name:        snapshot.data()['Name']          ?? '',
    phone:       snapshot.data()['Phone']         ?? '',
    phone2:      snapshot.data()['Phone2']        ?? null,
    type:        snapshot.data()['Type']          ?? null,
    rate:        snapshot.data()['Rate']          ?? 0,
    isAvailable: snapshot.data()['Available']     ?? true,
    myUID:       snapshot.data()['UID']           ?? '',
    picURL:      snapshot.data()['PicURL']        ?? null,
    cCode:       snapshot.data()['CCode']         ?? '' ,
    ratedMe:     snapshot.data()['RatedMeList']   ?? [],
  ));
  return modelDetails ;
}


  Stream<Model> get currentUserData{
    return  users.doc(uid).snapshots().map((snapshot){
      return Model (
        name:        snapshot.data()['Name']          ?? '',
        phone:       snapshot.data()['Phone']         ?? '',
        phone2:      snapshot.data()['Phone2']        ?? null,
        type:        snapshot.data()['Type']          ?? null,
        rate:        snapshot.data()['Rate']          ?? '0',
        isAvailable: snapshot.data()['Available']     ?? true,
        bookmarks:   snapshot.data()['Bookmark']      ?? [],
        myUID:       snapshot.data()['UID']           ?? '',
        picURL:      snapshot.data()['PicURL']        ?? null,
        workImages:  snapshot.data()['WorkImagesURL'] ?? [],
        ratedMe:     snapshot.data()['RatedMeList']   ?? [],
        cCode:       snapshot.data()['CCode']         ?? ''
      );
    });
  }

}
