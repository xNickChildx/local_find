import 'package:cloud_firestore/cloud_firestore.dart';
class User{
  final String userId;
 Map<String,dynamic> info;
  User({this.userId}){
    info=new Map();

    getInfo();
  }
  void getInfo() async{
    final snapshot = await Firestore.instance
        .collection('users')
        .document(userId)
        .get();
    if (snapshot.data==null) {
      print("Found Npthing now writing" + info.toString());
      await Firestore.instance.collection('users').document(userId).setData(
          info);
    }
    else info=snapshot.data;



print("Info is "+ info.toString());
  }
  void updateDatabase() async{
    print("Uploading to Databse: "+ info.toString());
    await Firestore.instance
        .collection('users')
        .document(userId).updateData(info);
    print("Added " + info.toString());

  }

}