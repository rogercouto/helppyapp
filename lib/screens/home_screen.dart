import 'dart:math';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:helppyapp/helpers/screen_helper.dart';
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

  ScreenHelper _screenHelper;

  int _animIndex = 0;

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
      switch(_animIndex){
        case 0:
          animBloc.changeAnimation("orelha");
          break;
        case 1:
          animBloc.changeAnimation("pescoço");
          break;
        case 2:
          animBloc.changeAnimation("rabo");
          break;
      }
      _animIndex++;
      if (_animIndex > 2)
        _animIndex = 0;
      canTap = false;
      Future.delayed(Duration(seconds: 2),(){
        animBloc.changeAnimation("");
        canTap = true;
      });
    }
    Size gSize = _screenHelper.getHomeGirafaSize();
    var gestureDetector = GestureDetector(
      onTapDown: _handleTapDown,
      child: Align(
        alignment: Alignment.bottomRight,
        child: Container(
          height: gSize.height,
          width: gSize.width,
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
    Size bSize = _screenHelper.getHomeBalaoSize();
    Position pPos = _screenHelper.getHomeBalaoPos();
    return Positioned(
      top: pPos.y,
      left: pPos.x,
      child: Image.asset("assets/image/balao.png", height: bSize.height, width: bSize.width,)
    );
  }

  Widget texto(){
    Position pos = _screenHelper.getHomeTextPos();
    List<double> fs = _screenHelper.getHomeTextFontSizes();
    return Positioned(
      top: pos.y,
      left: pos.x,
      child: Column(
        children: <Widget>[
          Text("Oi!",
            style: TextStyle(color: Theme.of(context).primaryColor, fontSize: fs[0])),
          Text("Eu sou o Helppy.",
            style: TextStyle(color: Theme.of(context).primaryColor, fontSize: fs[1]))
        ],
      )
    );
  }

  Widget botoes(){
    var bloc = BlocProvider.getBloc<BarBloc>();
    Position pos = _screenHelper.getHomeBtnsPos();
    return Positioned(
      top: pos.y,
      left: pos.x,
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
    _screenHelper = ScreenHelper(context);
    print(_screenHelper.size);
    return Stack(
        children: <Widget>[
          fadeInB(),
          fadeInG()
        ],
    );
  }
}