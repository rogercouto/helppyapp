import 'package:flutter/material.dart';

class GoalScreen extends StatelessWidget {

  final String objetivo;

  GoalScreen(this.objetivo);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 30,),
        Image.asset("assets/image/helppy.png", width: 200,),
        Container(
          margin: EdgeInsets.all(40),
          child: Text("$objetivo", textAlign: TextAlign.justify, style: TextStyle(
            fontSize: 20,
            
          ),),
        ),
      ],
    );
  }
}