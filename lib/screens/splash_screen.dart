import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Container(
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
              )
            ]
        )
    );
  }
}
