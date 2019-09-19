import 'package:flutter/material.dart';
import 'package:helppyapp/helpers/screen_helper.dart';
import 'package:helppyapp/widgets/screen.dart';

class GoalScreen extends StatelessWidget {

  final String objetivo;

  GoalScreen(this.objetivo);

  @override
  Widget build(BuildContext context) {
    ScreenHelper screenHelper = ScreenHelper(context);
    return Column(
      children: <Widget>[
        SizedBox(height: 30,),
        Image.asset("assets/image/helppy.png", width: screenHelper.getGoalIconSize(),),
        Container(
          margin: EdgeInsets.all(30),
          child: Text("$objetivo", textAlign: TextAlign.justify, style: TextStyle(
            fontSize: screenHelper.getGoalFontSize(),
          ),),
        ),
      ],
    );
  }
}