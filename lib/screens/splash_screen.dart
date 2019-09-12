import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:helppyapp/models/feel.dart';
import 'package:helppyapp/models/info.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class Splash extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    SharedPreferences.getInstance().then((prefs){
      String user;
      if (!prefs.containsKey("helppyusr")){
        user = "u${DateTime.now().millisecondsSinceEpoch}";
        prefs.setString("helppyusr", "$user");
      }else{
        user = prefs.get("helppyusr");
      }
      Future.delayed(Duration(seconds: 0)).then((_){
      Firestore.instance.collection("info").getDocuments().then((QuerySnapshot infoSnapshot){

        Map<int, Info> infoMap = Map();
        infoSnapshot.documents.forEach((document){
           Info info = Info.fromDocument(document);
           infoMap[info.id] = info;
        });

        Firestore.instance.collection("feels").getDocuments().then((QuerySnapshot feelsSnapshot){

          Map<int, Feel> feelsMap = Map();
          feelsSnapshot.documents.forEach((document){
            Feel feel = Feel.fromDocument(document);
            feelsMap[feel.id] = feel;
          });

          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => MainApp(infoMap, feelsMap, user)
          ));

        });

      });
    });
    });    
    
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 300,
            height: 300,
            child: FlareActor("assets/anim/girafa.flr", 
                  animation: "pescoço_loop", 
                  isPaused: false),
          ),
          Image.asset("assets/image/logo.png", width: 300,)
        ],
      ),
    );
  }
}