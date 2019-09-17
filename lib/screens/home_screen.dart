import 'dart:math';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:helppyapp/main.dart';
import 'package:helppyapp/blocs/animation_bloc.dart';
import 'package:helppyapp/blocs/bar_bloc.dart';

class HomeScreen extends StatefulWidget {

  final PageController _pageController;

  HomeScreen(this._pageController);

  @override
  _HomeState createState() => _HomeState();

}

class _HomeState extends State<HomeScreen> {

  bool _bVisible = false;

  @override
  void initState(){
    super.initState();
    Future.delayed(Duration(seconds: 1)).then((_){
      setState(() {
        _bVisible = true;
      });
    });
  }

  Widget girafa(){

    var animBloc = BlocProvider.getBloc<AnimationBloc>();

    bool canTap = true;

    void _handleTapDown(TapDownDetails details){
      if (!canTap)
        return;
      var point = Point(details.localPosition.dx, details.localPosition.dy);
      var head = Rectangle(150, 370, 110, 110);
      var neck = Rectangle(180, 480, 70, 70);
      var tail = Rectangle(270, 550, 80, 60);
      if (head.containsPoint(point)){
        animBloc.changeAnimation("orelha");
      }else if (neck.containsPoint(point)){
        animBloc.changeAnimation("pescoço");
      }else if (tail.containsPoint(point)){
        animBloc.changeAnimation("rabo");
      }
      canTap = false;
      Future.delayed(Duration(seconds: 2),(){
        animBloc.changeAnimation("");
        canTap = true;
      });
    }

    var gestureDetector = GestureDetector(
      onTapDown: _handleTapDown,
      child: Align(
        alignment: Alignment.bottomRight,
        child: Container(
          height: 350,
          width: 350,
          child: StreamBuilder(
            stream: animBloc.outAnim,
            initialData: "",
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              return FlareActor("assets/anim/girafa.flr", 
                animation: "${snapshot.data}", 
                alignment: Alignment.bottomRight,
                isPaused: snapshot.data != "" ? false : true
            );
            },
          ),
        ),
      )
    );
    return gestureDetector;
  }
  
  Widget balao(){
    return Positioned(
      top: 10,
      left: 10,
      child: Image.asset("assets/image/balao.png")
    );
  }

  Widget texto(){
    return Positioned(
      top: 70,
      left: 70,
      child: Column(
        children: <Widget>[
          Text("Oi!",
            style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 36)),
          Text("Eu sou o Helppy.",
            style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 24))
        ],
      )
    );
  }

  Widget botoes(){

    var bloc = BlocProvider.getBloc<BarBloc>();

    return Positioned(
      top: 160,
      left: 90,
      child: Column(
        children: <Widget>[
          
          ConstrainedBox(constraints: BoxConstraints(minWidth: 175),
            child: RaisedButton(
              color: Colors.brown,
              child: Text("Objetivo", style: TextStyle(color: Colors.white, fontSize: 18),), 
              shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
              onPressed: () {
                bloc.changeTitle("Objetivo");
                bloc.changeAction(MainApp.backToHome(widget._pageController));
                widget._pageController.jumpToPage(1);

              },
            ),
          ),
          ConstrainedBox(constraints: BoxConstraints(minWidth: 175),
            child: RaisedButton(
              color: Colors.red,
              child: Text("Preciso de ajuda", style: TextStyle(color: Colors.white, fontSize: 18),), 
              shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
              onPressed: () {
                bloc.changeTitle("Ajuda");
                widget._pageController.jumpToPage(2);
                bloc.changeAction(MainApp.backToHome(widget._pageController));
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget fadeInB(){
    return AnimatedOpacity(
      // If the widget is visible, animate to 0.0 (invisible).
      // If the widget is hidden, animate to 1.0 (fully visible).
      opacity: _bVisible ? 1.0 : 0.0,
      duration: Duration(milliseconds: 1000),
      // The green box must be a child of the AnimatedOpacity widget.
      child: Stack(
        children: <Widget>[
          balao(),
          texto(),
          botoes()
        ],
      ),
    );
  }

  Widget fadeInG(){
    return AnimatedOpacity(
      // If the widget is visible, animate to 0.0 (invisible).
      // If the widget is hidden, animate to 1.0 (fully visible).
      opacity: _bVisible ? 1.0 : 0.0,
      duration: Duration(milliseconds: 250),
      // The green box must be a child of the AnimatedOpacity widget.
      child: Stack(
        children: <Widget>[
          girafa()
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
        children: <Widget>[
          fadeInB(),
          fadeInG()
        ],
    );
  }
}