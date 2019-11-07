import 'package:flutter/material.dart';
import 'package:helppyapp/models/feel.dart';
import 'package:helppyapp/models/info.dart';
import 'package:helppyapp/screens/feeldetails_screen.dart';

class FeelsScreen extends StatelessWidget {

  final Info info;
  final Map<int, Feel> feelsMap;

  FeelsScreen(this.info, this.feelsMap);

  List<Widget> createChildren(BuildContext context){
    List<Widget> list = [];
    Feel feel = Feel(0,"Informação", info.title, info.text);
    list.add(
      ConstrainedBox(constraints: BoxConstraints(minWidth: double.infinity, minHeight: 50),
          child: RaisedButton(
            color: Colors.green,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.help, color: Colors.white,),
                Text(feel.title, style: TextStyle(color: Colors.white, fontSize: 24),)
              ],
            ), 
            shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (BuildContext context) => FeelDetails(feel))
              );
            },
          ),
        )
    );

    feelsMap.values.forEach((feel){
      list.add(
        SizedBox(height: 15,)
      );
      list.add(
        ConstrainedBox(constraints: BoxConstraints(minWidth: double.infinity, minHeight: 50),
            child: RaisedButton(
              color: Colors.orange,
              child: Text(feel.title, style: TextStyle(color: Colors.white, fontSize: 24),), 
              shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (BuildContext context) => FeelDetails(feel))
                );
              },
            ),
          )
      );
    });
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(50),
        child: Column(
          children: createChildren(context),
        ),
      )
    );
  }
}