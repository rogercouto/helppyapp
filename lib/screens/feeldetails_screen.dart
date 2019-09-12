import 'package:flutter/material.dart';
import 'package:helppyapp/models/feel.dart';

import '../main.dart';

class FeelDetails extends StatefulWidget {

  final Feel feel;

  FeelDetails(this.feel);

  @override
  _FeelDetailsState createState() => _FeelDetailsState(feel.descr.length);
}

class _FeelDetailsState extends State<FeelDetails> {

  final int descrLength;
  
  final _controller = ScrollController();
  
  GlobalKey _scrollKey = GlobalKey();

  bool _canScrollUp;
  bool _canScrollDown;

  _FeelDetailsState(this.descrLength);

  bool _needScroll(){
    return descrLength > 850;
  }

  double _getTextHeight(){
    RenderBox box = _scrollKey.currentContext.findRenderObject();
    return box.size.height - 50;
  }

  Widget _getScrollView(){
    _controller.addListener((){
      setState(() {
        _canScrollUp = _controller.offset > 0.0;
        _canScrollDown = _controller.offset < _getTextHeight();
        //print("${_controller.offset} < ${_getTextHeight()}");
      });
    });
    SingleChildScrollView scrolView = SingleChildScrollView(
      key: _scrollKey,
      controller: _controller,
      padding: EdgeInsets.fromLTRB(30, 50, _needScroll()? 70 : 30, 50),
      child: Column(
        children: <Widget>[
          Text(widget.feel.subtitle, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold), textAlign: TextAlign.justify),
          SizedBox(height: 20,),
          Text(widget.feel.descr, style: TextStyle(fontSize: 18), textAlign: TextAlign.justify)
        ],
      ),
    );
    return scrolView;
  }


  void _scrollUp(){
    print("Scroll up ($_canScrollUp) h: ${_getTextHeight()}");
    setState(() {
      _controller.jumpTo(0.0);
    });
  }

  void _scrollDown(){
    print("Scroll down ($_canScrollDown) h: ${_getTextHeight()}");
    setState(() {
      _controller.jumpTo(_getTextHeight()+60);
    });
  }

  List<Widget> getChildren(){
    List<Widget> widgets = [];
    widgets.add(_getScrollView());
    if (_needScroll()){
      widgets.add(
        Positioned(
          top: 5, right: 5,
          child: FloatingActionButton(
            heroTag: "btnUp",
            child: Icon(Icons.arrow_upward), backgroundColor: _canScrollUp ? Colors.orange : Colors.grey[300], 
              onPressed: _canScrollUp ? _scrollUp : null,
            )
        )
      );
      widgets.add(
        Positioned(
          bottom: 5, right: 5,
          child: FloatingActionButton(
            heroTag: "btnDown",
            child: Icon(Icons.arrow_downward), backgroundColor: _canScrollDown ? Colors.orange : Colors.grey[300], 
              onPressed: _canScrollDown ? _scrollDown : null,
            )
        )
      );
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    if (_canScrollUp == null)
      _canScrollUp = true;
    if (_canScrollDown == null)
      _canScrollDown = true;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        title: Text(widget.feel.title, style: TextStyle(color: Theme.of(context).primaryColor)),
        centerTitle: true,
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
      ),
      body: Stack(
        children: getChildren(),
      ),
    );
  }
}