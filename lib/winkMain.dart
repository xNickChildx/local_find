import 'package:flutter/material.dart';
import 'package:wink_city/authentication.dart';
import 'package:wink_city/rootPage.dart';
void main(){
  runApp(new TheApp());

}

class TheApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return new MaterialApp(
      title:'Wink City',
      home: new RootPage(auth:new Auth())
    );
  }
}