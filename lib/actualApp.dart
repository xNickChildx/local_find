import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:wink_city/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wink_city/settings.dart';
import 'package:wink_city/mainBody.dart';
import 'package:wink_city/user.dart';


class ActualApp extends StatefulWidget {
  ActualApp({Key key, this.auth, this.userId, this.logoutCallback})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;
  User _user;
  @override
  _ActualAppState createState() {
    _user=new User(userId:userId);

    return new _ActualAppState(user:_user);
  }
}
class _ActualAppState extends State<ActualApp>{
  bool settings=false;

  User user;
  _ActualAppState({this.user});



  Widget build(BuildContext context) {
    if(user.info==null || user.info.isEmpty) {
      return Scaffold(
          appBar: AppBar(
            actions:[
              IconButton(
                  icon:const Icon(Icons.settings),
                  tooltip:'Settings',
                  onPressed:(){
                    setState((){
                      settings= !settings;

                    });
                  }
              )],
          ),
        body: getSettingsMenu());
    }
    return Scaffold(
      appBar: AppBar(
        actions:[
          IconButton(
              icon:const Icon(Icons.settings),
              tooltip:'Settings',
              onPressed:(){
                setState((){
                  settings= !settings;

                });
              }
          )],
      ),
      body: settings ? getSettingsMenu() : getMainBody(),

    );
  }
//  var getUserInfo(String id) async{
//  final firestoreInstance = Firestore.instance;
//
//  var result = await firestoreInstance
//        .collection("users")
//        .where("", isEqualTo: "italy")
//        .getDocuments();
//
//  }
  Widget getSettingsMenu(){
    return SettingsMenu(logoutCallback:widget.logoutCallback,user:user);
  }
  Widget getMainBody(){

    return MainBody();
  }

}

