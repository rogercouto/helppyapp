import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:helppyapp/blocs/bar_bloc.dart';
import 'package:helppyapp/widgets/screen.dart';

import 'menu_drawer.dart';

const CYELLOW = Color.fromARGB(255, 255, 214, 0);
const CBROWN = Color.fromARGB(255, 56, 33, 13);

class ScreenBuilder{

  final _pageController = PageController();

  final List<Screen> _screens = [];

  ScreenBuilder();

  PageController get pageController => _pageController;

  AppBar _appBar(){
    var bloc = BlocProvider.getBloc<BarBloc>();
    return AppBar(
      backgroundColor: CYELLOW,
      centerTitle: true,
      title: StreamBuilder(
        stream: bloc.outTitle,
        initialData: "Home",
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Text("${snapshot.data}", style: TextStyle(color: CBROWN),);
        },
      ),
      iconTheme: IconThemeData(color: CBROWN),
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
      drawer: MenuDrawer(_pageController, _screens),
      
    );
  }


}