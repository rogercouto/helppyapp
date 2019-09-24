import 'package:flutter/material.dart';

class Screen {

  final int index;
  final String screenTitle;
  final IconData menuIconData;
  final Widget child;
  final Widget action;
  
  Screen(this.index, this.screenTitle, this.menuIconData, this.child, {this.action});

}