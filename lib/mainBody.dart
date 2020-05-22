import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
class MainBody extends StatefulWidget{

  @override
  _MainBodyState createState(){
    return new _MainBodyState();
  }
}

class _MainBodyState extends State<MainBody>{
  bool search=false;


  Widget build(BuildContext context){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:<Widget>[
          getRadar(),
          RaisedButton(
            onPressed: () {setState((){search = !search;});},
            textColor: Colors.white,
            color:Colors.transparent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(color: Colors.transparent)),
            padding: const EdgeInsets.all(0.0),
            child: getCurrentButton(),
          ),
        ],
      ),
    );
  }
  Container getCurrentButton(){

    return !search ? Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(18.0)),
        gradient: LinearGradient(colors:<Color>[
          Color(0xFF2E7D32),
          Color(0xFF00E676),

        ]) ,
      ),
      padding: const EdgeInsets.all(10.0),
      child:
      const Text('Start Scannin', style: TextStyle(fontSize: 20)),
    ):
    Container(

      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(18.0)),
        gradient: LinearGradient(colors:<Color>[
          Color(0xFFB71C1C),
          Color(0xFFFF1744),

        ]) ,
      ),
      padding: const EdgeInsets.all(10.0),
      child:
      const Text('Stop Scan', style: TextStyle(fontSize: 20)),
    );


  }
  Stack getRadar(){
    double width = MediaQuery.of(context).size.width;
    double height=MediaQuery.of(context).size.width;
    double maxSize= width>height ? height:width;
    double totalDiameter=maxSize*0.95;
    double peopleDiameter=maxSize*0.05;
    return Stack(
        alignment:Alignment.center,
        children:<Widget>[
          Container(
              width:totalDiameter,
              height:totalDiameter,
              decoration:new BoxDecoration(
                color:Colors.orange,
                shape:BoxShape.circle,
              )
          ),

          search ? new Scanning(maxDiameter:totalDiameter):Container(
            width:1,
            height:1,
            color:Colors.red,
          ),
          search ? ScanData(context):Container(
            width:1,
            height:1,
            color:Colors.red,
          ),


          Container(
              width:peopleDiameter,
              height:peopleDiameter,
              decoration:new BoxDecoration(
                color:Colors.blue,
                shape:BoxShape.circle,
              )
          ),

        ]
    );
  }

}
class Scanning extends StatefulWidget{
  final double maxDiameter;

  Scanning({this.maxDiameter});
  @override
  _ScanningState createState(){
    return new _ScanningState(maxDiameter:maxDiameter);
  }
}
class _ScanningState extends State<Scanning> with SingleTickerProviderStateMixin{
  AnimationController animationController;
  Animation<double> animation;
  double maxDiameter;
  Map<String,double> currentLocation;

  Position _currentPosition;
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  _ScanningState({this.maxDiameter});
  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),

    )..addListener(() => setState(() {}));
    animation = Tween<double>(
      begin: 0,
      end: maxDiameter,
    ).animate(animationController);

    animationController.forward();

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animationController.repeat();
      }
    });


    print("hey");
    var geolocator = Geolocator();
    var locationOptions = LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 2); //update if location is 2 meters from previous

    StreamSubscription<Position> positionStream = geolocator.getPositionStream(locationOptions).listen(
            (Position position) {
          print(position == null ? 'Unknown' : position.latitude.toString() + ', ' + position.longitude.toString());
        });

  }
  Widget build(BuildContext context){
    return Container(
        width:animation.value,

        height:animation.value,
        decoration:new BoxDecoration(
          color:Colors.red,
          shape:BoxShape.circle,
        )

    );
  }
  @override
  void dispose(){
    animationController.dispose();
    super.dispose();
  }
}

Widget ScanData(BuildContext context) {
  print("here");
  return StreamBuilder<QuerySnapshot>(
    stream: Firestore.instance.collection('users').snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) return LinearProgressIndicator();

      return Users(context, snapshot.data.documents);
    },
  );

}
Widget Users(BuildContext context, List<DocumentSnapshot> snapshot ) {
  snapshot.forEach((item) {
    if (item.data["online"] == true)
      print(item.data.toString());
  });
  print("DOne");
  return Text("DONE PRINTING USERS");
}

