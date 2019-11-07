import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helppyapp/helpers/screen_helper.dart';
import 'package:helppyapp/models/info.dart';

class BreathScreen extends StatefulWidget {

  final Info info;
  BreathScreen(this.info);

  @override
  _BreathScreenState createState() => _BreathScreenState();
}

class _BreathScreenState extends State<BreathScreen> {

  bool _isPaused = true;
  bool _isVisible = false;

  ScreenHelper _screenHelper;

  @override
  void initState(){
    super.initState();
    Future.delayed(Duration(seconds: 1)).then((_){
      setState(() {
        _isVisible = true;
      });
    });
  }

  Widget fadeInAnim(){
    Size animSize = _screenHelper.getBreathSize();
    double fs = _screenHelper.getHelpFontSize();
    return AnimatedOpacity(
      
      opacity: _isVisible ? 1.0 : 0.0,
      duration: Duration(milliseconds: 500),
      
      child: Stack(
        children: <Widget>[
          GestureDetector(
            onTapDown: (_){
              setState(() {
                _isPaused = !_isPaused;
              });
            },
            child: SingleChildScrollView(
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  Align(

                    alignment: Alignment.topCenter,
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 15,),
                        SizedBox(width: _screenHelper.getTextBoxSize(),
                          child: Text(widget.info.text, style: TextStyle(fontSize: fs), textAlign: TextAlign.justify,),
                        ),
                        /*
                        Container(
                          margin: EdgeInsets.only(top: 30.0),
                          child: Text(_isPaused? "" : "Inspire ... expire", style: TextStyle(fontSize: fs+6))
                        )
                         */
                      ],
                    ),
                  ),
                  Align(
                    child: Stack(
                      children: <Widget>[
                        Container(
                          height: animSize.height,
                          width: animSize.width,
                          child: FlareActor("assets/anim/resp_slow.flr",
                              animation: "loop",
                              isPaused: _isPaused
                          ),
                        ),
                        Container(
                          height: animSize.height,
                          width: animSize.width,
                          alignment: Alignment.center,
                          child: Text(_isPaused? "Iniciar" : "", style: TextStyle(fontSize: fs+6), textAlign: TextAlign.center,),
                        )
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(_isPaused ? "" : "Inspire ... expire", style: TextStyle(fontSize: fs+6),),
                  )
                ],
              )
            )
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _screenHelper = ScreenHelper(context);
    return Container(
      child: fadeInAnim(),
    );
  }
}