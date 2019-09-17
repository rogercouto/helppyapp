import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class BarBloc implements BlocBase{

  final _titleController = BehaviorSubject<String>();

  final _actionsController = BehaviorSubject<Widget>();

  Stream get outTitle => _titleController.stream;

  Stream get outAction => _actionsController.stream;

  void changeTitle(String newTitle){
    if (newTitle != null){
      _titleController.sink.add(newTitle);
    }else{
      _titleController.sink.add("Helppy");
    }
  }

  void changeAction(Widget action){
    _actionsController.sink.add(action);
  }

  @override
  void addListener(listener) {
    // TODO: implement addListener
  }

  @override
  void dispose() {
    _titleController.close();
    _actionsController.close();
  }

  @override
  // TODO: implement hasListeners
  bool get hasListeners => null;

  @override
  void notifyListeners() {
    // TODO: implement notifyListeners
  }

  @override
  void removeListener(listener) {
    // TODO: implement removeListener
  }

}