import 'package:flutter/material.dart';

class GoalScreen extends StatelessWidget {

  final String objetivo;

  GoalScreen(this.objetivo);

  @override
  Widget build(BuildContext context) {
    //Tentativa de corrigir tamanho
    double screenWidth = MediaQuery.of(context).size.width;
    double iconWidth = screenWidth * 0.5;
    double fontSize = screenWidth * 0.05;
    return Column(
      children: <Widget>[
        SizedBox(height: 30,),
        Image.asset("assets/image/helppy.png", width: iconWidth,),
        Container(
          margin: EdgeInsets.all(40),
          child: Text("$objetivo", textAlign: TextAlign.justify, style: TextStyle(
            fontSize: fontSize,
          ),),
        ),
      ],
    );
  }
}