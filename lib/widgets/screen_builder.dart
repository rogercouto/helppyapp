import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:helppyapp/blocs/bar_bloc.dart';
import 'package:helppyapp/widgets/screen.dart';

import 'menu_drawer.dart';

class ScreenBuilder{

  final _pageController = PageController();

  final List<Screen> _screens = [];

  final ThemeData themeData;

  PageController get pageController => _pageController;

  ScreenBuilder(this.themeData);

  AppBar _appBar(){
    var bloc = BlocProvider.getBloc<BarBloc>();
    return AppBar(
      backgroundColor: themeData.secondaryHeaderColor,
      centerTitle: true,
      title: StreamBuilder(
        stream: bloc.outTitle,
        initialData: "Home",
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Text("${snapshot.data}", style: TextStyle(color: themeData.primaryColor),);
        },
      ),
      iconTheme: IconThemeData(color: themeData.primaryColor),
      actions: <Widget>[
        StreamBuilder(
          stream: bloc.outAction,
          initialData: Container(),
          builder: (context, snapshot){
            return snapshot.data;
          },
        )
      ],
    );
  }
  
  add(Screen screen){
    _screens.add(screen);
  }

  Scaffold build(){
    List<Widget> screens = _screens.map((screen)=>screen.child).toList();
    return Scaffold(
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        children: screens,
        controller: _pageController,
      ),
      appBar: _appBar(),
      drawer: MenuDrawer(_pageController, _screens, themeData),
      
    );
  }


}