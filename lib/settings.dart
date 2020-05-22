import 'package:flutter/material.dart';
import 'package:wink_city/user.dart';
import 'package:flutter/services.dart';

class SettingsMenu extends StatefulWidget {
  final VoidCallback logoutCallback;
  User user;
  SettingsMenu({this.logoutCallback, this.user});

  @override
  _SettingsMenuState createState() {
    return new _SettingsMenuState(logoutCallback:logoutCallback,user:user);
  }
}
class _SettingsMenuState extends State<SettingsMenu> {
  final VoidCallback logoutCallback;
  User user;

  int gen;
  int interest;

  _SettingsMenuState({this.logoutCallback, this.user});

  Widget build(BuildContext context) {
    return ListView(
    children: <Widget>[Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Row1"), getForm(),
          getLogoutButton(),
        ],
      ),
    )]);
  }

  Widget getLogoutButton() {
    return RaisedButton(
      elevation: 5.0,
      shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(30.0)),
      color: Colors.red,
      child: new Text("Logout",
          style: new TextStyle(fontSize: 20.0, color: Colors.white)),
      onPressed: () => logoutCallback(),
    );
  }

  Widget getForm() {

    final _formKey = GlobalKey<FormState>();

    return Form(
        key: _formKey,
        child: Column(
            children: <Widget>[

              TextFormField(
                initialValue:user.info["name"],
                decoration:
                InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter your first name';
                  }
                },
                onSaved: (val) =>
                    setState(() => user.info['name'] = val),
              ),


              //radius
              TextFormField(
              initialValue:user.info['radius'],

              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
               LengthLimitingTextInputFormatter(3),
              WhitelistingTextInputFormatter.digitsOnly
              ],
              decoration: InputDecoration(
              labelText:"Distance to Search",

              icon: Icon(Icons.phone_iphone)
              ),
              validator: (value) {
              if (value.isEmpty) {
              return 'Please enter your first name';
              }
              },
              onSaved: (val) =>
              setState(() => user.info['radius'] = val),
              ),

              //genderRadio

              new Text(
                'Your Gender :',
                style: new TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Radio(
                    value: 0,
                    groupValue: gen,
                    onChanged: (val)  {final form = _formKey.currentState;
                    form.save();genChanged(val);},
                  ),
                  new Text(
                    'Male',
                    style: new TextStyle(fontSize: 16.0),
                  ),
                  new Radio(
                    value: 1,
                    groupValue: gen,
                    onChanged: (val)  {final form = _formKey.currentState;
                    form.save();genChanged(val);},
                  ),
                  new Text(
                    'Female',
                    style: new TextStyle(
                      fontSize: 16.0,
                    ),
                  ),

                ],
              ),


              //gender interested in
              new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Radio(
                    value: 0,
                    groupValue: interest,
                    onChanged: (val)  {final form = _formKey.currentState;
                    form.save();interestChanged(val);} ,
                  ),
                  new Text(
                    'Men',
                    style: new TextStyle(fontSize: 16.0),
                  ),
                  new Radio(
                    value: 1,
                    groupValue: interest,
                    onChanged:(val)  {final form = _formKey.currentState;
                    form.save();interestChanged(val);} ,
                  ),
                  new Text(
                    'Women',
                    style: new TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  new Radio(
                    value: 2,
                    groupValue: interest,
                    onChanged: (val)  {final form = _formKey.currentState;
                    form.save();interestChanged(val);} ,
                  ),
                  new Text(
                    'Both',
                    style: new TextStyle(fontSize: 16.0),
                  ),
                ],
              ),




              Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 16.0),
                  child: RaisedButton(
                      onPressed: () {
                        final form = _formKey.currentState;
                        if (form.validate()) {
                          form.save();
                          user.updateDatabase();
                        }
                      },
                      child: Text('Save'))),

            ]
        )
    );

  }
  void genChanged(int val){
    setState((){

      gen=val;
      switch(val){
        case 0: user.info['gen']="male";
        break;
        default:
          user.info['gen']="female";
          break;
      }
    });
  }
   void interestChanged(int val){
    setState((){
      interest=val;
      switch(val){
        case 0: user.info['looking']="men";
        break;
        case 1:user.info['looking']="women";
        break;
        case 2:user.info['looking']="both";
        break;
        default:
          user.info['looking']="women";
          break;
      }
    });
  }
}

