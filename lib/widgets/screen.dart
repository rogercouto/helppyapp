import 'package:flutter/material.dart';

class Screen {

  final String screenTitle;
  final IconData menuIconData;
  final Widget child;
  final Widget action;
  
  Screen(this.screenTitle, this.menuIconData, this.child, {this.action});

}