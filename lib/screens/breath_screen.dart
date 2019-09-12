import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
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
                  SizedBox(height: 50,),
                  SizedBox(width: 300, 
                    child: Text(widget.info.text, style: TextStyle(fontSize: 18), textAlign: TextAlign.justify,),
                  ),
                  SizedBox(height: 350,),
                  Text(_isPaused? "" : "Inspire ... expire", style: TextStyle(fontSize: 24),)
                ],
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                height: 350,
                width: 350,
                child: FlareActor("assets/anim/resp.flr", 
                      animation: "loop", 
                      isPaused: _isPaused
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Text(_isPaused ? "Iniciar" : "", style: TextStyle(fontSize: 24),),
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
    return Container(
      child: fadeInAnim(),
    );
  }
}