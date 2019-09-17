import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:helppyapp/blocs/bar_bloc.dart';
import 'package:helppyapp/widgets/screen.dart';
import 'package:helppyapp/widgets/screen_builder.dart';

class MenuDrawer extends StatelessWidget {

  final PageController pageController;
  final List<Screen> screens;
  final ThemeData themeData;

  MenuDrawer(this.pageController, this.screens, this.themeData);

  Widget menuItem(String title, IconData iconData, BuildContext context, int pageIndex){
    
    var bloc = BlocProvider.getBloc<BarBloc>();
    int page = pageController.page.round();
    bool same = page == pageIndex;

    return InkWell(
      child: Container(
        height: 40,
        child: Row(
          children: <Widget>[
            Icon(iconData, color: (same)? Colors.grey : themeData.primaryColor,),
            SizedBox(width: 15,),
            Text(title, style: TextStyle(fontSize: 18,
              color: (same)? Colors.grey : themeData.primaryColor
            ),)
          ],
        ),
      ),
      onTap: (){
        Navigator.of(context).pop();
        pageController.jumpToPage(pageIndex);
        bloc.changeTitle(title);
        if (screens[pageIndex].action != null){
          bloc.changeAction(screens[pageIndex].action);
        }else{
          bloc.changeAction(Container());
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    
    List<Widget> widgets = [];
    screens.forEach((screen){
      widgets.add(menuItem(screen.screenTitle, screen.menuIconData, context, screens.indexOf(screen)));
      widgets.add(SizedBox(height: 15));
    });
    
    return Drawer(
        child: Stack(
          children: <Widget>[
            Container(color: Colors.yellow),
            ListView(
              padding: EdgeInsets.only(top: 75, left: 30),
              children: widgets,
            )
          ],
        )
      );
  }
}