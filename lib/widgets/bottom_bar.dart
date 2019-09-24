import 'package:flutter/material.dart';
import 'package:helppyapp/widgets/screen.dart';

class BottomBar extends StatelessWidget {

  final int index;

  final PageController pageController;

  final List<Screen> screens;

  BottomBar(this.index, this.pageController, this.screens);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    List<BottomNavigationBarItem> navItems = screens.map((screen){
      return BottomNavigationBarItem(
        icon: Icon(screen.menuIconData, color: Color.fromARGB(255, 0, 0, 0)),
        title: new Text(screen.screenTitle.length < 20 ? screen.screenTitle : "Informações", style: TextStyle(color: themeData.primaryColor),),
        backgroundColor: themeData.secondaryHeaderColor
      );
    }).toList();
    return BottomNavigationBar(
      type: BottomNavigationBarType.shifting ,
      currentIndex: index,
      items: navItems,
      onTap: (i){
        if (pageController != null){
          pageController.jumpToPage(i);
        }
      },
    );
  }
}
