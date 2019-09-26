import 'package:flutter/cupertino.dart';

enum ScreenSize{
  SMALL, MEDIUM, BIG, BIGGER
}

class Position{
  final double x;
  final double y;
  Position(this.x, this.y);
}

/*
 * Classe utilizda para auxiliar a protabilidade para diferentes tamanhos de telas
 */
class ScreenHelper{

  Size _dim;
  ScreenSize _size;

  ScreenHelper(BuildContext context){
    //print(MediaQuery.of(context).size);
    _dim = Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);
    if (_dim.height <= 590){
      _size = ScreenSize.SMALL;
    }else if (_dim.height > 590 && _dim.height <= 680){
      _size = ScreenSize.MEDIUM;
    }else if (_dim.height > 680 && _dim.height < 780){
      _size = ScreenSize.BIG;
    }else{
      _size = ScreenSize.BIGGER;
    }
  }

  ScreenSize get size => _size;

  Size get dimensions => _dim;

  Size getHomeGirafaSize() {
    if (_size == ScreenSize.SMALL)
      return Size(200, 200);
    else if (_size == ScreenSize.MEDIUM)
      return Size(250, 250);
    else if (_size == ScreenSize.BIG)
      return Size(300, 300);
    else
      return Size(325, 325);
  }

  Size getHomeBalaoSize(){
    if (_size == ScreenSize.SMALL)
      return Size(235, 260);
    else if (_size == ScreenSize.MEDIUM)
      return Size(250, 280);
    else if (_size == ScreenSize.BIG)
      return Size(275, 320);
    return Size(300, 350);
  }

  Position getHomeBalaoPos(){
    if (_size != ScreenSize.BIG)
      return Position(5,0);
    return Position(10, 5);
  }

  Position getHomeTextPos(){
    if (_size == ScreenSize.SMALL)
      return Position(40,35);
    else if (_size == ScreenSize.MEDIUM)
      return Position(40,35);
    return Position(55, 55);
  }

  List<double> getHomeTextFontSizes(){
    if (_size == ScreenSize.SMALL)
      return [24, 18];
    else if (_size == ScreenSize.MEDIUM)
      return [34, 22];
    return [36, 24];
  }

  Position getHomeBtnsPos(){
    if (_size == ScreenSize.SMALL)
      return Position(35,90);
    else if (_size == ScreenSize.MEDIUM)
      return Position(40,105);
    return Position(65, 140);
  }

  double getGoalIconSize(){
    if (_size == ScreenSize.SMALL)
      return 100;
    else if (_size == ScreenSize.MEDIUM)
      return 150;
    return 200;
  }

  double getGoalFontSize(){
    if (_size == ScreenSize.SMALL)
      return 15;
    else if (_size == ScreenSize.MEDIUM)
      return 16;
    return 18;
  }

  Size getHelpBtnSize(){
    if (_size == ScreenSize.SMALL)
      return Size(175, 50);
    else if (_size == ScreenSize.MEDIUM)
      return Size(200, 60);
    return Size(200, 100);
  }

  double getHelpBtnFontSize(int txtLength){
    if (_size == ScreenSize.SMALL)
      return txtLength < 4 ? 40 : 36;
    else if (_size == ScreenSize.MEDIUM)
      return txtLength < 4 ? 42 : 38;
    return txtLength < 4 ? 64 : 48;
  }

  double getHelpBtnIconSize(){
    if (_size == ScreenSize.SMALL)
      return 36;
    else if (_size == ScreenSize.MEDIUM)
      return 36;
    return 48;
  }


  double getHelpFontSize(){
    if (_size == ScreenSize.SMALL)
      return 16;
    else if (_size == ScreenSize.MEDIUM)
      return 16;
    return 18;
  }

  Size getBreathSize() {
    if (_size == ScreenSize.SMALL)
      return Size(200, 200);
    else if (_size == ScreenSize.MEDIUM)
      return Size(250, 255);
    return Size(350, 350);
  }

  List<double> getBreathSeparators(){
    if (_size == ScreenSize.SMALL)
      return [20, 175];
    else if (_size == ScreenSize.MEDIUM)
      return [30, 250];
    return [50, 350];
  }

  double getBreathFontSize(){
    if (_size == ScreenSize.SMALL)
      return 16;
    else if (_size == ScreenSize.MEDIUM)
      return 16;
    return 18;
  }

  double getTextBoxSize(){
    if (_size == ScreenSize.SMALL)
      return 275;
    else if (_size == ScreenSize.MEDIUM)
      return 300;
    return 350;
  }

}