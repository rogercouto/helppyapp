import 'package:flare_flutter/flare_actor.dart';
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
    List<double> sep = _screenHelper.getBreathSeparators();
    double fs = _screenHelper.getHelpFontSize();
    return AnimatedOpacity(
      // If the widget is visible, animate to 0.0 (invisible).
      // If the widget is hidden, animate to 1.0 (fully visible).
      opacity: _isVisible ? 1.0 : 0.0,
      duration: Duration(milliseconds: 500),
      // The green box must be a child of the AnimatedOpacity widget.
      child: Stack(
        children: <Widget>[
          GestureDetector(
        onTapDown: (_){
          setState(() {
            _isPaused = !_isPaused;
          });
        },
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.topCenter,
              child: Column(
                children: <Widget>[
                  SizedBox(height: sep[0],),
                  SizedBox(width: _screenHelper.getTextBoxSize(),
                    child: Text(widget.info.text, style: TextStyle(fontSize: fs), textAlign: TextAlign.justify,),
                  ),
                  SizedBox(height: sep[1],),
                  Text(_isPaused? "" : "Inspire ... expire", style: TextStyle(fontSize: fs+6),)
                ],
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                height: animSize.height,
                width: animSize.width,
                child: FlareActor("assets/anim/resp.flr", 
                      animation: "loop", 
                      isPaused: _isPaused
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Text(_isPaused ? "Iniciar" : "", style: TextStyle(fontSize: fs+6),),
            )
          ],
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